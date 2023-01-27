import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/widgets.dart' show showDialog, AlertDialog;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart'hide Response,FormData,MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:laqeene/controller/signup_controller.dart';
import 'package:laqeene/pages/InputDeco_design.dart';
import 'package:laqeene/pages/location_page.dart';
import 'package:laqeene/pages/multi_line_fields.dart';
import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../app.dart';
import '../widget/main_screen.dart';

class CreateProfilePage extends StatefulWidget {
  
  CreateProfilePage({Key? key}) : super(key: key);

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  _CreateProfilePageState (){
    city= _cities[0];
    _schoolSelectedPrivacy= _privacyList[0];
   _citySelectedPrivacy= _privacyList[0];
   _uniSelectedPrivacy= _privacyList[0];
   _jobSelectedPrivacy= _privacyList[0];
  }
  File? pickedFile;
  SignUpController signUpController = Get.put(SignUpController());
  SignUpController signUpControllerr = Get.find();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  ImagePicker imagePicker = ImagePicker();
  int tag = 1;
  bool connect = false;
  List<String> tags = [];
  List<String> options = [
    'Technology','Science','Sports','Beauty','Fashion','Cultures','Music'
    ,'Kpop','Tiktok','Instagram','Photography','Languages','Religions','Reading'
    ,'Cooking','Food','Video Games','Traveling','Board Games','Movie Watching'
    ,'Painting','Politics',"Animal care","feminisim","Human rights movments", "Mental Health"
  ];
  String? bio ='';
  String? school ='';
  String? university ='';
  String? city ='';
  String? job ='';
  final _privacyList= ["public","private"];
  final _cities = ["Nablus","Tulkarm","Qalqilya","Bethlehem","Jenin","Ramallah","Jericho","Rawabi","Al-Bireh","Hebron","East Jerusalem","Salfit", "Rafah","Gaza","Khan Yunis","1948 lands"];
  String? _schoolSelectedPrivacy= "";
  String? _citySelectedPrivacy= "";
  String? _uniSelectedPrivacy= "";
  String? _jobSelectedPrivacy= "";
  bool? school_privacy = false;
  bool? university_privacy = false;
  bool? job_privacy = false;
   bool? city_privacy = false;
  String? _text = "";
  @override
  void initState() {
    super.initState();
    // _createProfile();
    
  }

