import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_history.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_profile.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/view/screens/vendor_flower_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../../../login_page/models/vendor_models/login_vendor_dto.dart';
import '../../../user/user_flower_cart/models/confirm_purchase/purchase_view_model.dart';
import '../models/vendor_flower_dto.dart';
import '../view/screens/vendor_flower_home.dart';


class VendorFlowerListController extends GetxController{
  RxList<PurchaseViewModel> historyList = RxList();
  RxInt selectedColor=RxInt(1);
  RxList<Map<dynamic,dynamic>> salesList = RxList();
  RxList<int> priceList = RxList();
  RxDouble minPrice=RxDouble(0);
  RxDouble maxPrice= RxDouble(0);
  RxInt division = RxInt(0);
  RxList<dynamic> categoryList=RxList();
  RxString selectedCategory="".obs;
  RxList<dynamic> colorList=RxList();
  LoginVendorViewModel? vendor;
  final GlobalKey<FormState> searchKey=GlobalKey();
  final TextEditingController searchController = TextEditingController();
  int? vendorId;
  RxBool isChecked = false.obs;
  final VendorFlowerListRepository _repository = VendorFlowerListRepository();
  RxList<VendorFlowerViewModel> vendorFlowersList =RxList();
  RxList<VendorFlowerViewModel> searchedFlowersList =RxList();
  RxBool isLoading=true.obs;
  RxString isLoadingDelete="".obs;
  RxBool disableLoading=false.obs;
  RxBool isRetry=false.obs;
  RxBool isLoadingDrawer=true.obs;
  RxBool isRetryDrawer=false.obs;
  RxList<String> countLoading=RxList();
  RxList<bool> isOutOfStock=RxList();
  RxBool textFlag = true.obs;
  RxInt index=RxInt(0);
  RxMap colorsOnTap={}.obs;
  Rx<RangeValues> currentRangeValues = Rx<RangeValues>(const RangeValues(0, 100));
  RxBool isCheckedCategory=false.obs;
  RxBool isCheckedColor=false.obs;
  RxBool isCheckedPrice=false.obs;

  void setRange(RangeValues value){
    currentRangeValues.value = value;
  }

  void setSelected(String value) {
    selectedCategory.value = value;
  }

  void onDestinationSelected(index){
    this.index.value=index;
  }

  final screens = [
    const VendorFlowerHome(),
    const VendorFlowerHistory(),
    const VendorFlowerSearch(),
    const VendorFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedVendor().then((id) => vendorId=id);
    await getVendorById();
    await getFlowersByVendorId();
    await purchaseHistory();
  }

  void setSelectedColor(int colorValue) {
    selectedColor.value = colorValue;
  }

