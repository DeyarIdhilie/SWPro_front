import 'package:chips_choice_null_safety/chips_choice_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laqeene/pages/InputDeco_design.dart';
import 'package:laqeene/pages/settings.dart';

import 'package:laqeene/widget/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laqeene/controller/signup_controller.dart';
import 'dart:io';
import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';

import 'package:get/get.dart'hide Response,FormData,MultipartFile;

class profilePage extends StatefulWidget {
  
  // settingsPage({Key? key}) : super(key: key);

  @override
  // _profilePageState createState() => _profilePageState();
  State<profilePage> createState() => _profilePageState();
}



class _profilePageState extends State<profilePage> {
  _profilePageState(){
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
   String? image ;
   String? image2 ;
   String? username;
   String? firstname;
   String? lastname;
   List<String?>? preferences;
   bool flag = false;
   bool flag2 = false;
   bool flag3 = false;
   bool flag4 = false;
   bool flag5 = false;
   bool flag6 = false;
   bool flag7 = false;
   bool flag8 = false;
   bool flag9 = false;
   bool flag10 = false;
   
   
  int tag = 1;
  List<String> tags = [];
  List<String> tags2 = [];
  List<String> options = [
    'Technology','Science','Sports','Beauty','Fashion','Cultures','Music'
    ,'Kpop','Tiktok','Instagram','Photography','Languages','Religions','Reading'
    ,'Cooking','Food','Video Games','Traveling','Board Games','Movie Watching'
    ,'Painting','Politics'
  ];
  String? bio ='';
  String? school ='';
  String? university ='';
  String? city ='';
  String? job ='';
  String? bio2 ='';
  String? school2 ='';
  String? university2 ='';
  String? city2 ='';
  String? job2 ='';
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
  String? _schoolSelectedPrivacy2= "";
  String? _citySelectedPrivacy2= "";
  String? _uniSelectedPrivacy2= "";
  String? _jobSelectedPrivacy2= "";
  bool? school_privacy2 = false;
  bool? university_privacy2 = false;
  bool? job_privacy2 = false;
  bool? city_privacy2 = false;
  String? _text2 = "";
  @override
  void initState() {
    super.initState();
    load();  
  }
  Future<void>  _editProfile() async {
    // print("send request");
     if(_schoolSelectedPrivacy=="private"){ school_privacy2=true;}
     else if(_schoolSelectedPrivacy=="public"){school_privacy2=false;}
     if(_uniSelectedPrivacy=="private"){university_privacy2=true;}
     else if(_uniSelectedPrivacy=="public"){university_privacy2=false;}
     if(_jobSelectedPrivacy=="private"){job_privacy2=true;}
     else if(_jobSelectedPrivacy=="public"){job_privacy2=false;}
       if(_citySelectedPrivacy=="private"){city_privacy2=true;}
     else if(_citySelectedPrivacy=="public"){ city_privacy2=false;}

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
    // print(bio);
    // print(school);
    // print(school_privacy2);
    // print(university);
    // print(university_privacy2);
    // print(city);
    // print(city_privacy2);
    // print(pathh);
     Map<String, int> optionsMap = {};
for (String option in options) {
  optionsMap[option] = tags.contains(option) ? 1 : 0;
}
FormData? formData ;
if (pathh == ""){
  formData =
      new FormData.fromMap({
        "bio":bio,
         "city":{
          "thename":city,
          "privacy":city_privacy2
        },
        "school":{
          "thename":school,
          "privacy":school_privacy2
        },
         "university":{
          "thename":university,
          "privacy":university_privacy2
        },
        "job":{
          "position":job,
          "privacy":job_privacy2
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
          "privacy":city_privacy2
        },
        "school":{
          "thename":school,
          "privacy":school_privacy2
        },
         "university":{
          "thename":university,
          "privacy":university_privacy2
        },
        "job":{
          "position":job,
          "privacy":job_privacy2
        },
        "interests": tags,
        "optionsMap":optionsMap,
      }
      
        );
        

}
    Response response = await dio.put('http://192.168.1.7:3002/profile',data:formData);
    // print(response);
    if (response.statusCode == 201) {
        // print("authenticated");
        // print(response.data['success']);
       
        final prefs = await SharedPreferences.getInstance();
        // await prefs.setBool('create_profile', false);
        if(response.data['msg']!= null){
        //  print(response.data['msg']);
         await prefs.setString('imageUrl', response.data['msg']);
        }
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
        
        // Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(builder:
        //      (context) => MainScreen()
        //      )
        //      );
    
  } else {
        // print("not authenticated");
        // print(response.data['success']);
        
   
   
    
  }
  }
  @override
  Widget build(BuildContext context) {

  
    Size size = MediaQuery.of(context).size;
    
    return  Scaffold(
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
            "Profile\t\t\t\t\t\t\t\t",
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
      body: SingleChildScrollView(
         child: Form(
               key: _formkey,
          child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                    ),
                  FutureBuilder(
                future: _loadPreferences(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    
                    image = preferences![0];
                    
                    
                    return Center(
                     child:Stack
             (
              alignment: Alignment.center,
              children: 
              [
                Obx(() => CircleAvatar(
                          backgroundImage:
                            signUpControllerr.isProficPicPathSet.value == true
                             ? 
                            FileImage(File(signUpControllerr.profilePicPath.value)) 
                            as ImageProvider 
                             : 
                            NetworkImage(image??'https://storage.googleapis.com/laqeene-bucket/%D9%84%D8%A7%D9%82%D9%8A%D9%86%D9%8A_(9).png',
                            scale:1.0
                            ),
                             radius:70,
                             backgroundColor: Colors.transparent,
                              child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                              fit: BoxFit.cover,
                                   image: 
                                   signUpControllerr.isProficPicPathSet.value == true
                             ? 
                            FileImage(File(signUpControllerr.profilePicPath.value)) 
                            as ImageProvider 
                             : 
                            NetworkImage(image??'https://storage.googleapis.com/laqeene-bucket/%D9%84%D8%A7%D9%82%D9%8A%D9%86%D9%8A_(9).png',
                            scale:1.0
                            ),
                              ),
                              ),
                              ),
                            
                ),
               
                ),
                Positioned(
                  bottom: 1,
                  right:3,
                  child:InkWell(
                    child: CircleAvatar(
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                      size:20,
                      ),
                      radius: 20,
                      backgroundColor: Colors.black,
                      ),
                    onTap: (){
                      // print("Camera click");
                      showModalBottomSheet(context: context, 
                      builder: (context)=>
                      bottomSheet(context)
                      );
                    },
                    ),
                  
                  ),
              
              ],
              ),
            );
           } else{
            return CircularProgressIndicator();
           }
                 
           }),

             FutureBuilder(
                future: _loadPreferences(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
           return Container(
            child:Column(
              children:[
             SizedBox(height: size.height * 0.011,),
             Padding(
                  padding: const EdgeInsets.only(top:15,bottom:10,left: 40,right: 40),
                  child: TextFormField(
                    initialValue: bio,
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
                                    flag2 = true;
                               });
                        // if(_formkey.currentState!.validate())
                            bio2=value;    
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
                              initialValue: school,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your school"),
                              onChanged: (String? value){
                              school2 = value;
                              flag3= true;
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
                                    _schoolSelectedPrivacy2= value as String;
                                    flag4 = true;
                                    if(_schoolSelectedPrivacy2=="private"){
                                          school_privacy2=true;
                                    }
                                    else if(_schoolSelectedPrivacy2=="public"){
                                          school_privacy2=false;
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
                              initialValue: university,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your University"),
                              onChanged: (String? value){
                              flag5=true;
                              university2 = value;
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
                                    flag6=true;
                                    _uniSelectedPrivacy2= value as String;
                                    if(_uniSelectedPrivacy2=="private"){
                                          university_privacy2=true;
                                          print(university_privacy2);
                                    }
                                    else if(_uniSelectedPrivacy2=="public"){
                                          university_privacy2=false;
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
                              initialValue: job,
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.edit,"Add Your Job"),
                              onChanged: (String? value){
                                flag7=true;
                              job2 = value;
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
                                    flag8=true;
                                    _jobSelectedPrivacy2= value as String;
                                    if(_jobSelectedPrivacy2=="private"){
                                          job_privacy2=true;
                                    }
                                    else if(_jobSelectedPrivacy=="public"){
                                          job_privacy2=false;
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
                                    flag9=true;
                                   city2 = value as String;
                                  
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
                                    flag10=true;
                                    _citySelectedPrivacy2= value as String;
                                    if(_citySelectedPrivacy2=="private"){
                                          city_privacy2=true;
                                          print(city_privacy2);
                                    }
                                    else if(_citySelectedPrivacy2=="public"){
                                          city_privacy2=false;
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
                    onChanged: (val) => setState(() { tags2 = val; flag = true;}),
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
              )
               ],
            ),
           );
   } else{
            return CircularProgressIndicator();
           }
                 
           }),

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
                        // print(image);
                        // print(bio);
                        // print(school);
                        // print(_schoolSelectedPrivacy);
                        // print(university);
                        // print(_uniSelectedPrivacy);
                        // print(job);
                        // print(_jobSelectedPrivacy);
                        // print(city);
                        // print(_citySelectedPrivacy);
                        // for (String tag in tags) {
                        //     print(tag);
                        //  }
   
   
                        if(_formkey.currentState!.validate())
                        {
                          if (tags.length < 5){
                               Fluttertoast.showToast(msg: "Please choose at least 5 interests", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey.shade500, textColor: Colors.black);
                          }
                          else
                             _editProfile();
                        }
                        else
                         {
                          Fluttertoast.showToast(msg: "Bio can't exceed 100 characters", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.grey.shade500, textColor: Colors.black);
                         }
                          } 
                        
                     ,child: Text("Save Edits"),
                    
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
                      // print("Gallery");
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
        //  print(pickedFile);
         Get.back();
           

  }
  Future<void> load() async{

  preferences = await _loadPreferences();

}
 Future<List<String?>> _loadPreferences() async {
   final prefs = await SharedPreferences.getInstance();

   image = prefs.getString('imageUrl');
    // print(image);
     if(flag2 == false)
         bio = prefs.getString('bio');
    else if(flag2 == true)
         bio= bio2;
    // print(bio);
    if(flag3==false)
        school = prefs.getString('school');
    else if (flag3==true)
        school = school2;
    // print(school);
    if(flag4==false)
        _schoolSelectedPrivacy = prefs.getString('_schoolSelectedPrivacy');
    else if(flag4==true)
        _schoolSelectedPrivacy= _schoolSelectedPrivacy2;
    if(_schoolSelectedPrivacy == "public"){
                        _schoolSelectedPrivacy= _privacyList[0];
                        // print ("hello school");
     }else{ _schoolSelectedPrivacy= _privacyList[1]; }
     // print(_schoolSelectedPrivacy);
     if(flag5==false)
        university = prefs.getString('university');
    else if(flag5==true)
        university=university2;
    // print(university);
    if(flag6==false)
        _uniSelectedPrivacy = prefs.getString('_uniSelectedPrivacy');
     else if(flag6==true)
        _uniSelectedPrivacy=_uniSelectedPrivacy2;
    // print(_uniSelectedPrivacy);
    if(_uniSelectedPrivacy == "public"){
       _uniSelectedPrivacy= _privacyList[0];
    } else{_uniSelectedPrivacy= _privacyList[1]; }

    if(flag7==false)
     job = prefs.getString('job');
    else if (flag7==true)
     job = job2;
    // print(job);
    if(flag8==false)
      _jobSelectedPrivacy = prefs.getString('_jobSelectedPrivacy');
    else if(flag8==true)
     _jobSelectedPrivacy=_jobSelectedPrivacy2;
    // print(_jobSelectedPrivacy);
     if(_jobSelectedPrivacy == "public"){_jobSelectedPrivacy= _privacyList[0];}
      else{  _jobSelectedPrivacy= _privacyList[1]; }
    if (flag9==false)
       city = prefs.getString('city');
    else if(flag9==true)
      city=city2;
    // print(city);
    if(flag10==false)
       _citySelectedPrivacy = prefs.getString('_citySelectedPrivacy');
    else if (flag10==true)
    _citySelectedPrivacy= _citySelectedPrivacy2;
    // print(_citySelectedPrivacy);
     if(_citySelectedPrivacy == "public"){
       _citySelectedPrivacy= _privacyList[0];
                     
     }else{ _citySelectedPrivacy= _privacyList[1]; }
     if(flag == false)
         tags = prefs.getStringList("tags") ?? [];
    else if(flag == true)
         tags= tags2;
    // for (String tag in tags) {
    // print(tag);
    // }
       
    return [image,bio,school,_schoolSelectedPrivacy,university,_uniSelectedPrivacy,job,_jobSelectedPrivacy,city,_citySelectedPrivacy];
}
 
}

