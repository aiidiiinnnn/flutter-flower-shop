import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/flower_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? role = prefs.getString('role');
  bool? isLogged = prefs.getBool('remember_me');
  runApp(FlowerApp(isLogged: isLogged, role: role));
}
