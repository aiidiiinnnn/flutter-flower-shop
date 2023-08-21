import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../flower_shop.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../user_flower_cart/models/cart_flower_view_model.dart';
import '../models/user_flower_view_model.dart';
import '../repositories/user_flower_list_repository.dart';
import '../view/screens/user_flower_home.dart';
import '../view/screens/user_flower_profile.dart';

class UserFlowerListController extends GetxController {
  RxList<UserFlowerViewModel> flowersList = RxList();
  RxBool textFlag = true.obs;
  RxInt pageIndex = RxInt(0);
  final UserFlowerListRepository _repository = UserFlowerListRepository();
  LoginUserViewModel? user;
  int? userId;
  RxBool isLoading = false.obs;
  RxBool isLoadingDrawer = true.obs;
  RxBool isRetry = false.obs;
  RxBool disableLoading = false.obs;
  RxMap buyCounting = RxMap();
  RxInt countInCart = RxInt(0);
  RxList<int> maxCount = RxList();
  RxMap<int, bool> isAdded = RxMap();
  RxList<CartFlowerViewModel> shoppingCartList = RxList();
  RxList<bool> addToCartLoading = RxList();
  PageController? pageController;

  void onDestinationSelected(index) {
    pageIndex.value = index;
  }

  final screens = [
    const UserFlowerHome(),
    const UserFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    pageController = PageController(initialPage: pageIndex.value);
    await sharedUser().then((id) => userId = id);
    await getUserById();
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

  Future<void> getUserById() async {
    if (disableLoading.value == false) {
      shoppingCartList.clear();
      addToCartLoading.clear();
      isLoading.value = true;
      isLoadingDrawer.value = true;
      isRetry.value = false;
      final Either<String, LoginUserViewModel> userById =
          await _repository.getUser(userId!);
      userById.fold((left) {
        Get.snackbar(left, left);
        isLoading.value = false;
        isLoadingDrawer.value = false;
        isRetry.value = true;
      }, (userViewModel) async {
        await getFlowers();
        user = userViewModel;
        shoppingCartList.addAll(user!.userFlowerList);
        countInCart.value = shoppingCartList.length;
        for (final flower in flowersList) {
          addToCartLoading.add(false);
          if (user!.userFlowerList.isNotEmpty) {
            for (final cartFlower in user!.userFlowerList) {
              if (cartFlower.id == flower.id) {
                buyCounting[flower.id] = cartFlower.count;
                isAdded[flower.id] = true;
                break;
              } else {
                buyCounting[flower.id] = 1;
                isAdded[flower.id] = false;
              }
            }
          } else {
            buyCounting[flower.id] = 1;
            isAdded[flower.id] = false;
          }
        }
        isLoading.value = false;
        isLoadingDrawer.value = false;
      });
    }
  }

  Future<void> getFlowers() async {
    flowersList.clear();
    maxCount.clear();
    final Either<String, List<UserFlowerViewModel>> flower =
        await _repository.getFlowers();
    flower.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      flowersList.addAll(right);
      for (final flower in flowersList) {
        maxCount.add(flower.count);
      }
      isLoading.value = false;
    });
  }

  Future<void> goToSearch() async {
    await Get.toNamed(
        "${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerSearch}");
    getUserById();
  }

  Future<void> goToHistory() async {
    Get.toNamed(
        "${RouteNames.userFlowerList}${RouteNames.userFlowerHome}${RouteNames.userFlowerHistory}");
  }

  Future<void> onTapIncrement(
      {required UserFlowerViewModel flower, required int index}) async {
    if (buyCounting[flower.id] >= 0 &&
        buyCounting[flower.id] < maxCount[index]) {
      buyCounting[flower.id]++;
    }
  }

  Future<void> onTapDecrement(
      {required UserFlowerViewModel flower, required int index}) async {
    if (buyCounting[flower.id] > 0 &&
        buyCounting[flower.id] <= maxCount[index]) {
      buyCounting[flower.id]--;
    }
  }

  Future<void> onTapDelete(
      {required UserFlowerViewModel flower, required int index}) async {
    disableLoading.value = true;
    addToCartLoading[index] = true;
    for (final cartFlower in shoppingCartList) {
      if (flower.id == cartFlower.id) {
        user!.userFlowerList.remove(cartFlower);
        shoppingCartList.remove(cartFlower);
        break;
      }
    }
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold((exception) {
      Get.snackbar('Exception', exception);
      disableLoading.value = false;
      addToCartLoading[index] = false;
    }, (right) {
      isAdded[flower.id] = true;
      List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
      final editedUser = user!.copyWith(
        userFlowerList: shoppingCart,
      );
      user = editedUser;
      shoppingCartList.clear();
      shoppingCartList.addAll(user!.userFlowerList);
      countInCart.value = shoppingCartList.length;
      isAdded[flower.id] = false;
      disableLoading.value = false;
      addToCartLoading[index] = false;
    });
  }

  Future<void> onTapMinus(
      {required UserFlowerViewModel flower, required int index}) async {
    disableLoading.value = true;
    addToCartLoading[index] = true;
    for (final cartFlower in shoppingCartList) {
      if (flower.id == cartFlower.id) {
        user!.userFlowerList.remove(cartFlower);
        shoppingCartList.remove(cartFlower);
        break;
      }
    }
    if (buyCounting[flower.id] > 0 &&
        buyCounting[flower.id] <= maxCount[index]) {
      buyCounting[flower.id]--;
    }
    user!.userFlowerList.add(CartFlowerViewModel(
        name: flowersList[index].name,
        imageAddress: flowersList[index].imageAddress,
        description: flowersList[index].description,
        price: flowersList[index].price,
        color: flowersList[index].color,
        category: flowersList[index].category,
        vendorName: flowersList[index].vendorName,
        vendorLastName: flowersList[index].vendorLastName,
        vendorImage: flowersList[index].vendorImage,
        count: buyCounting[flower.id],
        id: flower.id,
        totalCount: flowersList[index].count));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold((exception) {
      Get.snackbar('Exception', exception);
      disableLoading.value = false;
      addToCartLoading[index] = false;
    }, (right) {
      isAdded[flower.id] = true;
      List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
      final editedUser = user!.copyWith(
        userFlowerList: shoppingCart,
      );
      user = editedUser;
      shoppingCartList.clear();
      shoppingCartList.addAll(user!.userFlowerList);
      countInCart.value = shoppingCartList.length;
      disableLoading.value = false;
      addToCartLoading[index] = false;
    });
  }

  Future<void> onTapAdd(
      {required UserFlowerViewModel flower, required int index}) async {
    disableLoading.value = true;
    addToCartLoading[index] = true;
    for (final cartFlower in shoppingCartList) {
      if (flower.id == cartFlower.id) {
        user!.userFlowerList.remove(cartFlower);
        shoppingCartList.remove(cartFlower);
        break;
      }
    }
    if (buyCounting[flower.id] >= 0 &&
        buyCounting[flower.id] < maxCount[index]) {
      buyCounting[flower.id]++;
    }
    user!.userFlowerList.add(CartFlowerViewModel(
        name: flowersList[index].name,
        imageAddress: flowersList[index].imageAddress,
        description: flowersList[index].description,
        price: flowersList[index].price,
        color: flowersList[index].color,
        category: flowersList[index].category,
        vendorName: flowersList[index].vendorName,
        vendorLastName: flowersList[index].vendorLastName,
        vendorImage: flowersList[index].vendorImage,
        count: buyCounting[flower.id],
        id: flower.id,
        totalCount: flowersList[index].count));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold((exception) {
      Get.snackbar('Exception', exception);
      disableLoading.value = false;
      addToCartLoading[index] = false;
    }, (right) {
      isAdded[flower.id] = true;
      List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
      final editedUser = user!.copyWith(
        userFlowerList: shoppingCart,
      );
      user = editedUser;
      shoppingCartList.clear();
      shoppingCartList.addAll(user!.userFlowerList);
      countInCart.value = shoppingCartList.length;
      disableLoading.value = false;
      addToCartLoading[index] = false;
    });
  }

  Future<void> addToCart(int index) async {
    shoppingCartList.clear();
    disableLoading.value = true;
    user!.userFlowerList.add(CartFlowerViewModel(
        name: flowersList[index].name,
        imageAddress: flowersList[index].imageAddress,
        description: flowersList[index].description,
        price: flowersList[index].price,
        color: flowersList[index].color,
        category: flowersList[index].category,
        vendorName: flowersList[index].vendorName,
        vendorLastName: flowersList[index].vendorLastName,
        vendorImage: flowersList[index].vendorImage,
        count: buyCounting[flowersList[index].id],
        id: flowersList[index].id,
        totalCount: flowersList[index].count));
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold((exception) {
      Get.snackbar('Exception', exception);
      disableLoading.value = false;
    }, (right) {
      shoppingCartList.addAll(user!.userFlowerList);
      countInCart.value = shoppingCartList.length;
      isAdded[flowersList[index].id] = true;
      List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
      final editedUser = user!.copyWith(
        userFlowerList: shoppingCart,
      );
      user = editedUser;
      disableLoading.value = false;
    });
  }
}
