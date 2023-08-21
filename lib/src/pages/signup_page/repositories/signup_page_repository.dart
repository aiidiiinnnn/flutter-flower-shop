import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/common/repository_url.dart';
import '../models/user_models/signup_user_dto.dart';
import '../models/user_models/signup_user_view_model.dart';
import '../models/vendor_models/signup_vendor_dto.dart';
import '../models/vendor_models/signup_vendor_view_model.dart';

class SignupPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, SignupVendorViewModel>> addVendor(
      SignupVendorDto dto) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendors');
    final request = await http.post(url,
        body: json.encode(dto.toJson()), headers: customHeaders);

    if (request.statusCode >= 200 && request.statusCode < 400) {
      return Right(SignupVendorViewModel.fromJson(json.decode(request.body)));
    } else {
      return Left('There was an error: ${request.statusCode}');
    }
  }

  Future<Either<String, SignupUserViewModel>> addUser(SignupUserDto dto) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'users');
    final request = await http.post(url,
        body: json.encode(dto.toJson()), headers: customHeaders);

    if (request.statusCode >= 200 && request.statusCode < 400) {
      return Right(SignupUserViewModel.fromJson(json.decode(request.body)));
    } else {
      return Left('There was an error: ${request.statusCode}');
    }
  }
}
