import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_dto.dart';
import 'package:flower_shop/src/pages/vendor/add_vendor_flower/models/add_vendor_flower_view_model.dart';
import 'package:http/http.dart' as http;

import '../../../../infrastructure/common/repository_url.dart';

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
}