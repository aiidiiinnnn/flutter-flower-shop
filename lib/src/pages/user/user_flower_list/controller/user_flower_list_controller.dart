import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/user/user_flower_cart/models/cart_Flower/cart_flower_view_model.dart';
import 'package:flower_shop/src/pages/user/user_flower_list/view/screens/user_flower_search.dart';
import 'package:flutter/cupertino.dart';
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
  RxBool isChecked = false.obs;
  RxInt pageIndex=RxInt(0);
  final TextEditingController searchController = TextEditingController();
  final UserFlowerListRepository _repository = UserFlowerListRepository();
  LoginUserViewModel? user;
  int? userId;
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;
  RxMap buyCounting={}.obs;
  RxInt countInCart = RxInt(0);
  List<int> maxCount=[];
  final GlobalKey<FormState> searchKey=GlobalKey();

  void onDestinationSelected(index){
    pageIndex.value=index;
  }

  final screens = [
    const UserFlowerHome(),
    const Center(child: Text('History',style: TextStyle(fontSize: 72),)),
    const UserFlowerSearch(),
    const UserFlowerProfile(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId=id);
    await getUserById();
    await getFlowers();
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
    isRetry.value=false;
    final Either<String, LoginUserViewModel> userById = await _repository.getUser(userId!);
    userById.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (userViewModel) {
          user=userViewModel;
          countInCart.value = user!.userFlowerList.length;
          isLoading.value=false;
        }
    );
  }

  Future<void> getFlowers() async{
    flowersList.clear();
    isLoading.value=true;
    isRetry.value=false;
    final Either<String,List<UserFlowerViewModel>> flower = await _repository.getFlowers();
    flower.fold(
            (left) {
          print(left);
          isLoading.value=false;
          isRetry.value=true;
        },
            (right){
          flowersList.addAll(right);
          for(final flower in flowersList){
            buyCounting[flower.id-1]=1;
            maxCount.add(flower.count);
          }
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
    user!.userFlowerList.add(CartFlowerViewModel(
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
    )
    );
    final result = await _repository.userEditFlowerList(
      dto: user!,
      id: userId!,
    );
    result.fold(
            (exception) {
          Get.snackbar('Exception', exception);
        },
            (right) {
              countInCart.value = user!.userFlowerList.length;
              maxCount[index]-buyCounting[index];
              List<CartFlowerViewModel> shoppingCart = user!.userFlowerList;
              final editedUser = user!.copyWith(
                userFlowerList: shoppingCart,
              );
              user = editedUser;
            });
  }

}