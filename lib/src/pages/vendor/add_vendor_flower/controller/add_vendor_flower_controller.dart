import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../repositories/add_vendor_flower_repository.dart';


class AddVendorFlowerController extends GetxController{
  final AddVendorFlowerRepository _repository = AddVendorFlowerRepository();
  final GlobalKey<FormState> formKey=GlobalKey();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

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