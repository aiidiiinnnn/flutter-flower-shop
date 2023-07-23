import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../../infrastructure/common/repository_url.dart';
import 'package:http/http.dart' as http;
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../../vendor/add_vendor_flower/models/categories/categories_view_model.dart';
import '../../user_flower_cart/models/confirm_purchase/purchase_view_model.dart';
import '../models/user_flower_view_model.dart';

class UserFlowerListRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String,List<UserFlowerViewModel>>> getFlowers() async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<UserFlowerViewModel> userFlowers =[];
      final List<dynamic> userFlowersList = json.decode(response.body);

      for(final items in userFlowersList){
        final userFlowerViewModel = UserFlowerViewModel.fromJson(items);
        userFlowers.add(userFlowerViewModel);
      }
      return Right(userFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String,LoginUserViewModel>> getUser(int id) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'users/$id');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final Map<String, dynamic> user = json.decode(response.body);
      return Right(LoginUserViewModel.fromJson(user));
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String, int>> userEditFlowerList({required LoginUserViewModel dto,required int id,}) async {
    final url= Uri.http(RepositoryUrls.fullBaseUrl, 'users/$id');
    final request = await http.put(url,body: json.encode(dto.toJson()),headers: customHeaders);
    try {
      final editedUser = json.decode(request.body);
      return Right(editedUser['id']);
    }
    catch (e) {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<Either<String,List<UserFlowerViewModel>>> searchFlowers(String name) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers',{'name_like':name});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<UserFlowerViewModel> searchedFlowers =[];
      final List<dynamic> userFlowersList = json.decode(response.body);

      for(final items in userFlowersList){
        final userFlowerViewModel = UserFlowerViewModel.fromJson(items);
        searchedFlowers.add(userFlowerViewModel);
      }
      return Right(searchedFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String,List<PurchaseViewModel>>> purchaseHistory(int userId) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'purchase',{'userId':userId.toString()});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<PurchaseViewModel> history =[];
      final List<dynamic> historyList = json.decode(response.body);

      for(final items in historyList){
        final userFlowerViewModel = PurchaseViewModel.fromJson(items);
        history.add(userFlowerViewModel);
      }
      return Right(history);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String,List<CategoriesViewModel>>> getCategories() async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'categories');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<CategoriesViewModel> categoriesList =[];
      final List<dynamic> categories = json.decode(response.body);

      for(final items in categories){
        final userFlowerViewModel = CategoriesViewModel.fromJson(items);
        categoriesList.add(userFlowerViewModel);
      }
      return Right(categoriesList);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

}