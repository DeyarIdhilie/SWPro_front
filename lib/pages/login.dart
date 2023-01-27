import 'package:flutter/material.dart';
import 'package:laqeene/pages/create_profiel.dart';
import 'package:laqeene/pages/forget_password.dart';
import 'package:laqeene/pages/location_page.dart';
import 'package:laqeene/widget/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import '../app.dart';
import 'InputDeco_design.dart';

import 'package:flutter/gestures.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class loginPage extends StatefulWidget {
  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool _obscuretext = true;
  String? name="";String? phone="" ;String? userPassword="" ;
  String? input = "";
  bool connect = false;
  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center ,
              children: [
                SizedBox(
                 
                  height: 5,
                ),
                
                Container(
                  child: Image.asset("assets/images/signup.png",width: 300,height:180),
                ),
                SizedBox(
                 
                  height: 5,
                ),
                 
                Padding(
                  padding: const EdgeInsets.only(bottom:10,left: 30,right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorHeight: 5.0,
                    decoration: buildInputDecoration(Icons.edit,"Username Or Phonenumber"),
                    validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please Enter either your userName or phonenumber';
                      }
                      return null;
                    },
                    onChanged: (String? value){
                      input = value;
                    },
                  ),
                ),
                
               
                Padding(
                  padding: const EdgeInsets.only(bottom: 10,left: 30,right: 30),
                  child: TextFormField(
                    controller: password,
                    obscureText: _obscuretext,
                    keyboardType: TextInputType.text,
                   
                    decoration: InputDecoration(
                     hintText: "Password",
                   prefixIcon: Icon(Icons.lock),
                   suffixIcon: GestureDetector(
                    onTap: () {setState(() {_obscuretext=!_obscuretext;});},
                    child: Icon(_obscuretext?Icons.visibility:Icons.visibility_off), 
                    ),
    contentPadding: EdgeInsets.symmetric(vertical: 3.0), // Set the 
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
                    validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please a Enter Password';
                      }
                      return null;
                    },
                     onChanged: (String? value){
                      userPassword = value;
                    },
                  ),
                  
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25, top: 10),
                    child: RichText(
                      text:  TextSpan(
                      style:
                        const TextStyle(
                        color: Color.fromARGB(231, 0, 0, 0),
                      fontSize: 14.0,),
                      children: <TextSpan>[
                        TextSpan(
                          text:'Forget Password?',
                          style: const TextStyle(
                            color:  Color.fromARGB(231, 0, 0, 0),
                          ),
                          recognizer:  TapGestureRecognizer()..onTap = (){
                           
                            showModalBottomSheet(
                              context: context,
                               builder: (context) => Container(
                                height: 350.0,
                                padding: EdgeInsets.all(30.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Make Selection!",
                                    style:Theme.of(context).textTheme.headline5?.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    )
                                    ),
                                    SizedBox(height: 10,),
                                    Text("Select the option given below to reset your password.",
                                     style:Theme.of(context).textTheme.bodyText1?.copyWith(
                                      color: Colors.black87,
                                      fontSize: 17,
                                    )
                                     ),
                                    const SizedBox(height: 35.0),
                                    GestureDetector(
                                      onTap: (){
                                         Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                          builder: (context) =>
                                           ForgotPasswordPage(),
                                          )
                                        );
                                       
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(15.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.grey.shade200
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.mail_outline_rounded, size: 60.0),
                                            const SizedBox(width: 10.0,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("E-Mail",
                                                style: Theme.of(context).textTheme.headline6?.copyWith(
                                                   color: Colors.black87,
                                                   fontSize: 15,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                                 ),
                                                 SizedBox(height: 3,),
                                                Text("Reset via E-mail Verification.",
                                                style: Theme.of(context).textTheme.bodyLarge,)
                                              ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                               ),
                               );
                            
                          },
                        )
                      ]
                    ),
                    ),
                  ),
                  ),
                  const SizedBox(
                    height: 20,),
                 
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
                    
                      onPressed: (){
                       print(_formkey.currentState!.validate());
                      if(_formkey.currentState!.validate())
                      {
                        Future<void> saveToken(String token) async {
                        final storage = new FlutterSecureStorage();
                           try {
                               await storage.write(key: 'token', value: token);
                                 String? tokenn = await storage.read(key: 'token');
                                 print(tokenn);
                           } catch (e) {
                               print(e);
                           }
                        }//saveToken
                        print("successful");
                        final phoneNumberPattern = r'^\d{10}$';
                        final phoneNumberRegex = RegExp(phoneNumberPattern);

                        if (phoneNumberRegex.hasMatch(input!)) 
                        {

                          //  print('Input is a phone number');
                           phone= input;
                          //  print(phone);
                           loginByPhone(phone, userPassword).then((value) async { 
                            print(value);
                            print(value.data);
                            if (value.data['success'] == false) {
                              return Fluttertoast.showToast(msg: value.data['msg'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                            
                            }
                            else{
                             final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('loggedout', false);
                               await prefs.setString('userId',value.data['userId'] );
                              await prefs.setString('username',value.data['username']);
                              await prefs.setString('firstname', value.data['firstName']);
                              await prefs.setString('lastname',value.data['lastName']);
                              await prefs.setString('gender',value.data['gender'] );
                              await prefs.setString('birthday', value.data['birthday'] );
                              await prefs.setString('bio',value.data['bio'] );
                              await prefs.setString('school',value.data['school']);
                              String school_privacy = "public";
                              if(value.data['school_privacy']== true) school_privacy ='private';
                              await prefs.setString('_schoolSelectedPrivacy', school_privacy);
                              await prefs.setString('university', value.data['uni']);
                              String uni_privacy = "public";
                              if(value.data['uni_privacy']== true) uni_privacy ='private';
                              await prefs.setString('_uniSelectedPrivacy', uni_privacy);
                              await prefs.setString('job', value.data['job']);
                              String job_privacy = "public";
                              if(value.data['job_privacy']== true) job_privacy ='private';
                              await prefs.setString('_jobSelectedPrivacy', job_privacy);
                              await prefs.setString('city', value.data['city']);
                               String city_privacy = "public";
                              if(value.data['city_privacy']== true) city_privacy ='private';
                              await prefs.setString('_citySelectedPrivacy', city_privacy);
                              await prefs.setStringList("tags", value.data['tags'].cast<String>());
                          
                              print("let's save the token");
                              saveToken(value.data['token']);
                               onUserSelected();
                           
                          
                        }
                        });} 
                        else {
                           print('Input is not a phone number');
                           name=input;
                           print(name);
                           loginByName(name, userPassword).then((value) async {
                            if (value.data['success'] == false) {
                              return Fluttertoast.showToast(msg: value.data['msg'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor:  Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                            }
                            else
                            {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('loggedout', false);
                               await prefs.setString('userId',value.data['userId'] );
                              await prefs.setString('username',value.data['username']);
                              await prefs.setString('firstname', value.data['firstName']);
                              await prefs.setString('lastname',value.data['lastName']);
                              await prefs.setString('gender',value.data['gender'] );
                              await prefs.setString('birthday', value.data['birthday'] );
                              await prefs.setString('bio',value.data['bio'] );
                              await prefs.setString('school',value.data['school']);
                              String school_privacy = "public";
                              if(value.data['school_privacy']== true) school_privacy ='private';
                              await prefs.setString('_schoolSelectedPrivacy', school_privacy);
                              await prefs.setString('university', value.data['uni']);
                              String uni_privacy = "public";
                              if(value.data['uni_privacy']== true) uni_privacy ='private';
                              await prefs.setString('_uniSelectedPrivacy', uni_privacy);
                              await prefs.setString('job', value.data['job']);
                              String job_privacy = "public";
                              if(value.data['job_privacy']== true) job_privacy ='private';
                              await prefs.setString('_jobSelectedPrivacy', job_privacy);
                              await prefs.setString('city', value.data['city']);
                               String city_privacy = "public";
                              if(value.data['city_privacy']== true) city_privacy ='private';
                              await prefs.setString('_citySelectedPrivacy', city_privacy);
                              await prefs.setStringList("tags", value.data['tags'].cast<String>());
                          
                              print("let's save the token");
                              saveToken(value.data['token']);
                               onUserSelected();

                            }
                            }
                            );
                        }
                        
                        
                     
                        // else {
                        //   // print(value.data['token']);
                        //   final prefs = await SharedPreferences.getInstance();
                        //   await prefs.setBool('loggedout', false);
                        //   print("let's save the token");
                        //   saveToken(value.data['token']);
                        //     Navigator.push(
                        //       context,
                        //       new MaterialPageRoute(
                        //         builder: (context) =>
                                
                        //            LocationPage (),                                 
                        //           //  LocationPage(),
                        //       )
                        //   );
                          
                        // }

                        
                      // });

                        return;
                      }else{
                        print("UnSuccessfull");
                      }
                    },
                    child: Text("LOGIN"),
                    
                  ),
                ),
                SizedBox(height: 5,),
                   Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 25, top: 5),
                    child: RichText(
                      text:  TextSpan(
                      style:
                        const TextStyle(
                         color: Color.fromARGB(231, 0, 0, 0), 
                      fontSize: 14.0,),
                      children: <TextSpan>[
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text:'Register' ,
                          style: const TextStyle(
                            color:  Color.fromARGB(231, 0, 0, 0), 
                          ),
                          recognizer:  TapGestureRecognizer()..onTap = (){
                            Navigator.pushNamed(context, "/register");
                          },
                        )
                      ]
                    ),
                    ),
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

var dio = Dio();
// var name, email,phone,Userpassword;

  loginByPhone(phone, userPassword,)
  async {
  try {
    
      print(phone);
      return await dio.post(
        ('http://192.168.1.7:3002/user/login'),data: {"phone": phone, "password": userPassword, }, );
        } on DioError catch (e) {
              print(e);
  
  }

  }
  loginByName(name, userPassword,)
  async {
  try {
    
      print(name);
      return await dio.post(
        ('http://192.168.1.7:3002/user/login'),data: {"username": name, "password": userPassword, }, );
        } on DioError catch (e) {
              print(e);
  
  }

  }