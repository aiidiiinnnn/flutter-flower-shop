import 'package:either_dart/either.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../models/purchase_view_model.dart';
import '../repositories/user_flower_history_repository.dart';

class UserFlowerHistoryController extends GetxController {
  final UserFlowerHistoryRepository _repository = UserFlowerHistoryRepository();
  RxList<PurchaseViewModel> historyList = RxList();
  LoginUserViewModel? user;
  int? userId;
  RxBool isLoading = false.obs;
  RxBool isRetry = false.obs;
  RxBool textFlag = true.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await sharedUser().then((id) => userId = id);
    await getUserById();
    await purchaseHistory();
  }

  Future<int?> sharedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt("userId");
  }

  Future<void> getUserById() async {
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, LoginUserViewModel> userById =
        await _repository.getUser(userId!);
    userById.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (userViewModel) {
      user = userViewModel;
      isLoading.value = false;
    });
  }

  Future<void> purchaseHistory() async {
    historyList.clear();
    isLoading.value = true;
    isRetry.value = false;
    final Either<String, List<PurchaseViewModel>> flower =
        await _repository.purchaseHistory(user!.firstName, user!.lastName);
    flower.fold((left) {
      Get.snackbar(left, left);
      isLoading.value = false;
      isRetry.value = true;
    }, (right) {
      historyList.addAll(right);
      isLoading.value = false;
    });
  }
}
