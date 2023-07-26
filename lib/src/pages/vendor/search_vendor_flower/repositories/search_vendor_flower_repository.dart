import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/vendor/search_vendor_flower/view/search_vendor_flower.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
import '../../../login_page/models/vendor_models/login_vendor_dto.dart';
import '../../../login_page/models/vendor_models/login_vendor_view_model.dart';
import '../models/search_vendor_flower_dto.dart';
import '../models/search_vendor_flower_view_model.dart';

class SearchVendorFlowerRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

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

  Future<Either<String,List<SearchVendorFlowerViewModel>>> getFlowerByVendorId(int vendorId) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers',{"vendorId": vendorId.toString()});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<SearchVendorFlowerViewModel> vendorFlowers =[];
      final List<dynamic> vendorFlowersList = json.decode(response.body);

      for(final items in vendorFlowersList){
        final vendorFlowerViewModel = SearchVendorFlowerViewModel.fromJson(items);
        vendorFlowers.add(vendorFlowerViewModel);
      }
      return Right(vendorFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String, int>> editFlowerCount({required SearchVendorFlowerDto dto,required int flowerId,}) async {
    final url= Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/$flowerId');
    final request = await http.put(url,body: json.encode(dto.toJson()),headers: customHeaders);
    try {
      final editedFlower = json.decode(request.body);
      return Right(editedFlower['id']);
    }
    catch (e) {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<String?> deleteFlower ({required int flowerId}) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers/$flowerId');
    final response = await httpClient.delete(url);
    if(response.statusCode >= 200 && response.statusCode < 400 ){
      return null;
    }
    else {
      return 'error ${response.statusCode}';
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

  Future<Either<String,List<SearchVendorFlowerViewModel>>> searchFlowers(String name) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers',{'name_like':name});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<SearchVendorFlowerViewModel> searchedFlowers =[];
      final List<dynamic> userFlowersList = json.decode(response.body);

      for(final items in userFlowersList){
        final userFlowerViewModel = SearchVendorFlowerViewModel.fromJson(items);
        searchedFlowers.add(userFlowerViewModel);
      }
      return Right(searchedFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }

}