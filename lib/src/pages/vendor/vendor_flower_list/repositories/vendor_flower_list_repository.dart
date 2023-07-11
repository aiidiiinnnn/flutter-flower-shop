import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:flower_shop/src/pages/login_page/models/vendor_models/login_vendor_view_model.dart';
import 'package:flower_shop/src/pages/vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
class VendorFlowerListRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String,List<VendorFlowerViewModel>>> getFlowerByVendorId(int vendorId) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendorFlowers',{"vendorId": vendorId.toString()});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<VendorFlowerViewModel> vendorFlowers =[];
      final List<dynamic> vendorFlowersList = json.decode(response.body);

      for(final items in vendorFlowersList){
        final vendorFlowerViewModel = VendorFlowerViewModel.fromJson(items);
        vendorFlowers.add(vendorFlowerViewModel);
      }
      return Right(vendorFlowers);
    }
    else{
      return Left("Error: ${response.statusCode}");
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

}