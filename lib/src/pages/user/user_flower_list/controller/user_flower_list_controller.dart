import 'package:either_dart/either.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../flower_shop.dart';
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../models/user_flower_view_model.dart';
import '../repositories/user_flower_list_repository.dart';
import '../view/screens/user_flower_home.dart';
import '../view/screens/user_flower_profile.dart';

class UserFlowerListController extends GetxController{
  RxList<UserFlowerViewModel> flowersList =RxList();
  RxBool isChecked = false.obs;
  RxInt pageIndex=RxInt(0);
  final UserFlowerListRepository _repository = UserFlowerListRepository();
  LoginUserViewModel? user;
  int? userId;
  RxBool isLoading=true.obs;
  RxBool isRetry=false.obs;
  RxMap buyCounting={}.obs;


  void onDestinationSelected(index){
    pageIndex.value=index;
  }

  final screens = [
    const UserFlowerHome(),
    const Center(child: Text('History',style: TextStyle(fontSize: 72),)),
    const Center(child: Text('Search',style: TextStyle(fontSize: 72),)),
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
          }
          isLoading.value=false;
        }
    );
  }

  Future<void> onTapIncrement({required UserFlowerViewModel user,required int index}) async {
    if(buyCounting[index]>=0 && buyCounting[index] < user.count){
      buyCounting[index]++;
    }
  }

  Future<void> onTapDecrement({required UserFlowerViewModel user,required int index}) async {
    if(buyCounting[index]>0 && buyCounting[index] <= user.count){
      buyCounting[index]--;
    }
  }

  Future<void> addToCart(int index) async{
    user!.userFlowerList.add({'id':index, 'count': buyCounting[index]});
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
            (right) {
              List shoppingCart = user!.userFlowerList;
              final editedUser = user!.copyWith(
                userFlowerList: shoppingCart,
              );
              user = editedUser;
            });
  }

}