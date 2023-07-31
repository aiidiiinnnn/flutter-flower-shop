import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

import '../../../infrastructure/common/repository_url.dart';
import '../models/user_models/login_user_view_model.dart';
import '../models/vendor_models/login_vendor_view_model.dart';

class LoginPageRepository {
  final httpClient = http.Client();
  Map<String, String> customHeaders = {"content-type": "application/json"};

  Future<Either<String, List<LoginVendorViewModel>>> getVendorByEmailPassword(
      {required String email, required String password}) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'vendors',
        {'email': email, 'password': password});
    final response = await http.get(url, headers: customHeaders);

    if (response.statusCode >= 200 && response.statusCode < 400) {
      final List<LoginVendorViewModel> vendor = [];
      final List<dynamic> vendorList = json.decode(response.body);
      for (final vendor1 in vendorList) {
        final loginPageViewModel = LoginVendorViewModel.fromJson(vendor1);
        vendor.add(loginPageViewModel);
      }
      return Right(vendor);
    } else {
      return Left("Error: ${response.statusCode}");
    }
  }

  Future<Either<String, List<LoginUserViewModel>>> getUserByEmailPassword(
      {required String email, required String password}) async {
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'users',
        {'email': email, 'password': password});
    final response = await http.get(url, headers: customHeaders);

    if (response.statusCode >= 200 && response.statusCode < 400) {
      final List<LoginUserViewModel> user = [];
      final List<dynamic> userList = json.decode(response.body);

      for (final user1 in userList) {
        final loginPageViewModel = LoginUserViewModel.fromJson(user1);
        user.add(loginPageViewModel);
      }
      return Right(user);
    } else {
      return Left("Error: ${response.statusCode}");
    }
  }
}
