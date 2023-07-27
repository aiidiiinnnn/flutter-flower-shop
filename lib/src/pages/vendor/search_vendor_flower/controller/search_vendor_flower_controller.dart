import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login_page/models/vendor_models/login_vendor_dto.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../../add_vendor_flower/models/categories/categories_view_model.dart';
import '../../add_vendor_flower/models/colors/colors_view_model.dart';
import '../models/search_vendor_flower_dto.dart';
import '../models/search_vendor_flower_view_model.dart';
import '../repositories/search_vendor_flower_repository.dart';

class SearchVendorFlowerController extends GetxController{
  final GlobalKey<FormState> searchKey=GlobalKey();
  final TextEditingController searchController = TextEditingController();
  final SearchVendorFlowerRepository _repository = SearchVendorFlowerRepository();
  int? vendorId;
  RxInt selectedColor=RxInt(1);
  RxInt division = RxInt(0);
  RxDouble minPrice=RxDouble(0);
  RxDouble maxPrice= RxDouble(0);
  LoginVendorViewModel? vendor;
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
  RxList<SearchVendorFlowerViewModel> searchList = RxList();
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
    await sharedVendor().then((id) => vendorId=id);
    await getVendorById();
    await getFlowersByVendorId();
    await getCategories();
    await getColors();
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  Future<void> getVendorById() async{
    isLoading.value=true;
    isRetry.value=false;
    final Either<String, LoginVendorViewModel> vendorById = await _repository.getVendor(vendorId!);
    vendorById.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (vendorViewModel) {
          vendor=vendorViewModel;
          isLoading.value=false;
        }
    );
  }

  Future<void> getFlowersByVendorId() async{
    if(disableLoading.value==false){
      searchList.clear();
      isOutOfStock.clear();
      countLoading.clear();
      isLoading.value=true;
      isRetry.value=false;
      final Either<String,List<SearchVendorFlowerViewModel>> flower = await _repository.getFlowerByVendorId(vendorId!);
      flower.fold(
              (left) {
            print(left);
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
      isLoading.value=false;
    }
  }

  Future<void> addFlowerCount({required SearchVendorFlowerViewModel flowerToEdit, required int index}) async {
    disableLoading.value=true;
    countLoading[index]="${flowerToEdit.id}";
    isOutOfStock[index]=false;
    if (flowerToEdit.count >= 0){
      final result = await _repository.editFlowerCount(
        dto: _generatePlusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
        disableLoading.value=false;
        countLoading[index]="";
      }, (auctionId) {
        addCount(index: index);
        disableLoading.value=false;
        countLoading[index]="";
      });
    }
  }

  SearchVendorFlowerDto _generatePlusDto(SearchVendorFlowerViewModel flowerViewModel) => SearchVendorFlowerDto(
    name: flowerViewModel.name,
    description: flowerViewModel.description,
    imageAddress: flowerViewModel.imageAddress,
    price: flowerViewModel.price,
    color: flowerViewModel.color,
    category: flowerViewModel.category,
    vendorId: flowerViewModel.vendorId,
    count: ++ flowerViewModel.count,
  );

  void addCount({required int index}) {
    int editedCount = searchList[index].count;
    final editedFlower = searchList[index].copyWith(
      count: editedCount++,
    );
    searchList[index] = editedFlower;
  }

  Future<void> minusFlowerCount({required SearchVendorFlowerViewModel flowerToEdit, required int index}) async {
    if(flowerToEdit.count==1){
      isOutOfStock[index]=true;
    }
    if (flowerToEdit.count > 0){
      countLoading[index]="${flowerToEdit.id}";
      disableLoading.value=true;
      final result = await _repository.editFlowerCount(
        dto: _generateMinusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
        disableLoading.value=false;
        countLoading[index]="";
      }, (auctionId) {
        minusCount(index: index);
        disableLoading.value=false;
        countLoading[index]="";
      });
    }
  }

  SearchVendorFlowerDto _generateMinusDto(SearchVendorFlowerViewModel flowerViewModel) => SearchVendorFlowerDto(
    name: flowerViewModel.name,
    description: flowerViewModel.description,
    imageAddress: flowerViewModel.imageAddress,
    price: flowerViewModel.price,
    color: flowerViewModel.color,
    category: flowerViewModel.category,
    vendorId: flowerViewModel.vendorId,
    count: -- flowerViewModel.count,
  );

  void minusCount({required int index}) {
    int editedCount = searchList[index].count;
    final editedFlower = searchList[index].copyWith(
      count: editedCount--,
    );
    searchList[index] = editedFlower;
  }

  Future<void> deleteFlower(SearchVendorFlowerViewModel flower,int index) async {
    isLoadingDelete.value="${flower.id}";
    disableLoading.value=true;
    final result = await _repository.deleteFlower(flowerId: flower.id);
    final bool isRecipeDeleted = result == null;
    if (isRecipeDeleted) {
      searchList.remove(flower);
      countLoading.remove("");
      isOutOfStock.removeAt(index);
      vendor!.vendorFlowerList.remove(flower.id);
      final result = await _repository.vendorEditFlowerList(
        dto: LoginVendorDto(
            firstName: vendor!.firstName,
            lastName: vendor!.lastName,
            email: vendor!.email,
            password: vendor!.password,
            imagePath: vendor!.imagePath,
            vendorFlowerList: vendor!.vendorFlowerList
        ),
        id: vendorId!,
      );
      result.fold(
              (exception) {
            isLoadingDelete.value="";
            Get.snackbar('Exception', exception);
            disableLoading.value=false;
          },
              (right) {
            isLoadingDelete.value="";
            disableLoading.value=false;
            Get.snackbar('Deleted', "Item has been deleted successfully");
          }
      );
    }
    else {
      Get.snackbar('Error',result);
    }
  }

  Future<void> searchFlowers(String nameToSearch) async{
    searchList.clear();
    isOutOfStock.clear();
    Map<String, String> query ={};
    query["vendorId"]="${vendorId!}";
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
    final Either<String,List<SearchVendorFlowerViewModel>> flower = await _repository.searchFlowers(query: query);
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
    final Either<String,List<SearchVendorFlowerViewModel>> flower = await _repository.filteredFlower(query: query);
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
    query["vendorId"]="${vendorId!}";
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
    final Either<String,List<SearchVendorFlowerViewModel>> flower = await _repository.filteredFlower(query: query);
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