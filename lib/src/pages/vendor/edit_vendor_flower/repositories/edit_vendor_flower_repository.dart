import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/edit_vendor_flower/models/edit_vendor_flower_dto.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
import '../models/edit_vendor_flower_view_model.dart';

class EditVendorFlowerRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String, EditVendorFlowerViewModel>> getFlowerById(final int flowerId) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/$flowerId',);
    final result = await httpClient.get(url,headers: customHeaders);
    if(result.statusCode >= 200 && result.statusCode <400){
      return Right(EditVendorFlowerViewModel.fromJson(json.decode(result.body)));
    }
    else {
      return Left('Error ${result.statusCode}');
    }
  }

  Future<Either<String, Map<String, dynamic>>> editFlower ({required EditVendorFlowerDto flowerDto}) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/${flowerDto.id}');
    final String bodyForSendToServer = json.encode(flowerDto.toJson());
    final result = await httpClient.put(url, body: bodyForSendToServer, headers: customHeaders);
    if(result.statusCode >= 200 && result.statusCode <400){
      final Map<String, dynamic> convertedJsonBodyTooMap =  json.decode(result.body);
      return Right(convertedJsonBodyTooMap);
    }
    else {
      return Left('Error Code ${result.statusCode}');
    }
  }

}