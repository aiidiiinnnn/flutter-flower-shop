import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../../vendor/add_vendor_flower/models/categories/categories_view_model.dart';
import '../../../vendor/add_vendor_flower/models/colors/colors_view_model.dart';
import '../../user_flower_cart/models/cart_flower_view_model.dart';
import '../models/user_flower_search_view_model.dart';
import '../repositories/user_flower_search_repository.dart';

class UserFlowerSearchController extends GetxController{
  final GlobalKey<FormState> searchKey=GlobalKey();
  final TextEditingController searchController = TextEditingController();
  final UserFlowerSearchRepository _repository = UserFlowerSearchRepository();
  int? userId;
  RxInt selectedColor=RxInt(1);
  RxInt division = RxInt(0);
  RxDouble minPrice=RxDouble(0);
  RxDouble maxPrice= RxDouble(0);
  LoginUserViewModel? user;
  RxString isLoadingDelete="".obs;
  RxString selectedCategory="".obs;
  RxBool isLoading=false.obs;
  RxBool isRetry=false.obs;
  RxBool textFlag = true.obs;
  RxBool disableLoading=false.obs;
  RxBool isCheckedCategory=false.obs;
  RxBool isCheckedColor=false.obs;
  RxBool isCheckedPrice=false.obs;
  RxBool isFilterDisable=false.obs;
  RxList<UserFlowerSearchViewModel> searchList = RxList();
  RxList<String> countLoading=RxList();
  RxList<bool> isOutOfStock=RxList();
  RxList<int> priceList = RxList();
  RxList<CategoriesViewModel> categoriesFromJson=RxList();
  RxList<String> categoryList=RxList();
  RxList<ColorsViewModel> colorsFromJson=RxList();
  RxList<int> maxCount=RxList();
  RxList<bool> addToCartLoading=RxList();
  Rx<RangeValues> currentRangeValues = Rx<RangeValues>(const RangeValues(0, 100));
  RxMap<int,bool> isAdded=RxMap();
  RxMap buyCounting=RxMap();
  Timer? deBouncer;
  RxBool isFiltered=false.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId=id);
    await getUserById();
    await getCategories();
    await getColors();
  }

  Future<int?> sharedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  Future<void> getUserById() async{
    if(disableLoading.value==false){
      addToCartLoading.clear();
      isLoading.value=true;
      isRetry.value=false;
      final Either<String, LoginUserViewModel> userById = await _repository.getUser(userId!);
      userById.fold(
              (left) {
            print(left);
            isLoading.value=false;
            isRetry.value=true;
          },
              (userViewModel) async {
            await getFlowers();
            user=userViewModel;
            for(final flower in searchList){
              addToCartLoading.add(false);
              if(user!.userFlowerList.isNotEmpty){
                for(final cartFlower in user!.userFlowerList){
                  if(cartFlower.id==flower.id){
                    buyCounting[flower.id]=cartFlower.count;
                    isAdded[flower.id]=true;
                    break;
                  }
                  else{
                    buyCounting[flower.id]=1;
                    isAdded[flower.id]=false;
                  }
                }
              }
              else{
                buyCounting[flower.id]=1;
                isAdded[flower.id]=false;
              }
            }
            isLoading.value=false;
          }
      );
    }
  }

  Future<void> getFlowers() async{
    searchList.clear();
    maxCount.clear();
    isOutOfStock.clear();
    final Either<String,List<UserFlowerSearchViewModel>> flower = await _repository.getFlowers();
    flower.fold(
            (left) {
          print(left);
        },
            (right){
              searchList.addAll(right);
              for(final flower in right){
                maxCount.add(flower.count);
                if(flower.count==0){
                  isOutOfStock.add(true);
                }
                else{
                  isOutOfStock.add(false);
                }
                countLoading.add("");
                priceList.add(flower.price);
              }
              if(searchList.isEmpty){
                isFilterDisable.value=true;
              }
              else{
                priceList.sort();
                minPrice.value=priceList.first.toDouble();
                maxPrice.value=priceList.last.toDouble();
                currentRangeValues = Rx<RangeValues>(RangeValues(minPrice.value, maxPrice.value));
                division.value = (maxPrice.value-minPrice.value).toInt();
              }
        }
    );
  }

  Future<void> searchFlowers(String nameToSearch) async{
    searchList.clear();
    isOutOfStock.clear();
    countLoading.clear();
    maxCount.clear();
    addToCartLoading.clear();
    Map<String, String> query ={};
    query["name_like"]=nameToSearch;
    if(isCheckedCategory.value){
      query["category_like"]=selectedCategory.value;
    }
    if(isCheckedColor.value){
      query["color_like"]=selectedColor.value.toString();
    }
    if(isCheckedPrice.value){
      query["price_gte"]= currentRangeValues.value.start.round().toString();
      query["price_lte"]=currentRangeValues.value.end.round().toString();
    }
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<UserFlowerSearchViewModel>> flower = await _repository.searchFlowers(query: query);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          searchList.addAll(right);
          for(final flower in searchList){
            addToCartLoading.add(false);
            if(user!.userFlowerList.isNotEmpty){
              for(final cartFlower in user!.userFlowerList){
                if(cartFlower.id==flower.id){
                  buyCounting[flower.id]=cartFlower.count;
                  isAdded[flower.id]=true;
                  break;
                }
                else{
                  buyCounting[flower.id]=1;
                  isAdded[flower.id]=false;
                }
              }
            }
            else{
              buyCounting[flower.id]=1;
              isAdded[flower.id]=false;
            }
            maxCount.add(flower.count);
            if(flower.count==0){
              isOutOfStock.add(true);
            }
            else{
              isOutOfStock.add(false);
            }
            countLoading.add("");
          }
          isLoading.value=false;
        }
    );
  }

  Future<void> getCategories() async{
    categoriesFromJson.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<CategoriesViewModel>> flower = await _repository.getCategories();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          categoriesFromJson.addAll(right);
          for(final category in categoriesFromJson){
            categoryList.add(category.name);
          }
          if(categoryList.isNotEmpty){
            selectedCategory.value=categoryList.first;
          }
          isLoading.value=false;
        }
    );
  }

  Future<void> getColors() async{
    colorsFromJson.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<ColorsViewModel>> flower = await _repository.getColors();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          colorsFromJson.addAll(right);
          isLoading.value=false;
        }
    );
  }

  void setSelectedCategory(String value) {
    selectedCategory.value = value;
  }

  void setSelectedColor(int colorValue) {
    selectedColor.value = colorValue;
  }

  void setRange(RangeValues value){
    currentRangeValues.value = value;
  }

  Future deleteFilter() async{
    searchList.clear();
    isOutOfStock.clear();
    countLoading.clear();
    maxCount.clear();
    addToCartLoading.clear();
    Map<String, String> query ={};
    isLoading.value=true;
    final Either<String,List<UserFlowerSearchViewModel>> flower = await _repository.filteredFlower(query: query);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              searchList.addAll(right);
              for(final flower in searchList){
                addToCartLoading.add(false);
                if(user!.userFlowerList.isNotEmpty){
                  for(final cartFlower in user!.userFlowerList){
                    if(cartFlower.id==flower.id){
                      buyCounting[flower.id]=cartFlower.count;
                      isAdded[flower.id]=true;
                      break;
                    }
                    else{
                      buyCounting[flower.id]=1;
                      isAdded[flower.id]=false;
                    }
                  }
                }
                else{
                  buyCounting[flower.id]=1;
                  isAdded[flower.id]=false;
                }
                maxCount.add(flower.count);
                if(flower.count==0){
                  isOutOfStock.add(true);
                }
                else{
                  isOutOfStock.add(false);
                }
                countLoading.add("");
              }
              isFiltered.value=false;
              isLoading.value=false;
        }
    );
  }

  Future filterFlowers() async{
    searchList.clear();
    isOutOfStock.clear();
    countLoading.clear();
    maxCount.clear();
    addToCartLoading.clear();
    Map<String, String> query ={};
    query["name_like"]=searchController.text;
    if(isCheckedCategory.value){
      query["category_like"]=selectedCategory.value;
    }
    if(isCheckedColor.value){
      query["color_like"]=selectedColor.value.toString();
    }
    if(isCheckedPrice.value){
      query["price_gte"]= currentRangeValues.value.start.round().toString();
      query["price_lte"]=currentRangeValues.value.end.round().toString();
    }

    isLoading.value=true;
    final Either<String,List<UserFlowerSearchViewModel>> flower = await _repository.filteredFlower(query: query);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              searchList.addAll(right);
              for(final flower in searchList){
                addToCartLoading.add(false);
                if(user!.userFlowerList.isNotEmpty){
                  for(final cartFlower in user!.userFlowerList){
                    if(cartFlower.id==flower.id){
                      buyCounting[flower.id]=cartFlower.count;
                      isAdded[flower.id]=true;
                      break;
                    }
                    else{
                      buyCounting[flower.id]=1;
                      isAdded[flower.id]=false;
                    }
                  }
                }
                else{
                  buyCounting[flower.id]=1;
                  isAdded[flower.id]=false;
                }
                maxCount.add(flower.count);
                if(flower.count==0){
                  isOutOfStock.add(true);
                }
                else{
                  isOutOfStock.add(false);
                }
                countLoading.add("");
              }
              isFiltered.value=true;
              isLoading.value=false;
        }
    );
  }

  void onTapFilter(){
    if(isFiltered.value=false){
      isCheckedCategory.value=false;
      isCheckedColor.value=false;
      isCheckedPrice.value=false;
      priceList.sort();
      minPrice.value=priceList.first.toDouble();
      maxPrice.value=priceList.last.toDouble();
      currentRangeValues = Rx<RangeValues>(RangeValues(minPrice.value, maxPrice.value));
      division.value = (maxPrice.value-minPrice.value).toInt();
    }
  }

  Future<void> onTapIncrement({required UserFlowerSearchViewModel flower,required int index}) async {
    if(buyCounting[flower.id]>=0 && buyCounting[flower.id] < maxCount[index]){
      buyCounting[flower.id]++;
    }
  }

  Future<void> onTapDecrement({required UserFlowerSearchViewModel flower,required int index}) async {
    if(buyCounting[flower.id]>0 && buyCounting[flower.id] <= maxCount[index]){
      buyCounting[flower.id]--;
    }
  }

  Future<void> onTapDelete({required UserFlowerSearchViewModel flower,required int index}) async {
    disableLoading.value=true;
    addToCartLoading[index]=true;
    for(final cartFlower in user!.userFlowerList){
      if(flower.id==cartFlower.id){
        user!.userFlowerList.remove(cartFlower);
        break;
      }
    }
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          disableLoading.value=false;
          addToCartLoading[index]=false;
        },
            (right) {
          isAdded[flower.id]=true;
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          isAdded[flower.id]=false;
          disableLoading.value=false;
          addToCartLoading[index]=false;
        });
  }

  Future<void> onTapMinus({required UserFlowerSearchViewModel flower,required int index}) async{
    disableLoading.value=true;
    addToCartLoading[index]=true;
    for(final cartFlower in user!.userFlowerList){
      if(flower.id==cartFlower.id){
        user!.userFlowerList.remove(cartFlower);
        break;
      }
    }
    if(buyCounting[flower.id]>0 && buyCounting[flower.id] <= maxCount[index]){
      buyCounting[flower.id]--;
    }
    user!.userFlowerList.add(
        CartFlowerViewModel(
            name: flower.name,
            imageAddress: flower.imageAddress,
            description: flower.description,
            price: flower.price,
            color: flower.color,
            category: flower.category,
            vendorId: flower.vendorId,
            count: buyCounting[flower.id],
            id: flower.id,
            totalCount: flower.count
        ));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          disableLoading.value=false;
          addToCartLoading[index]=false;
        },
            (right) {
          isAdded[flower.id]=true;
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          disableLoading.value=false;
          addToCartLoading[index]=false;
        });
  }

  Future<void> onTapAdd({required UserFlowerSearchViewModel flower,required int index}) async{
    disableLoading.value=true;
    addToCartLoading[index]=true;
    for(final cartFlower in user!.userFlowerList){
      if(flower.id==cartFlower.id){
        user!.userFlowerList.remove(cartFlower);
        break;
      }
    }
    if(buyCounting[flower.id]>=0 && buyCounting[flower.id] < maxCount[index]){
      buyCounting[flower.id]++;
    }
    user!.userFlowerList.add(
        CartFlowerViewModel(
            name: flower.name,
            imageAddress: flower.imageAddress,
            description: flower.description,
            price: flower.price,
            color: flower.color,
            category: flower.category,
            vendorId: flower.vendorId,
            count: buyCounting[flower.id],
            id: flower.id,
            totalCount: flower.count
        ));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          disableLoading.value=false;
          addToCartLoading[index]=false;
        },
            (right) {
          isAdded[flower.id]=true;
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          disableLoading.value=false;
          addToCartLoading[index]=false;
        });
  }

  Future<void> addToCart(int index) async{
    disableLoading.value=true;
    user!.userFlowerList.add(
        CartFlowerViewModel(
            name: searchList[index].name,
            imageAddress: searchList[index].imageAddress,
            description: searchList[index].description,
            price: searchList[index].price,
            color: searchList[index].color,
            category: searchList[index].category,
            vendorId: searchList[index].vendorId,
            count: buyCounting[searchList[index].id],
            id: searchList[index].id,
            totalCount: searchList[index].count
        ));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          disableLoading.value=false;
        },
            (right) {
          isAdded[searchList[index].id]=true;
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          disableLoading.value=false;
        });
  }


}