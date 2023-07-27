import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../../login_page/models/vendor_models/login_vendor_dto.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../../../vendor/add_vendor_flower/models/categories/categories_view_model.dart';
import '../../../vendor/add_vendor_flower/models/colors/colors_view_model.dart';
import '../models/user_flower_search_dto.dart';
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
  RxBool isLoading=true.obs;
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
  Rx<RangeValues> currentRangeValues = Rx<RangeValues>(const RangeValues(0, 100));

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
          isLoading.value=false;
        }
    );
  }

  Future<void> getFlowers() async{
    searchList.clear();
    final Either<String,List<UserFlowerSearchViewModel>> flower = await _repository.getFlowers();
    flower.fold(
            (left) {
          print(left);
        },
            (right){
              searchList.addAll(right);
              for(final flower in right){
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
    Map<String, String> query ={};
    query["vendorId"]="${userId!}";
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
          for(final flower in right){
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
          searchList.clear();
          searchList.addAll(right);
          for(final flower in right){
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

  Future filterFlowers() async{
    searchList.clear();
    isOutOfStock.clear();
    countLoading.clear();
    Map<String, String> query ={};
    query["vendorId"]="${userId!}";
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
          for(final flower in right){
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

  void onTapFilter(){
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