import 'dart:convert';

import 'package:either_dart/either.dart';
import '../../../../infrastructure/common/repository_url.dart';
import 'package:http/http.dart' as http;
import '../../../login_page/models/user_models/login_user_dto.dart';
import '../../../login_page/models/user_models/login_user_view_model.dart';
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

}