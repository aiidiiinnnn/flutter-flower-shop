import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_Flower/cart_flower_view_model.dart';
import 'package:flower_shop/src/pages/user/user_flower_cart/models/confirm_purchase/purchase_view_model.dart';
import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../models/user_flower_view_model.dart';
import '../repositories/user_flower_list_repository.dart';
import '../view/screens/user_flower_home.dart';
import '../view/screens/user_flower_profile.dart';

class UserFlowerListController extends GetxController{
  RxList<UserFlowerViewModel> flowersList =RxList();
  RxList<PurchaseViewModel> historyList = RxList();
  RxBool isChecked = false.obs;
  RxBool textFlag = true.obs;
  RxInt pageIndex=RxInt(0);
  final UserFlowerListRepository _repository = UserFlowerListRepository();
  LoginUserViewModel? user;
  int? userId;
  RxBool isLoading=true.obs;
  RxBool isLoadingDrawer=true.obs;
  RxBool isRetry=false.obs;
  RxBool isLoadingAddToCart=false.obs;
  RxMap buyCounting={}.obs;
  RxInt countInCart = RxInt(0);
  RxList<int> maxCount=RxList();
  RxList<bool> isAdded=RxList();
  final GlobalKey<FormState> searchKey=GlobalKey();
  RxBool disableLoading=false.obs;
  RxList<CartFlowerViewModel> shoppingCartList=RxList();

  void onDestinationSelected(index){
    pageIndex.value=index;
  }

  final screens = [
    const UserFlowerHome(),
    const UserFlowerHistory(),
    const UserFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId=id);
    await getUserById();
    await purchaseHistory();
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
    isAdded.clear();
    shoppingCartList.clear();
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
              shoppingCartList.addAll(user!.userFlowerList);
              countInCart.value = shoppingCartList.length;
              int i=0;
              for(final flower in flowersList){
                if(user!.userFlowerList.isNotEmpty){
                  for(final cartFlower in user!.userFlowerList){
                    if(flower.id==cartFlower.id){
                      buyCounting[i]=cartFlower.count;
                      isAdded.add(true);
                    }
                    else{
                      buyCounting[i]=1;
                      isAdded.add(false);
                    }
                  }
                }
                else{
                  buyCounting[i]=1;
                  isAdded.add(false);
                }
                i++;
              }
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
            maxCount.add(flower.count);
            i++;
          }
          isLoading.value=false;
        }
    );
  }

  Future<void> goToSearch() async {
    await Get.toNamed("${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerSearch}");
    getUserById();
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

  Future<void> onTapMinus({required int index}) async{
    isLoadingAddToCart.value=true;
    for(final cartFlower in user!.userFlowerList){
      if(flowersList[index].id==cartFlower.id){
        user!.userFlowerList.remove(cartFlower);
      }
    }
    if(buyCounting[index]>0 && buyCounting[index] <= maxCount[index]){
      buyCounting[index]--;
    }
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
        },
            (right) {
          countInCart.value = shoppingCartList.length;
          isAdded[index]=true;
          maxCount[index]= (maxCount[index]-buyCounting[index]).toInt();
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          isLoadingAddToCart.value=false;
        });
  }


  Future<void> onTapAdd({required int index}) async{
    isLoadingAddToCart.value=true;
    for(final cartFlower in shoppingCartList){
      if(flowersList[index].id==cartFlower.id){
        user!.userFlowerList.remove(cartFlower);
      }
    }
    if(buyCounting[index]>=0 && buyCounting[index] < maxCount[index]){
      buyCounting[index]++;
    }
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
        },
            (right) {
          countInCart.value = shoppingCartList.length;
          isAdded[index]=true;
          maxCount[index]= (maxCount[index]-buyCounting[index]).toInt();
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          isLoadingAddToCart.value=false;
        });
  }

  Future<void> addToCart(int index) async{
    isLoadingAddToCart.value=true;
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
        },
            (right) {
              countInCart.value = shoppingCartList.length;
              isAdded[index]=true;
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