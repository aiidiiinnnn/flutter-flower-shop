import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_Flower/cart_flower_view_model.dart';
import 'package:flower_shop/src/pages/user/user_flower_cart/models/confirm_purchase/purchase_view_model.dart';
import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_history.dart';
import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../../vendor/add_vendor_flower/models/categories/categories_view_model.dart';
import '../models/user_flower_view_model.dart';
import '../repositories/user_flower_list_repository.dart';
import '../view/screens/user_flower_home.dart';
import '../view/screens/user_flower_profile.dart';

class UserFlowerListController extends GetxController{
  RxList<UserFlowerViewModel> flowersList =RxList();
  RxList<UserFlowerViewModel> searchList = RxList();
  RxList<PurchaseViewModel> historyList = RxList();
  RxBool isChecked = false.obs;
  RxBool textFlag = true.obs;
  RxInt pageIndex=RxInt(0);
  RxList<int> priceList = RxList();
  RxInt division = RxInt(0);
  RxString selectedCategory="".obs;
  RxList<dynamic> colorList=RxList();
  final TextEditingController searchController = TextEditingController();
  final UserFlowerListRepository _repository = UserFlowerListRepository();
  LoginUserViewModel? user;
  int? userId;
  RxDouble minPrice=RxDouble(0);
  RxDouble maxPrice= RxDouble(0);
  RxInt selectedColor=RxInt(1);
  RxBool isLoading=true.obs;
  RxBool isLoadingDrawer=true.obs;
  RxBool isRetry=false.obs;
  RxBool isLoadingAddToCart=true.obs;
  RxBool isRetryAddToCart=false.obs;
  RxMap buyCounting={}.obs;
  RxMap colorsOnTap={}.obs;
  RxInt countInCart = RxInt(0);
  List<int> maxCount=[];
  final GlobalKey<FormState> searchKey=GlobalKey();
  RxList<CategoriesViewModel> categoriesFromJson=RxList();
  Rx<RangeValues> currentRangeValues = Rx<RangeValues>(const RangeValues(0, 100));

  void setRange(RangeValues value){
    currentRangeValues.value = value;
  }

  void onDestinationSelected(index){
    pageIndex.value=index;
  }

  final screens = [
    const UserFlowerHome(),
    const UserFlowerHistory(),
    const UserFlowerSearch(),
    const UserFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId=id);
    await getUserById();
    // await getFlowers();
    await purchaseHistory();
    await getCategories();
  }

  void setSelectedCategory(String value) {
    selectedCategory.value = value;
  }

  Future<int?> sharedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Get.offAndToNamed(RouteNames.loginPage);
  }

  Future<void> getUserById() async{
    isLoading.value=true;
    isLoadingDrawer.value=true;
    isRetry.value=false;
    final Either<String, LoginUserViewModel> userById = await _repository.getUser(userId!);
    userById.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isLoadingDrawer.value=false;
          isRetry.value=true;
        },
            (userViewModel) async {
              await getFlowers();
          user=userViewModel;
          countInCart.value = user!.userFlowerList.length;
          isLoading.value=false;
          isLoadingDrawer.value=false;
        }
    );
  }

  Future<void> getFlowers() async{
    flowersList.clear();
    final Either<String,List<UserFlowerViewModel>> flower = await _repository.getFlowers();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          flowersList.addAll(right);
          int i=0;
          for(final flower in flowersList){
            buyCounting[i]=1;
            i++;
            maxCount.add(flower.count);
            priceList.add(flower.price);
            colorList.addAll(flower.color);
          }
          for(final flowerColor in colorList){
            colorsOnTap[i]=false;
            i++;
          }
          priceList.sort();
          minPrice.value=priceList.first.toDouble();
          maxPrice.value=priceList.last.toDouble();
          currentRangeValues = Rx<RangeValues>(RangeValues(minPrice.value, maxPrice.value));
          division.value = (maxPrice.value-minPrice.value).toInt();
          // isLoading.value=false;
          isLoadingAddToCart.value=false;
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
          // selectedCategory.value=categoriesFromJson.first.name;
          isLoading.value=false;
        }
    );
  }

  Future<void> searchFlowers(String nameToSearch) async{
    searchList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<UserFlowerViewModel>> flower = await _repository.searchFlowers(nameToSearch);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
              searchList.clear();
              searchList.addAll(right);
              isLoading.value=false;
        }
    );
  }

  Future<void> purchaseHistory() async{
    historyList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<PurchaseViewModel>> flower = await _repository.purchaseHistory(userId!);
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          historyList.addAll(right);
          isLoading.value=false;
        }
    );
  }

  Future<void> onTapIncrement({required UserFlowerViewModel user,required int index}) async {
    if(buyCounting[index]>=0 && buyCounting[index] < maxCount[index]){
      buyCounting[index]++;
    }
  }

  Future<void> onTapDecrement({required UserFlowerViewModel user,required int index}) async {
    if(buyCounting[index]>0 && buyCounting[index] <= maxCount[index]){
      buyCounting[index]--;
    }
  }

  Future<void> addToCart(int index) async{
    // user!.userFlowerList.clear();

    isLoadingAddToCart.value=true;
    isRetryAddToCart.value=false;
    user!.userFlowerList.add(
        CartFlowerViewModel(
        name: flowersList[index].name,
        imageAddress: flowersList[index].imageAddress,
        description: flowersList[index].description,
        price: flowersList[index].price,
        color: flowersList[index].color,
        category: flowersList[index].category,
        vendorId: flowersList[index].vendorId,
        count: buyCounting[index],
        id: flowersList[index].id,
        totalCount: flowersList[index].count
    ));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          isLoadingAddToCart.value=false;
          isRetryAddToCart.value=true;
        },
            (right) {
              // await getUserById();
              countInCart.value = user!.userFlowerList.length;
              maxCount[index]= (maxCount[index]-buyCounting[index]).toInt();
              List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
              final editedUser = user!.copyWith(
                userFlowerList: shoppingCart,
              );
              user = editedUser;
              isLoadingAddToCart.value=false;
            });
  }

}