import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;
import '../../../../infrastructure/common/repository_url.dart';
import '../models/purchase_view_model.dart';

class UserFlowerHistoryRepository{
  final httpClient = http.Client();
  Map<String,String> customHeaders={"content-type": "application/json"};

  Future<Either<String,List<PurchaseViewModel>>> purchaseHistory(int userId) async{
    final url = Uri.http(RepositoryUrls.fullBaseUrl, 'purchase',{'userId':userId.toString()});
    final response = await http.get(url,headers: customHeaders);

    if(response.statusCode >= 200 && response.statusCode <400){
      final List<PurchaseViewModel> history =[];
      final List<dynamic> historyList = json.decode(response.body);

      for(final items in historyList){
        final userFlowerViewModel = PurchaseViewModel.fromJson(items);
        history.add(userFlowerViewModel);
      }
      return Right(history);
    }
    else{
      return Left("Error: ${response.statusCode}");
    }
  }
}