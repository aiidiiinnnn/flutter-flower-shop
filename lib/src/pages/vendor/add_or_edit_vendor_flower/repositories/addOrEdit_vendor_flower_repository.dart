import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_dto.dart';
import 'package:http/http.dart' as http;

import '../../../../infrastructure/common/repository_url.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/addOrEdit_vendor/addOrEdit_vendor_flower_view_model.dart';
import '../models/addOrEdit_vendor/add_vendor_flower_dto.dart';
import '../models/addOrEdit_vendor/edit_vendor_flower_dto.dart';
import '../models/categories/categories_dto.dart';
import '../models/categories/categories_view_model.dart';
import '../models/colors/color_dto.dart';
import '../models/colors/colors_view_model.dart';


class AddOrEditVendorFlowerRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String, AddOrEditVendorFlowerViewModel>> addVendorFlower(AddVendorFlowerDto dto) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers');
    final request = await http.post(url,body: json.encode(dto.toJson()),headers: customHeaders);

    if(request.statusCode >= 200 && request.statusCode < 400){
      return Right(
          AddOrEditVendorFlowerViewModel.fromJson(
              json.decode(request.body)
          )
      );
    }
    else {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<Either<String,LoginVendorViewModel>> getVendor(int id) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendors/$id');
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final Map<String, dynamic> vendor = json.decode(response.body);
      return Right(LoginVendorViewModel.fromJson(vendor));
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String, int>> vendorEditFlowerList({required LoginVendorDto dto,required int id,}) async {
    final url= Uri.http(RepositoryUrls.fullBaseUrl, 'vendors/$id');
    final request = await http.put(url,body: json.encode(dto.toJson()),headers: customHeaders);
    try {
      final editedVendor = json.decode(request.body);
      return Right(editedVendor['id']);
    }
    catch (e) {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<Either<String, CategoriesViewModel>> addCategories(CategoriesDto dto) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'categories');
    final request = await http.post(url,body: json.encode(dto.toJson()),headers: customHeaders);

    if(request.statusCode >= 200 && request.statusCode < 400){
      return Right(
          CategoriesViewModel.fromJson(
              json.decode(request.body)
          )
      );
    }
    else {
      return Left('There was an error: ${request.statusCode}');
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

  Future<Either<String,List<CategoriesViewModel>>> getCategoriesAutoComplete(String filter) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'categories',{
      'name_like': filter,
    },);
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

  Future<Either<String, ColorsViewModel>> addColors(ColorsDto dto) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'colors');
    final request = await http.post(url,body: json.encode(dto.toJson()),headers: customHeaders);

    if(request.statusCode >= 200 && request.statusCode < 400){
      return Right(
          ColorsViewModel.fromJson(
              json.decode(request.body)
          )
      );
    }
    else {
      return Left('There was an error: ${request.statusCode}');
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

  Future<Either<String, AddOrEditVendorFlowerViewModel>> getFlowerById(
      final int flowerId) async {
    final url = Uri.http(
      RepositoryUrls.fullBaseUrl,
      'vendorFlowers/$flowerId',
    );
    final result = await httpClient.get(url, headers: customHeaders);
    if (result.statusCode >= 200 && result.statusCode < 400) {
      return Right(
          AddOrEditVendorFlowerViewModel.fromJson(json.decode(result.body)));
    } else {
      return Left('Error ${result.statusCode}');
    }
  }

  Future<Either<String, Map<String, dynamic>>> editFlower(
      {required EditVendorFlowerDto flowerDto}) async {
    final url =
    Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/${flowerDto.id}');
    final String bodyForSendToServer = json.encode(flowerDto.toJson());
    final result = await httpClient.put(url,
        body: bodyForSendToServer, headers: customHeaders);
    if (result.statusCode >= 200 && result.statusCode < 400) {
      final Map<String, dynamic> convertedJsonBodyTooMap =
      json.decode(result.body);
      return Right(convertedJsonBodyTooMap);
    } else {
      return Left('Error Code ${result.statusCode}');
    }
  }


}