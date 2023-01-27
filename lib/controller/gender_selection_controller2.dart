import 'package:get/get.dart';

class GenderSelectionController2 extends GetxController{
  var selectedGender = "".obs;
  onChangeGender(var gender){
    selectedGender.value = gender;
  }
}
