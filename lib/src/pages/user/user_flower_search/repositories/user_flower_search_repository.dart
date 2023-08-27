import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';

import '../../../vendor/add_or_edit_vendor_flower/models/categories/categories_view_model.dart';
import '../../../vendor/add_or_edit_vendor_flower/models/colors/colors_view_model.dart';
import '../models/user_flower_search_view_model.dart';

class UserFlowerSearchRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

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

  Future<Either<String,List<UserFlowerSearchViewModel>>> getFlowers() async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<UserFlowerSearchViewModel> userFlowers =[];
      final List<dynamic> userFlowersList = json.decode(response.body);

      for(final items in userFlowersList){
        final userFlowerViewModel = UserFlowerSearchViewModel.fromJson(items);
        userFlowers.add(userFlowerViewModel);
      }
      return Right(userFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String,List<UserFlowerSearchViewModel>>> searchFlowers({required Map<String,String> query}) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers',query);
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<UserFlowerSearchViewModel> searchedFlowers =[];
      final List<dynamic> userFlowersList = json.decode(response.body);

      for(final items in userFlowersList){
        final userFlowerViewModel = UserFlowerSearchViewModel.fromJson(items);
        searchedFlowers.add(userFlowerViewModel);
      }
      return Right(searchedFlowers);
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

  Future<Either<String,List<ColorsViewModel>>> getColors() async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'colors');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<ColorsViewModel> categoriesList =[];
      final List<dynamic> categories = json.decode(response.body);

      for(final items in categories){
        final userFlowerViewModel = ColorsViewModel.fromJson(items);
        categoriesList.add(userFlowerViewModel);
      }
      return Right(categoriesList);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String,List<UserFlowerSearchViewModel>>> filteredFlower({required Map<String,String> query}) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers', query);
    final response = await http.get(url,headers: customHeaders);
    if(response.statusCode >= 200 && response.statusCode <400){
      final List<UserFlowerSearchViewModel> searchedFlowers =[];
      final List<dynamic> vendorFlowersList = json.decode(response.body);

      for(final items in vendorFlowersList){
        final vendorFlowerViewModel = UserFlowerSearchViewModel.fromJson(items);
        searchedFlowers.add(vendorFlowerViewModel);
      }
      return Right(searchedFlowers);
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

}