      Future<void> onUserSelected() async {
    

    try {
      print("step1");
      final prefs = await SharedPreferences.getInstance();

    String? image = prefs.getString('imageUrl');
    String? firstname = prefs.getString('firstname');
    String? lastname = prefs.getString('lastname');
    String? userId = prefs.getString('userId');
    print(userId);
      final client = StreamChatCore.of(context).client;
      await client.connectUser(
        User(
          id: userId!,
          extraData: { 
            'name':firstname!+" "+lastname!,
            'image': image,
          },
        ),
        client.devToken(userId).rawValue,
      );
       print("step2");
       connect = true;
        if(connect){
           print("step3");
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder:
             (context) => MainScreen()
             )
             );
        }
    
    } on Exception catch (e, st) {
      logger.e('Could not connect user', e, st);
      
    }
  }
 
  Future<void>  _createProfile() async {
    print("send request");
   final storage = new FlutterSecureStorage();
   String? token = await storage.read(key: 'token');
   
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    FileImage? file = (signUpControllerr.isProficPicPathSet.value == true
                  ? FileImage(File(signUpControllerr.profilePicPath.value)) 
                  : FileImage(File("assets/images/profilepic.png")) );
   String pathh = (signUpControllerr.isProficPicPathSet.value == true
                  ? (signUpControllerr.profilePicPath.value) 
                  : "") ;
        Map<String, int> optionsMap = {};
for (String option in options) {
  optionsMap[option] = tags.contains(option) ? 1 : 0;
}
    print(bio);
    print(school);
    print(school_privacy);
    print(university);
    print(university_privacy);
    print(city);
    print(city_privacy);
    print(pathh);
FormData? formData ;
if (pathh == ""){
  formData =
      new FormData.fromMap({
        "bio":bio,
         "city":{
          "thename":city,
          "privacy":city_privacy
        },
        "school":{
          "thename":school,
          "privacy":school_privacy
        },
         "university":{
          "thename":university,
          "privacy":university_privacy
        },
        "job":{
          "position":job,
          "privacy":job_privacy
        },
        "interests": tags,
        "optionsMap":optionsMap,
        

});
}
else{
     formData =
      new FormData.fromMap({
        "file":await MultipartFile.fromFile(pathh, filename: "dp")
        ,"bio":bio,
         "city":{
          "thename":city,
          "privacy":city_privacy
        },
        "school":{
          "thename":school,
          "privacy":school_privacy
        },
         "university":{
          "thename":university,
          "privacy":university_privacy
        },
        "job":{
          "position":job,
          "privacy":job_privacy
        },
        "interests": tags,
        "optionsMap":optionsMap,
      }
      
        );
        

}
    Response response = await dio.post('http://192.168.1.7:3002/profile',data:formData);
    print(response);
    if (response.statusCode == 201) {
        print("authenticated");
        print(response.data['success']);
        print(response.data['msg']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('create_profile', false);
        await prefs.setString('imageUrl', response.data['msg']);
        await prefs.setString('bio',bio! );
        await prefs.setString('school', school!);
        await prefs.setString('_schoolSelectedPrivacy', _schoolSelectedPrivacy!);
        await prefs.setString('university', university!);
        await prefs.setString('_uniSelectedPrivacy', _uniSelectedPrivacy!);
         await prefs.setString('job', job!);
        await prefs.setString('_jobSelectedPrivacy', _jobSelectedPrivacy!);
        await prefs.setString('city', city!);
        await prefs.setString('_citySelectedPrivacy', _citySelectedPrivacy!);
        await prefs.setStringList("tags", tags);
        onUserSelected();
        
       
    
  } else {
        print("not authenticated");
        print(response.data['success']);
        // return Fluttertoast.showToast(msg: response.data['msg'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.black);
   
   
    
  }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formkey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: [
                  SizedBox(height: 20,),
                  Center(
             child:Stack
             (
              alignment: Alignment.center,
              children: 
              [
                Obx(() => CircleAvatar(
                  backgroundImage: signUpControllerr.isProficPicPathSet.value == true
                  ? FileImage(File(signUpControllerr.profilePicPath.value)) 
                  as ImageProvider 
                  : AssetImage("assets/images/profilepic.png"),
                  radius:70,
                  backgroundColor: Colors.transparent,
                ),
                ),
                Positioned(
                  bottom: 1,
                  right:3,
                  child:InkWell(
                    child: CircleAvatar(
                    child: Icon(
                      Icons.camera_alt_sharp,
                      color: Colors.white,
                      size:20,
                      ),
                      radius: 20,
                      backgroundColor: Colors.black,
                      ),
                    onTap: (){
                      print("Camera click");
                      showModalBottomSheet(context: context, 
                      builder: (context)=>
                      bottomSheet(context)
                      );
                    },
                    ),
                  
                  ),
              
              ],
              ),
            ),
            Padding(
                  padding: const EdgeInsets.only(top:15,bottom:10,left: 40,right: 40),
                  child: TextFormField(
                   
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 3,
                    cursorHeight: 5.0,
                    decoration: InputDecoration(
    hintText: "Add bio for Your Profile",
    prefixIcon: Icon(Icons.edit),
     contentPadding: EdgeInsets.symmetric(vertical: 20.0), // Set equal padding on top and bottom
     counter: Text('${_text!.length}/100'), // character count
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
                      if (value!.length > 100) 
                      {
                        return 'Max length exceeded';
                        }
                        return null;
                        },
                    onChanged: (String? value){
                       setState(() {
                                    _text = value;
                               });
                        if(_formkey.currentState!.validate())
                            bio=value;    
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom:10,left: 40,right: 40),
                  child:Row(
                     children: [
                               Expanded(
                                flex:3,
                             child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your school"),
                              onChanged: (String? value){
                              school = value;
                            },
                              
                                ),
               
                                        ),
                               SizedBox(width: 10),
                               Expanded(
                                flex:1,
                               child: DropdownButtonFormField(

                                value: _schoolSelectedPrivacy,
                                items: _privacyList.map(
                                  (e) =>  DropdownMenuItem(child:Text(e),value: e,)
                                 
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    _schoolSelectedPrivacy= value as String;
                                    if(_schoolSelectedPrivacy=="private"){
                                          school_privacy=true;
                                    }
                                    else if(_schoolSelectedPrivacy=="public"){
                                          school_privacy=false;
                                    }
                                  });

                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.grey.shade300,
                                ),
               
                           ),
                             ],
                           ),
            ),
              Padding(
                  padding: const EdgeInsets.only(bottom:10,left: 40,right: 40),
                  child:Row(
                     children: [
                               Expanded(
                                flex:3,
                             child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your University"),
                              onChanged: (String? value){
                              university = value;
                            },
                              
                                ),
               
                                        ),
                               SizedBox(width: 10),
                               Expanded(
                                flex:1,
                               child: DropdownButtonFormField(

                                value: _uniSelectedPrivacy,
                                items: _privacyList.map(
                                  (e) =>  DropdownMenuItem(child:Text(e),value: e,)
                                 
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    _uniSelectedPrivacy= value as String;
                                    if(_uniSelectedPrivacy=="private"){
                                          university_privacy=true;
                                    }
                                    else if(_uniSelectedPrivacy=="public"){
                                          university_privacy=false;
                                    }
                                  });

                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.grey.shade500,
                                ),
               
                           ),
                             ],
                           ),
            ),
               Padding(
                  padding: const EdgeInsets.only(bottom:20,left: 40,right: 40),
                  child:Row(
                     children: [
                               Expanded(
                                flex:3,
                             child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your Job"),
                              onChanged: (String? value){
                              job = value;
                            },
                              
                                ),
               
                                        ),
                               SizedBox(width: 10),
                               Expanded(
                                flex:1,
                               child: DropdownButtonFormField(

                                value: _jobSelectedPrivacy,
                                items: _privacyList.map(
                                  (e) =>  DropdownMenuItem(child:Text(e),value: e,)
                                 
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    _jobSelectedPrivacy= value as String;
                                    if(_jobSelectedPrivacy=="private"){
                                          job_privacy=true;
                                    }
                                    else if(_jobSelectedPrivacy=="public"){
                                          job_privacy=false;
                                    }
                                  });

                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.grey.shade500,
                                ),
               
                           ),
                             ],
                           ),
            ),
             Padding(
                  padding: const EdgeInsets.only(left:0,right: 220,bottom: 10),
                  child:Text("Choose a city:",
                    style: TextStyle(fontSize:16),
                  ),
             ),
                     Padding(
                  padding: const EdgeInsets.only(bottom:20,left: 40,right: 40),
                  child:Row(
                     children: [
                     
                               Expanded(
                                flex:3,
                            child: DropdownButtonFormField(

                                value: city,
                                items: _cities.map(
                                  (e) =>  DropdownMenuItem(child:Text(e),value: e,)
                                 
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                   city = value as String;
                                  
                                  });

                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.grey.shade500,
                                ),
               
                                        ),
                               SizedBox(width: 10),
                               Expanded(
                                flex:1,
                               child: DropdownButtonFormField(

                                value: _citySelectedPrivacy,
                                items: _privacyList.map(
                                  (e) =>  DropdownMenuItem(child:Text(e),value: e,)
                                 
                                ).toList(),
                                onChanged:(value) {
                                  setState(() {
                                    _citySelectedPrivacy= value as String;
                                    if(_citySelectedPrivacy=="private"){
                                          city_privacy=true;
                                    }
                                    else if(_citySelectedPrivacy=="public"){
                                          city_privacy=false;
                                    }
                                  });

                                },
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black,
                                ),
                                dropdownColor: Colors.grey.shade500,
                                ),
               
                           ),
                             ],
                           ),
            ),
             Padding(
                  padding: const EdgeInsets.only(bottom: 10,right:28),
                  child:Text("Choose Topics That you find interesting:",
                    style: TextStyle(fontSize:16),
                  ),
             ),
            
            Padding(
               padding: const EdgeInsets.only(bottom:30,left: 30,right: 30 ),
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
                      textDirection: TextDirection.ltr,
                      
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
                        {
                          if (tags.length < 5){
                               Fluttertoast.showToast(msg: "Please choose at least 5 interests", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey.shade500, textColor: Colors.black);
                          }
                          else
                             _createProfile();
                        }
                        else
                         {
                          Fluttertoast.showToast(msg: "Bio can't exceed 100 characters", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey.shade500, textColor: Colors.black);
                         }
                          } 
                        
                     ,child: Text("SAVE"),
                    
                  ),
                ),
              
          ],
          
       
        ),
            ),
            ),
            ),
            );
  }
  
  Widget bottomSheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.2,
      margin: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 10,
      ),
      child:Column(
        children: [
          const Text(
            "Choose Profile Photo",
             style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold
              ),
              ),
              const SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                       child:InkWell(
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image,size: 25,),
                      SizedBox(
                          height:5
                          ),
                      Text(
                        "Gallery",
                        style:TextStyle(
                          fontSize: 15, 
                          fontWeight: FontWeight.bold,
                          )
                        ),
                    ],
                    ),
                    onTap: (){
                      print("Gallery");
                      takePhoto(ImageSource.gallery);
                    },
                  ),
                 
                  )
               
                  
                   
                ],
              ),
        ],
      )
    );
  }
  
  Future<void> takePhoto(ImageSource source) async {
    final pickedImage =
        await imagePicker.pickImage(source: source, imageQuality: 100);

        pickedFile = File(pickedImage!.path);
        signUpControllerr.setProfileImagePath(pickedFile!.path);
         print(pickedFile);
         Get.back();
           

  }
 
}