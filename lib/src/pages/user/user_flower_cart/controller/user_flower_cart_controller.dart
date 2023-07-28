import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_dto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../user_flower_history/models/purchase_view_model.dart';
import '../../user_flower_history/models/purchase_dto.dart';
import '../models/cart_flower_view_model.dart';
import '../repositories/user_flower_cart_repository.dart';

class UserFlowerCartController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool isLoadingPurchase = false.obs;
  RxBool isLoadingDelete = false.obs;
  final UserFlowerCartRepository _repository = UserFlowerCartRepository();
  LoginUserViewModel? user;
  int? userId;
  RxList<CartFlowerViewModel> cartFlowerList = RxList();
  RxBool textFlag = true.obs;
  String? date;
  RxInt totalPrice=RxInt(0);
  RxList<bool> countLoading=RxList();
  RxBool disableLoading=false.obs;

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
    countLoading.clear();
    totalPrice.value=totalPrice.value-totalPrice.value;
    isLoading.value = true;
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
          cartFlowerList.addAll(user!.userFlowerList);
          for(final cart in cartFlowerList){
            totalPrice.value = (cart.price*cart.count)+totalPrice.value;
            countLoading.add(false);
          }
          isLoading.value = false;
        }
    );
  }

  Future<void> onTapDelete({required CartFlowerViewModel flower,required int index}) async {
    disableLoading.value=true;
    countLoading[index]=true;

    user!.userFlowerList.removeAt(index);

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
          disableLoading.value=false;
          countLoading[index]=false;
        },
            (right) {
              List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
              final editedUser = user!.copyWith(
                userFlowerList: shoppingCart,
              );
              user = editedUser;
              cartFlowerList.remove(flower);
              Get.snackbar(
                  'Deleted', "flower successfully deleted from shopping cart"
              );
              totalPrice.value = totalPrice.value - (flower.count*flower.price);
              disableLoading.value=false;
              countLoading[index]=false;
            });
  }

  Future<void> onTapMinus({required CartFlowerViewModel flower,required int index}) async{
    disableLoading.value=true;
    countLoading[index]=true;

    user!.userFlowerList.removeAt(index);

    if(flower.count>0 && flower.count <= flower.totalCount){
      flower.count--;
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
            count: flower.count,
            id: flower.id,
            totalCount: flower.totalCount
        ));
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
          disableLoading.value=false;
          countLoading[index]=false;
        },
            (right) {
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          totalPrice.value = totalPrice.value-flower.price;
          disableLoading.value=false;
          countLoading[index]=false;
        });
  }

  Future<void> onTapAdd({required CartFlowerViewModel flower,required int index}) async{
    disableLoading.value=true;
    countLoading[index]=true;

    user!.userFlowerList.removeAt(index);

    if(flower.count>=0 && flower.count < flower.totalCount){
      flower.count++;
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
            count: flower.count,
            id: flower.id,
            totalCount: flower.totalCount
        ));
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
          disableLoading.value=false;
          countLoading[index]=false;
        },
            (right) {
          List<CartFlowerViewModel> shoppingCart = (user!.userFlowerList);
          final editedUser = user!.copyWith(
            userFlowerList: shoppingCart,
          );
          user = editedUser;
          totalPrice.value = totalPrice.value+flower.price;
          disableLoading.value=false;
          countLoading[index]=false;
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
                                isLoadingPurchase.value = false;

                              });
                        }
                        Get.back(result: true);
                  });

        }
    );
  }

}