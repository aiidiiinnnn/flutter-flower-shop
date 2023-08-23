import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/repositories/vendor_flower_list_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taav_ui/taav_ui.dart';

import '../../../../../flower_shop.dart';
import '../../../../infrastructure/utils/taav_list_handler.dart';
import '../../../login_page/models/vendor_models/login_vendor_dto.dart';
import '../models/vendor_flower_dto.dart';

class VendorFlowerListController extends GetxController {
  LoginVendorViewModel? vendor;
  int? vendorId;
  final GlobalKey<TaavGridViewState<VendorFlowerViewModel>> mainKey =
      GlobalKey<TaavGridViewState<VendorFlowerViewModel>>();

  final VendorFlowerListRepository _repository = VendorFlowerListRepository();
  RxList<VendorFlowerViewModel> vendorFlowersList = RxList();
  TaavGridViewHandler<VendorFlowerViewModel> flowersHandler =
      TaavGridViewHandler(limit: 3);
  RxBool isLoading = false.obs;
  RxString isLoadingDelete = "".obs;
  RxBool disableLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool isLoadingDrawer = false.obs;
  RxList<String> countLoading = RxList();
  RxList<bool> disableRefresh = RxList();
  RxList<bool> isOutOfStock = RxList();
  RxBool textFlag = true.obs;
  RxInt pageIndex = RxInt(0);
  PageController pageController = PageController();

  void onDestinationSelected(index) {
    pageIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    pageController = PageController(initialPage: pageIndex.value);
    await sharedVendor().then((id) => vendorId = id);
    await getVendorById();
    // await updateList();
    // await getFlowersByVendorId();
    // await getFlowers();
    await getFlowersWithHandler();
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
    final result = await Get.toNamed(
        "${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.addVendorFlower}");
    if (result != null) {
      final VendorFlowerViewModel newVendorFlower =
          VendorFlowerViewModel.fromJson(result);
      vendorFlowersList.add(newVendorFlower);
      countLoading.add("");
      // disableRefresh.add(false);
      isOutOfStock.add(false);
    }
    pageIndex.value = 0;
    onDestinationSelected(pageIndex.value);
    pageController.jumpToPage(pageIndex.value);
  }

  Future<void> goToSearch() async {
    await Get.toNamed(
        "${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.searchVendorFlower}");
    getFlowersByVendorId();
  }

  Future<void> goToHistory() async {
    Get.toNamed(
        "${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.historyVendorFlower}");
  }

