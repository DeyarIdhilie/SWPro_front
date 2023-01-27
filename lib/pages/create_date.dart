import 'dart:async';
import 'dart:math';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart' show showDialog, AlertDialog;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';
import 'package:laqeene/pages/gender_selection2.dart';
import 'package:laqeene/pages/location_page.dart';
import 'package:laqeene/pages/map.dart';
import 'package:laqeene/widget/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart'hide Response,FormData,MultipartFile;
import '../controller/gender_selection_controller2.dart';

class CreateDatePage extends StatefulWidget {
  const CreateDatePage({Key? key}) : super(key: key);

  @override
  State<CreateDatePage> createState() => _CreateDatePageState();
}

class _CreateDatePageState extends State<CreateDatePage> {
  RangeValues values = const RangeValues(0.0,1.0);
  DateTime? _selectedDate;
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String? theDate;
  String? theTime;
  double? min_age_gap = 0;
  double? max_age_gap = 100;
  List<String> tags = [];
  List<String> options = [
    'Have a drink','Study partner','Talking','Voluntery','Grab a bite','Walking'
  ];
  TextEditingController _date = TextEditingController();
  TextEditingController _time = TextEditingController();
  TextEditingController _time2 = TextEditingController();
  String? _text = "";
  String? description = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Future<void>  _createDate() async {
    print("send request");
   final storage = new FlutterSecureStorage();
   String? token = await storage.read(key: 'token');
   
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    double? latitude = prefs.getDouble("latitude");
    double? longitude = prefs.getDouble("longitude");
    GenderSelectionController2 genderSelectionController = Get.find();
    String? username = prefs.getString('username');
    String? gender = prefs.getString('gender');
    String? birthday = prefs.getString('birthday');
    String? image = prefs.getString('imageUrl');
    final hour = startTime.hour;
    final formattedHour = hour < 10 ? hour.toString().padLeft(2, '0') : hour.toString();
    final fullStartDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse('$theDate $formattedHour:${startTime.minute}:00');
    final fullStartDateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(fullStartDate);
    final hour2 = endTime.hour;
    final formattedHour2 = hour2 < 10 ? hour2.toString().padLeft(2, '0') : hour2.toString();
    final fullEndtDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse('$theDate $formattedHour2:${endTime.minute}:00');
 
    final fullEndtDateString = DateFormat("yyyy-MM-dd HH:mm:ss").format(fullEndtDate);
    Response response = await dio.post('http://192.168.1.7:3002/date',
    data:{"creator_username": username,"creator_birthday":birthday,
    "creator_gender": gender,"creator_image":image,
    "preferable_gender":genderSelectionController.selectedGender.value,
    "preferable_age_gap":{"min_age_gap":min_age_gap,"max_age_gap":max_age_gap},
    "location":{"type":"point","coordinates":[longitude,latitude]},
    "tags":tags, "description":description, "startDate":fullStartDateString,
     "endDate":fullEndtDateString},);
     if(response.data == "success"){
      showDialog(
         context: context,
         builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Success Message'),
         content: Row(
            children: <Widget>[
              Icon(Icons.add_task_rounded, size: 40,color: Colors.lightGreen,),
              SizedBox(width: 10),
              Text('Date is successfuly created'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                 Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
                // setState(() => isAlertSet = false);
                // _getCurrentPosition();
              },
              child: const Text('OK'),
            ),
          ],
        )
         );
     }

  }

   @override
  Widget build(BuildContext context) {
    RangeLabels labels = RangeLabels(((values.start)*100).toString(), ((values.end)*100).toString());
    return Scaffold(
          appBar: AppBar(
        leading: IconButton(onPressed: (){
           Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => MainScreen()));
        }
        ,icon: const Icon(Icons.arrow_back_ios, color:Colors.black,size: 20, ),
        ),
        title:Expanded(
          child:Align(
            alignment: Alignment.center,
            child:Text(
            "Create New Date\t\t\t\t\t\t\t",
             style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
          ),
          ),
        ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.white,
        elevation: 0.0,

        ),
        body: SafeArea(
           child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
             child:Form(
                key: _formkey,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center ,
                  children: [
                    SizedBox(height: 20,),
                        Padding(
                    padding: const EdgeInsets.only(top:15,bottom:10,left: 25,right: 25),
                    child: TextFormField(
                     
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 3,
                      cursorHeight: 5.0,
                      decoration: InputDecoration(
    // hintText: "Description",
    labelText: "Description",
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: TextStyle(color: Colors.black),
    prefixIcon: Icon(Icons.edit),
     contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Set equal padding on top and bottom
     counter: Text('${_text!.length}/150'), // character count
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
  ),
                      validator: (value) {
                           if(value == null) {
                           return 'Please add description';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please add description';
                      }        
                    else
                       { 
                        if (value!.length > 150) 
                        {
                          return 'Description should be 150 characters or less';
                          }
                          return null;
                       }
                          },
                      onChanged: (String? value){
                         setState(() {
                                      _text = value;
                                 });
                          if(_formkey.currentState!.validate())
                              description=value;    
                      },
                    ),
                  ),
                  SizedBox(
                 
                  height: 10,
                ),
                 Padding(
                  padding: const EdgeInsets.only(bottom:5,left: 25,right: 25),
                  child:Row(
                     children: [
                               Expanded(
                                flex: 2,
                                child: TextFormField(
                    controller: _date,
                 
                     decoration: InputDecoration(
    // hintText: "Description",
    labelText: "Add Date",
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: TextStyle(color: Colors.black),
    prefixIcon: Icon(Icons.calendar_today_rounded),
    contentPadding: EdgeInsets.only(left: 0,right:10), // Set equal padding on top and bottom
     
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
  ),
                    onTap:() async {              
               final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(2023),
                lastDate: DateTime(2100),
              );

             
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _date.text= DateFormat("yyyy-MM-dd").format(date);
                   theDate= DateFormat("yyyy-MM-dd").format(date);
                });
              }
              

            },
            validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please add a date';
                      }        
                    
                      return null;
                    },
                    
                  ),
                                        ),
                               SizedBox(width: 5),
                               Expanded(
                                 flex:1,
                                    child: TextFormField(
                    controller: _time,
                 
                     decoration: InputDecoration(
    // hintText: "Description",
    labelText: "Start at",
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: TextStyle(color: Colors.black),
    prefixIcon: Icon(Icons.schedule),
     contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Set equal padding on top and bottom
     
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
  ),
                    onTap:() async {              
               final start = await showTimePicker(
                context: context,
                initialTime: startTime ?? TimeOfDay.now(),
                
              );

             
              if (start != null) {
                setState(() {
                   startTime = start;
                   _time.text= '${start.hour}:${start.minute}';
                  //  theDate= DateFormat("yyyy-MM-dd").format(date);
                  
                });
              }
              

            },
            validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please add a\n start time';
                      }        
                    
                      return null;
                    },
                    
                  ),
               
                           ),
                            SizedBox(width: 5),
                     
                               Expanded(
                                 flex:1,
                                    child: TextFormField(
                    controller: _time2,
                 
                     decoration: InputDecoration(
    // hintText: "Description",
    labelText: "End at",
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelStyle: TextStyle(color: Colors.black),
    prefixIcon: Icon(Icons.schedule),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0), // Set equal padding on top and bottom
     
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
    enabledBorder:OutlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
      ),
    ),
  ),
                    onTap:() async {              
               final end = await showTimePicker(
                context: context,
                initialTime: endTime ?? TimeOfDay.now(),
                
              );

             
              if (end != null) {
                setState(() {
                   endTime = end;
                   _time2.text= '${end.hour}:${end.minute}';
                  //  theDate= DateFormat("yyyy-MM-dd").format(date);
                  
                });
              }
              

            },
            validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please add an\n end time';
                      }        
                    
                      return null;
                    },
                    
                  ),
               
                           ),
                             ],
                           ),
            ),
             Padding(
                  padding: const EdgeInsets.only(right:130, top:25),
                  child:Text("Do you prefer an age gap range?",
                    style: TextStyle(fontSize:16),
                  ),
             ),
              Padding(
               padding: const EdgeInsets.only(top:10,left: 15,right: 15 ),
               child: RangeSlider(
                values: values,
                divisions: 100,
                labels: labels,
                activeColor: Colors.grey.shade500,
                inactiveColor:  Colors.black,
                onChanged: (newValues) {
                  setState(() {
                    values = newValues;
                    min_age_gap = values.start *100;
                    max_age_gap = values.end *100;
                  });
                },
               ),
              ),
                       Padding(
                  padding: const EdgeInsets.only(top:20,bottom: 20,right:120),
                  child:Text("Do you prefere a specific gender?",
                    style: TextStyle(fontSize:16),
                  ),
             ),
               Padding(
                  padding: const EdgeInsets.only(bottom: 20,left: 40,right: 40),
                  child:GenderSelection(),
                  

                  ),
                     Padding(
                  padding: const EdgeInsets.only(bottom: 10,right:70),
                  child:Text("Are you looking for something specific?",
                    style: TextStyle(fontSize:16),
                  ),
             ),
            Padding(
               padding: const EdgeInsets.only(top:5,left: 15,right: 15,bottom: 20  ),
              child: Column(
                children: [
                  ChipsChoice<String>.multiple(
                    value: tags, 
                    onChanged: (val) => setState(() => tags = val),
                    choiceItems: C2Choice.listFrom(source: options,
                     value: (i, v) => v, 
                     label: (i, v) => v,
                     ), 
                     choiceActiveStyle: const C2ChoiceStyle(
                      color: Colors.grey,
                      ),
                    choiceStyle: const C2ChoiceStyle(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                        ),
                      ),
                      wrapped: true,
                      
                      
                    )
                ],
              ),
              ),
            
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
                          foregroundColor:MaterialStateProperty.all<Color>(Colors.black),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(1),
                                  side: BorderSide(color: Colors.grey)
                              ),
                             
                          ),
                           padding: MaterialStateProperty.all((EdgeInsets.symmetric(horizontal: 15 ))),
                    
                      ),
                    
                      onPressed: () {
                        if(_formkey.currentState!.validate())
                           _createDate();
                            
                        
                          } 
                        
                     ,child: Text("Create"),
                    
                  ),
                ),
                     ],
                     ),
                     ),
           ),
        ),
    );
  }
}