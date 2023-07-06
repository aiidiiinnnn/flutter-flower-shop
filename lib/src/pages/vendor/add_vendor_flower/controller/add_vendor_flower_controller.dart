import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../repositories/add_vendor_flower_repository.dart';


class AddVendorFlowerController extends GetxController{
  final AddVendorFlowerRepository _repository = AddVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<String> colorList=[];
  List<Color> newColorList=[];

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    currentColor = color;
    colorList.add("$currentColor");
    newColorList.add(currentColor);
  }

  String? nameValidator(final String? name){
    if(name == null || name.isEmpty){
      return "Please enter name correctly";
    }
    return null;
  }

  String? descriptionValidator(final String? description){
    if(description == null || description.isEmpty){
      return "Please enter description correctly";
    }
    return null;
  }

  String? priceValidator(final String? basePrice){
    if(basePrice == null || basePrice.isEmpty){
      return "Please enter price correctly";
    }
    return null;
  }
}