  Future<void> getVendorById() async {
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, LoginVendorViewModel> vendorById =
        await _repository.getVendor(vendorId!);
    vendorById.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
      isLoadingDrawer.value = false;
    }, (vendorViewModel) {
      vendor = vendorViewModel;
      isLoading.value = false;
      isLoadingDrawer.value = false;
    });
  }

  RxBool showError = false.obs;
  RxBool hasMoreData = false.obs;
  RxString errorMessage = ''.obs;
  RxInt page = 1.obs;


  Future<void> getFlowers() async {
    vendorFlowersList.clear();
    isOutOfStock.clear();
    countLoading.clear();

    hasMoreData.value = true;
    showError.value = false;

    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<VendorFlowerViewModel>> flower = await _repository
        .getData(vendor!.firstName, vendor!.lastName, page.value, 5);
    flower.fold((left) {
      Get.snackbar(left, left);
      isRetry.value = true;
      showError.value = true;
    }, (right) {
      hasMoreData.value = false;
      // mainKey.currentState!.addAll(right);
      page.value++;
      vendorFlowersList.addAll(right);
      disableLoading.value = false;
      for (final flower in right) {
        countLoading.add("");
        if (flower.count == 0) {
          isOutOfStock.add(true);
        } else {
          isOutOfStock.add(false);
        }
      }
    });
    isLoading.value = false;
  }

  Future<void> getFlowersWithHandler({final bool resetData = true}) async {
    flowersHandler.prepare(resetData: resetData);

    if(resetData){
      page.value = 1;
      isOutOfStock.clear();
      countLoading.clear();
    }

    final Either<String, List<VendorFlowerViewModel>> result = await _repository
        .getData(vendor!.firstName, vendor!.lastName, page.value, flowersHandler.limit );

    result.fold((exception) {
      Get.snackbar(exception,exception);
      flowersHandler.onError();
    },
        (flowers) {
          flowersHandler.onSuccess(items: flowers);
          page.value++;
          disableLoading.value = false;
          for (final flower in flowers) {
            countLoading.add("");
            if (flower.count == 0) {
              isOutOfStock.add(true);
            } else {
              isOutOfStock.add(false);
            }
          }
        });
  }

  // Future<void> updateList() async {
  //   hasMoreData.value = true;
  //   showError.value = false;
  //   vendorFlowersList.clear();
  //   isOutOfStock.clear();
  //   countLoading.clear();
  //
  //   await _repository.getData(
  //       vendor!.firstName, vendor!.lastName,page.value).then((final data) {
  //     if (data.isEmpty) {
  //       hasMoreData.value = false;
  //     } else {
  //       // hasMoreData.value = true;
  //       vendorFlowersList.addAll(data);
  //       hasMoreData.value = page.value < vendorFlowersList.length;
  //       mainKey.currentState!.addAll(data);
  //       page.value++;
  //
  //       disableLoading.value = false;
  //       for (final flower in data) {
  //         countLoading.add("");
  //         if (flower.count == 0) {
  //           isOutOfStock.add(true);
  //         } else {
  //           isOutOfStock.add(false);
  //         }
  //       }
  //     }
  //   }).onError((final dynamic error, final stackTrace) {
  //     hasMoreData.value = true;
  //     showError.value = true;
  //     errorMessage.value = error.toString();
  //   });
  // }

  Future<void> getFlowersByVendorId() async {
    vendorFlowersList.clear();
    isOutOfStock.clear();
    countLoading.clear();

    hasMoreData.value = true;
    showError.value = false;

    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<VendorFlowerViewModel>> flower = await _repository
        .getFlowerByVendorId(vendor!.firstName, vendor!.lastName, page.value);
    flower.fold((left) {
      Get.snackbar(left, left);
      isRetry.value = true;
      showError.value = true;
    }, (right) {
      hasMoreData.value = false;
      // mainKey.currentState!.addAll(right);
      page.value++;
      vendorFlowersList.addAll(right);
      disableLoading.value = false;
      for (final flower in right) {
        countLoading.add("");
        if (flower.count == 0) {
          isOutOfStock.add(true);
        } else {
          isOutOfStock.add(false);
        }
      }
    });
    isLoading.value = false;
  }

  // Future<void> getFlowersByVendorId() async {
  //   vendorFlowersList.clear();
  //   isOutOfStock.clear();
  //   countLoading.clear();
  //   isLoading.value = true;
  //   isRetry.value = false;
  //   final Either<String, List<VendorFlowerViewModel>> flower =
  //   await _repository.getFlowerByVendorId(
  //       vendor!.firstName, vendor!.lastName,page.value);
  //   flower.fold((left) {
  //     Get.snackbar(left, left);
  //     isRetry.value = true;
  //   }, (right) {
  //     vendorFlowersList.addAll(right);
  //     disableLoading.value = false;
  //     for (final flower in right) {
  //       countLoading.add("");
  //       // disableRefresh.add(false);
  //       if (flower.count == 0) {
  //         isOutOfStock.add(true);
  //       } else {
  //         isOutOfStock.add(false);
  //       }
  //     }
  //   });
  //   isLoading.value = false;
  // }

  Future<void> addFlowerCount(
      {required VendorFlowerViewModel flowerToEdit, required int index}) async {
    disableLoading.value = true;
    countLoading[index] = "${flowerToEdit.id}";
    // disableRefresh[index] = true;
    isOutOfStock[index] = false;
    if (flowerToEdit.count >= 0) {
      final result = await _repository.editFlowerCount(
        dto: _generatePlusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
        disableLoading.value = false;
        countLoading[index] = "";
        // disableRefresh[index] = false;
      }, (auctionId) {
        addCount(index: index);
        disableLoading.value = false;
        countLoading[index] = "";
        // disableRefresh[index] = false;
      });
    }
  }

  VendorFlowerDto _generatePlusDto(VendorFlowerViewModel flowerViewModel) =>
      VendorFlowerDto(
        name: flowerViewModel.name,
        description: flowerViewModel.description,
        imageAddress: flowerViewModel.imageAddress,
        price: flowerViewModel.price,
        color: flowerViewModel.color,
        category: flowerViewModel.category,
        vendorName: flowerViewModel.vendorName,
        vendorImage: flowerViewModel.vendorImage,
        vendorLastName: flowerViewModel.vendorLastName,
        count: ++flowerViewModel.count,
      );

  void addCount({required int index}) {
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount++,
    );
    vendorFlowersList[index] = editedFlower;
  }

  Future<void> minusFlowerCount(
      {required VendorFlowerViewModel flowerToEdit, required int index}) async {
    if (flowerToEdit.count == 1) {
      isOutOfStock[index] = true;
    }
    if (flowerToEdit.count > 0) {
      countLoading[index] = "${flowerToEdit.id}";
      // disableRefresh[index] = true;
      disableLoading.value = true;
      final result = await _repository.editFlowerCount(
        dto: _generateMinusDto(flowerToEdit),
        flowerId: flowerToEdit.id,
      );

      result.fold((exception) {
        Get.snackbar('Exception', exception);
        disableLoading.value = false;
        countLoading[index] = "";
        // disableRefresh[index] = false;
      }, (auctionId) {
        minusCount(index: index);
        disableLoading.value = false;
        countLoading[index] = "";
        // disableRefresh[index] = false;
      });
    }
  }

  VendorFlowerDto _generateMinusDto(VendorFlowerViewModel flowerViewModel) =>
      VendorFlowerDto(
        name: flowerViewModel.name,
        description: flowerViewModel.description,
        imageAddress: flowerViewModel.imageAddress,
        price: flowerViewModel.price,
        color: flowerViewModel.color,
        category: flowerViewModel.category,
        vendorName: flowerViewModel.vendorName,
        vendorLastName: flowerViewModel.vendorLastName,
        vendorImage: flowerViewModel.vendorImage,
        count: --flowerViewModel.count,
      );

  void minusCount({required int index}) {
    int editedCount = vendorFlowersList[index].count;
    final editedFlower = vendorFlowersList[index].copyWith(
      count: editedCount--,
    );
    vendorFlowersList[index] = editedFlower;
  }

  Future<void> deleteFlower(VendorFlowerViewModel flower, int index) async {
    isLoadingDelete.value = "${flower.id}";
    disableLoading.value = true;
    final result = await _repository.deleteFlower(flowerId: flower.id);
    final bool isRecipeDeleted = result == null;
    if (isRecipeDeleted) {
      vendorFlowersList.remove(flower);
      countLoading.remove("");
      // disableRefresh.remove(false);
      isOutOfStock.removeAt(index);
      vendor!.vendorFlowerList.remove(flower.id);
      final result = await _repository.vendorEditFlowerList(
        dto: LoginVendorDto(
            firstName: vendor!.firstName,
            lastName: vendor!.lastName,
            email: vendor!.email,
            password: vendor!.password,
            imagePath: vendor!.imagePath,
            vendorFlowerList: vendor!.vendorFlowerList),
        id: vendorId!,
      );
      result.fold((exception) {
        isLoadingDelete.value = "";
        Get.snackbar('Exception', exception);
        disableLoading.value = false;
      }, (right) {
        isLoadingDelete.value = "";
        disableLoading.value = false;
        TaavToastManager().showToast("Item has been deleted successfully",
            status: TaavWidgetStatus.success);
      });
    } else {
      Get.snackbar('Error', result);
    }
  }

  Future<void> goToEdit(VendorFlowerViewModel flowerViewModel) async {
    final result = await Get.toNamed(
      "${RouteNames.vendorFlowerList}${RouteNames.vendorFlowerHome}${RouteNames.editVendorFlower}",
      arguments: {
        'id': flowerViewModel.id,
        'name': flowerViewModel.name,
        'imageAddress': flowerViewModel.imageAddress,
        'description': flowerViewModel.description,
        "price": flowerViewModel.price,
        "color": flowerViewModel.color,
        "category": flowerViewModel.category,
        "count": flowerViewModel.count,
        "vendorName": flowerViewModel.vendorName,
        "vendorLastName": flowerViewModel.vendorLastName,
        "vendorImage": flowerViewModel.vendorImage,
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
          vendorName: result['vendorName'],
          vendorLastName: result['vendorLastName'],
          vendorImage: result['vendorImage'],
          count: result['count']);
      if (vendorFlowersList[index].count == 0) {
        isOutOfStock[index] = true;
      } else {
        isOutOfStock[index] = false;
      }
    }
  }
}