  Future<int?> sharedVendor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("vendorId");
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAndToNamed(RouteNames.loginPage);
  }

  Future<void> goToAdd() async {
    final result = await Get.toNamed("${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.addVendorFlower}");
    if (result != null) {
      final VendorFlowerViewModel newVendorFlower = VendorFlowerViewModel
          .fromJson(result);
      vendorFlowersList.add(newVendorFlower);
      countLoading.add("");
      isOutOfStock.add(false);
    }
  }

  Future<void> getVendorById() async{
    isLoading.value=true;
    isRetry.value=false;
    isRetryDrawer.value=false;
    final Either<String, LoginVendorViewModel> vendorById = await _repository.getVendor(vendorId!);
    vendorById.fold(
            (left) {
              print(left);
              isLoading.value=false;
              isRetry.value=true;
              isLoadingDrawer.value=false;
              isRetryDrawer.value=true;
            },
            (vendorViewModel) {
              vendor=vendorViewModel;
              isLoading.value=false;
              isLoadingDrawer.value=false;
            }
    );
  }

  Future<void> getFlowersByVendorId() async{
    searchedFlowersList.clear();
    vendorFlowersList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<VendorFlowerViewModel>> flower = await _repository.getFlowerByVendorId(vendorId!);
    flower.fold(
            (left) {
          print(left);
          isRetry.value=true;
        },
            (right){
          vendorFlowersList.addAll(right);
          searchedFlowersList.addAll(right);
          for(final flower in right){
            categoryList.addAll(flower.category);
            colorList.addAll(flower.color);
            priceList.add(flower.price);
            countLoading.add("");
            if(flower.count==0){
              isOutOfStock.add(true);
            }
            else{
              isOutOfStock.add(false);
            }
          }
          int i=0;
          for(final flower in colorList){
            colorsOnTap[i]=false;
            i++;
          }
          // selectedCategory.value=categoryList.first ;
          priceList.sort();
          if(priceList.isNotEmpty){
            minPrice.value=priceList.first.toDouble();
            maxPrice.value=priceList.last.toDouble();
          }
          currentRangeValues = Rx<RangeValues>(RangeValues(minPrice.value, maxPrice.value));
          division.value = (maxPrice.value-minPrice.value).toInt();
        }
    );
    isLoading.value=false;
  }

  Future<void> addFlowerCount({required VendorFlowerViewModel flowerToEdit, required int index}) async {
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

  VendorFlowerDto _generatePlusDto(VendorFlowerViewModel flowerViewModel) => VendorFlowerDto(
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
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount++,
    );
    vendorFlowersList[index] = editedFlower;
  }


  Future<void> minusFlowerCount({required VendorFlowerViewModel flowerToEdit, required int index}) async {
    // isOutOfStock[index]=false;
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

  VendorFlowerDto _generateMinusDto(VendorFlowerViewModel flowerViewModel) => VendorFlowerDto(
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
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount--,
    );
    vendorFlowersList[index] = editedFlower;
  }

  Future<void> deleteFlower(VendorFlowerViewModel flower) async {
    isLoadingDelete.value="${flower.id}";
    disableLoading.value=true;
    final result = await _repository.deleteFlower(flowerId: flower.id);
    final bool isRecipeDeleted = result == null;
    if (isRecipeDeleted) {
      vendorFlowersList.remove(flower);
      countLoading.remove("");
      isOutOfStock.remove(false);
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

  Future<void> goToEdit(VendorFlowerViewModel flowerViewModel) async {
    final result = await Get.toNamed("${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.editVendorFlower}",
      arguments: {
        'id': flowerViewModel.id,
        'name': flowerViewModel.name,
        'imageAddress': flowerViewModel.imageAddress,
        'description': flowerViewModel.description,
        "price": flowerViewModel.price,
        "color": flowerViewModel.color,
        "category": flowerViewModel.category,
        "count": flowerViewModel.count,
        "vendorId": flowerViewModel.vendorId,
      },
    );
    final bool isFlowerEdited = result != null;
    if (isFlowerEdited) {
      final int index = vendorFlowersList.indexOf(flowerViewModel);
      vendorFlowersList[index] = VendorFlowerViewModel(
          id: result['id'],
          name: result['name'],
          imageAddress: result['imageAddress'],
          description: result['description'],
          price: result['price'],
          color: result['color'],
          category: result['category'],
          vendorId: result['vendorId'],
          count: result['count']
      );
    }
  }

  void searchFlower(String searchedText){
    searchedFlowersList.value = vendorFlowersList.where((searchedFlower) {
      var flowerName = searchedFlower.name.toLowerCase();
      var flowerDescription = searchedFlower.description.toLowerCase();
      return flowerName.contains(searchedText) || flowerDescription.contains(searchedText);
    }).toList();
  }

  Future<void> purchaseHistory() async{
    historyList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<PurchaseViewModel>> flower = await _repository.purchaseHistory();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              historyList.addAll(right);
              for(final flower in right){
                for(final purchase in flower.purchaseList){
                  if(purchase.vendorId==vendorId!){
                    salesList.add({"card":purchase, "date":flower.date});
                  }
                }
              }
          isLoading.value=false;
        }
    );
  }

  Future filterFlowers() async{
    Map<String, String> query ={};
    if(isCheckedCategory.value){
      query["category_like"]=selectedCategory.value;
    }
    if(isCheckedColor.value){
      query["color_like"]=selectedColor.value.toString();
    }
    if(isCheckedPrice.value){
      query["price_gte"]= minPrice.value.toString();
      query["price_lte"]=maxPrice.value.toString();
    }

    isLoading.value=true;
    final Either<String,List<VendorFlowerViewModel>> flower = await _repository.filteredFlower(query: query);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              searchedFlowersList.clear();
          searchedFlowersList.addAll(right);
          isLoading.value=false;
        }
    );
  }

  Future deleteFilter() async{
    Map<String, String> query ={};
    isLoading.value=true;
    final Either<String,List<VendorFlowerViewModel>> flower = await _repository.filteredFlower(query: query);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              searchedFlowersList.clear();
          searchedFlowersList.addAll(right);
          isLoading.value=false;
        }
    );
  }


}