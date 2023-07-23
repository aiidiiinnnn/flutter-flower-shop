import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_dto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../models/cart_Flower/cart_flower_view_model.dart';
import '../models/confirm_purchase/purchase_dto.dart';
import '../models/confirm_purchase/purchase_view_model.dart';
import '../repositories/user_flower_cart_repository.dart';

class UserFlowerCartController extends GetxController {
  RxBool isLoading = true.obs;
  RxBool isRetry = false.obs;
  RxBool isLoadingPurchase = true.obs;
  RxBool isLoadingDelete = true.obs;
  final UserFlowerCartRepository _repository = UserFlowerCartRepository();
  LoginUserViewModel? user;
  int? userId;
  RxList<CartFlowerViewModel> cartFlowerList = RxList();
  RxBool textFlag = true.obs;
  String? date;
  RxInt totalPrice=RxInt(0);

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId = id);
    await getUserById();
  }

  Future<int?> sharedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  void setDate() {
    DateTime now = DateTime.now();
    date = "${now.year}-${now.month}-${now.day} ${now.hour}:${now.minute}";
  }

  Future<void> getUserById() async {
    cartFlowerList.clear();
    // user!.userFlowerList.clear();
    isLoading.value = true;
    isLoadingPurchase.value = true;
    isLoadingDelete.value = true;
    isRetry.value = false;
    final Either<String, LoginUserViewModel> userById = await _repository
        .getUser(userId!);
    userById.fold(
            (left) {
          print(left);
          isLoading.value = false;
          isRetry.value = true;
        },
            (userViewModel) {
          user = userViewModel;
          cartFlowerList.clear();
          totalPrice=RxInt(0);
          cartFlowerList.addAll(user!.userFlowerList);
          for(final cart in cartFlowerList){
            totalPrice.value += cart.price*cart.count;
          }
          isLoading.value = false;
          isLoadingPurchase.value = false;
          isLoadingDelete.value = false;
        }
    );
  }

  Future<void> deleteFromCart(CartFlowerViewModel flower) async {
    user!.userFlowerList.remove(flower);
    isLoadingDelete.value = true;
    final result = await _repository.userEditFlowerList(
      dto: LoginUserDto(
          firstName: user!.firstName,
          lastName: user!.lastName,
          email: user!.email,
          password: user!.password,
          imagePath: user!.imagePath,
          userFlowerList: user!.userFlowerList
      ),
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
          isLoadingDelete.value = false;
        },
            (right) {
          cartFlowerList.remove(flower);
          Get.snackbar(
              'Deleted', "flower successfully deleted from shopping cart"
          );
          totalPrice.value = totalPrice.value - (flower.count*flower.price);
          isLoadingDelete.value = false;
        });
  }

  Future<void> purchaseFlower() async {
    isLoadingPurchase.value = true;
    setDate();
    final dto = PurchaseDto(
        purchaseList: user!.userFlowerList,
        date: date!,
        userId: userId!
    );
    final Either<String, PurchaseViewModel> request = await _repository
        .purchaseFlower(dto);
    request.fold(
            (left) {
          print(left);
          isLoadingPurchase.value = false;
        },
            (purchasedFlower) async {
              user!.userFlowerList.clear();
              final result = await _repository.userEditFlowerList(
                dto: LoginUserDto(
                    firstName: user!.firstName,
                    lastName: user!.lastName,
                    email: user!.email,
                    password: user!.password,
                    imagePath: user!.imagePath,
                    userFlowerList: user!.userFlowerList
                ),
                id: userId!,
              );
              result.fold(
                      (exception) {
                    Get.snackbar('Exception', exception);
                  },
                      (right) async {
                        for (final purchasedFlower in purchasedFlower.purchaseList) {
                          user!.userFlowerList.remove(purchasedFlower);
                          final result = await _repository.editFlowerCount(
                              dto: VendorFlowerDto(
                                  name: purchasedFlower.name,
                                  imageAddress: purchasedFlower.imageAddress,
                                  description: purchasedFlower.description,
                                  price: purchasedFlower.price,
                                  color: purchasedFlower.color,
                                  category: purchasedFlower.category,
                                  vendorId: purchasedFlower.vendorId,
                                  count: (purchasedFlower.totalCount - purchasedFlower.count)
                              ),
                              id: purchasedFlower.id
                          );
                          result.fold(
                                  (exception) {
                                Get.snackbar('Exception', exception);
                              },
                                  (right){
                                user!.userFlowerList.clear();
                                cartFlowerList.clear();
                                totalPrice=RxInt(0);
                                // Get.snackbar(
                                //     'Purchased', "purchase was made successfully"
                                // );
                                isLoadingPurchase.value = false;

                              });
                        }
                        Get.back(result: true);
                  });

        }
    );
  }

  // Future<void> purchaseFlower() async {
  //   isLoadingPurchase.value = true;
  //   setDate();
  //   final dto = PurchaseDto(
  //       purchaseList: user!.userFlowerList,
  //       date: date!,
  //       userId: userId!
  //   );
  //   final Either<String, PurchaseViewModel> request = await _repository
  //       .purchaseFlower(dto);
  //   request.fold(
  //           (left) {
  //             print(left);
  //             isLoadingPurchase.value = false;
  //           },
  //           (right) async {
  //             user!.userFlowerList.clear();
  //         for (final purchasedFlower in right.purchaseList) {
  //           final result = await _repository.editFlowerCount(
  //               dto: VendorFlowerDto(
  //                   name: purchasedFlower.name,
  //                   imageAddress: purchasedFlower.imageAddress,
  //                   description: purchasedFlower.description,
  //                   price: purchasedFlower.price,
  //                   color: purchasedFlower.color,
  //                   category: purchasedFlower.category,
  //                   vendorId: purchasedFlower.vendorId,
  //                   count: (purchasedFlower.totalCount - purchasedFlower.count)
  //               ),
  //               id: purchasedFlower.id
  //           );
  //           result.fold(
  //                   (exception) {
  //                 Get.snackbar('Exception', exception);
  //               },
  //                   (right) async {
  //                 final result = await _repository.userEditFlowerList(
  //                   dto: LoginUserDto(
  //                       firstName: user!.firstName,
  //                       lastName: user!.lastName,
  //                       email: user!.email,
  //                       password: user!.password,
  //                       imagePath: user!.imagePath,
  //                       userFlowerList: user!.userFlowerList
  //                   ),
  //                   id: userId!,
  //                 );
  //                 result.fold(
  //                         (exception) {
  //                       Get.snackbar('Exception', exception);
  //                     },
  //                         (right) {
  //                           user!.userFlowerList.clear();
  //                           cartFlowerList.clear();
  //                           totalPrice=RxInt(0);
  //                           Get.snackbar(
  //                               'Purchased', "purchase was made successfully"
  //                           );
  //                           isLoadingPurchase.value = false;
  //                           Get.back();
  //                     });
  //               });
  //         }
  //       }
  //   );
  // }
}