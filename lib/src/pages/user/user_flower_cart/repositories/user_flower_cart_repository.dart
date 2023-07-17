import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
import '../../../vendor/vendor_flower_list/models/vendor_flower_dto.dart';
import '../models/confirm_purchase/purchase_dto.dart';
import '../models/confirm_purchase/purchase_view_model.dart';

class UserFlowerCartRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

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

  Future<Either<String, PurchaseViewModel>> purchaseFlower(PurchaseDto dto) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'purchase');
    final request = await http.post(url,body: json.encode(dto.toJson()),headers: customHeaders);

    if(request.statusCode >= 200 && request.statusCode < 400){
      return Right(
          PurchaseViewModel.fromJson(
              json.decode(request.body)
          )
      );
    }
    else {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<Either<String, int>> userEditFlowerList({required LoginUserDto dto,required int id,}) async {
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

  Future<Either<String, int>> editFlowerCount({required VendorFlowerDto dto,required int id,}) async {
    final url= Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/$id');
    final request = await http.put(url,body: json.encode(dto.toJson()),headers: customHeaders);
    try {
      final editedFlower = json.decode(request.body);
      return Right(editedFlower['id']);
    }
    catch (e) {
      return Left('There was an error: ${request.statusCode}');
    }
  }

}