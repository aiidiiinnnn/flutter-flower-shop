import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_dto.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_dto.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_view_model.dart';
import 'package:http/http.dart' as http;

import '../../../../infrastructure/common/repository_url.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';


class AddVendorFlowerRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String, AddVendorFlowerViewModel>> addVendorFlower(AddVendorFlowerDto dto) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers');
    final request = await http.post(url,body: json.encode(dto.toJson()),headers: customHeaders);

    if(request.statusCode >= 200 && request.statusCode < 400){
      return Right(
          AddVendorFlowerViewModel.fromJson(
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

}