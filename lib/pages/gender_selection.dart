import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laqeene/controller/gender_selection_controller.dart';
class GenderSelection extends StatelessWidget {
  GenderSelectionController genderSelectionController = Get.put(GenderSelectionController());
   GenderSelection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children:
    [
      const Expanded
      (
        child: Text("Gender",
        style: TextStyle(fontSize:18,
        ),
        ),
      ),
      Row(
        children: [
          Obx
            (() =>  Radio(
            value: "Male", 
            groupValue: genderSelectionController.selectedGender.value, 
            onChanged: (value){
              genderSelectionController.onChangeGender(value);
            },
            activeColor: Colors.black,
            fillColor: MaterialStateProperty.all(Colors.black)
            ),
          ),
          const Text("Male",
        style: TextStyle(fontSize:17,
        ),
        ),
        ],
      ),
      Row(
        children: [
          Obx(() => Radio(
            value: "Female", 
            groupValue: genderSelectionController.selectedGender.value, 
            onChanged: (value){
               genderSelectionController.onChangeGender(value);
            },
            activeColor: Colors.black,
            fillColor: MaterialStateProperty.all(Colors.black)
            ) ),
         
            Text("Female",
        style: TextStyle(fontSize:17,
        ),
        ),
        ],
      ),
    ],
    ),
    );
  }
}