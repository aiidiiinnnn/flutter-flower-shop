import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../../infrastructure/common/repository_url.dart';
import '../../../vendor/vendor_flower_list/models/vendor_flower_view_model.dart';
import 'package:http/http.dart' as http;
import '../models/user_flower_view_model.dart';

class UserFlowerListRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String,List<UserFlowerViewModel>>> getFlowers(int vendorId) async{
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

}