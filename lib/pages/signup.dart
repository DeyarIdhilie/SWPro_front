import 'package:flutter/material.dart';
import 'package:laqeene/pages/create_profiel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'InputDeco_design.dart';
import 'gender_selection.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:laqeene/pages/location_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laqeene/controller/gender_selection_controller.dart';
import 'package:get/get.dart';
class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _obscuretext = true;
  String? name="";String? email="";String? phone="" ;String? userPassword="" ;String? FirstName="" ;String? LastName="" ; 
  DateTime? _selectedDate;
  String? birthday;

  //TextController to read text entered in text field
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController _date = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                  padding: const EdgeInsets.only(bottom:5,left: 30,right: 30),
                  child:Row(
                     children: [
                               Expanded(
                             child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.person,"First name"),
                              validator: (String? value){
                              if(value == null) {
                                      return 'Please enter a value';
                              }
                             if(value.isEmpty)
                              {
                                   return 'Please Enter Your First Name';
                               }
                              return null;
                             },
                            onChanged: (String? value){
                             FirstName = value;
                            },
                                ),
               
                                        ),
                               SizedBox(width: 10),
                               Expanded(
                               child: TextFormField(
                              keyboardType: TextInputType.text,
                              decoration: buildInputDecoration(Icons.person,"Last name "),
                              validator: (String? value){
                              if(value == null) {
                                      return 'Please enter a value';
                              }
                             if(value.isEmpty)
                              {
                                   return 'Please Enter Your Last Name';
                               }
                              return null;
                             },
                            onChanged: (String? value){
                             LastName = value;
                            },
                                ),
               
                           ),
                             ],
                           ),
            ),
                Padding(
                  padding: const EdgeInsets.only(bottom:5,left: 30,right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    cursorHeight: 5.0,
                    decoration: buildInputDecoration(Icons.person,"Username"),
                    validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please Enter an UserName';
                      }
                      return null;
                    },
                    onChanged: (String? value){
                      name = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 30,right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    decoration:buildInputDecoration(Icons.email,"Email"),
                    validator: (String? value){
                      if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please Enter Your Email';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please a valid Email';
                      }
                      return null;
                    },
                    onChanged: (String? value){
                      email = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 30,right: 30),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration:buildInputDecoration(Icons.phone,"Phone Number"),
                    validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please Enter Your Phone Number ';
                      }
                      else {
                         final phoneNumberPattern = r'^\d{10}$';
                         final phoneNumberRegex = RegExp(phoneNumberPattern);
                         if (!phoneNumberRegex.hasMatch(value)) {
                          return ('phone number should be 10 digits');
                        } 
                         }
                         return null;
                      },
                    onChanged: (String? value){
                      
                         phone = value;
                         
                       },
                   
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 30,right: 30),
                  child: TextFormField(
                    controller: password,
                    obscureText: _obscuretext,
                    keyboardType: TextInputType.text,
                    // decoration:buildPasswordFieldDecoration(Icons.lock,"Password"),
                    decoration: InputDecoration(
                     hintText: "Password",
                   prefixIcon: Icon(Icons.lock),
                   suffixIcon: GestureDetector(
      onTap: () {
      setState(() {
      _obscuretext=!_obscuretext;
      });
    },
    child: Icon(_obscuretext
           ?Icons.visibility 
           :Icons.visibility_off),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 5,left: 30,right: 30),
                  child: TextFormField(
                    controller: confirmpassword,
                    obscureText: _obscuretext,
                    keyboardType: TextInputType.text,
                     decoration: InputDecoration(
                     hintText: "Password",
                   prefixIcon: Icon(Icons.lock),
                   suffixIcon: GestureDetector(
      onTap: () {
      setState(() {
      _obscuretext=!_obscuretext;
      });
    },
    child: Icon(_obscuretext
           ?Icons.visibility 
           :Icons.visibility_off),
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
                        return 'Please re-enter password';
                      }
                      print(password.text);

                      print(confirmpassword.text);

                      if(password.text!=confirmpassword.text){
                        return "Password does not match";
                      }

                      return null;
                    },

                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 30,right: 30),
                  child: TextFormField(
                    controller: _date,
                 
                    decoration:buildInputDecoration(Icons.calendar_today_rounded,"add your birthday"),
                    onTap:() async {              
               final date = await showDatePicker(
                context: context,
                initialDate: _selectedDate ?? DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );

             
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                  _date.text= DateFormat("yyyy-MM-dd").format(date);
                   birthday= DateFormat("yyyy-MM-dd").format(date);
                });
              }
              

            },
            validator: (String? value){
                       if(value == null) {
                           return 'Please enter a value';
                      }
                      if(value.isEmpty)
                      {
                        return 'Please add your birthday';
                      }        
                    
                      return null;
                    },
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15,left: 50,right: 40),
                  child:GenderSelection(),
                  

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
                    
                      onPressed: (){

                      if(_formkey.currentState!.validate())
                      {
                        print("successful");
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
                       savereg(name, email, phone, userPassword,birthday,FirstName,LastName).then((value) async {
                        print(value);
                        print(value.data['success']);
                        if (value.data['success'] == false) {
                          print(value);
                          // print("user registered");
                          return Fluttertoast.showToast(msg: value.data['msg'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.black);
                        }
                        else {
                          // print(value.data['token']);
                          final prefs = await SharedPreferences.getInstance();
                          
                          await prefs.setString('username',name! );
                          await prefs.setString('firstname', FirstName!);
                          await prefs.setString('lastname', LastName!);
                          GenderSelectionController genderSelectionController = Get.find();
                          await prefs.setString('gender', genderSelectionController.selectedGender.value!);
                          await prefs.setString('birthday', birthday!);
                          await prefs.setBool('create_profile', true);
                          await prefs.setBool('loggedout', false);
                          print(value.data['userId']);
                          await prefs.setString('userId',value.data['userId'] );
                          print("let's save the token");
                          saveToken(value.data['token']);
                          
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                
                                   CreateProfilePage (),                                 
                                  //  LocationPage(),
                              )
                          );
                          
                        }

                        //   Navigator.push(
                        //       context,
                        //       new MaterialPageRoute(
                        //         builder: (context) =>
                        //            LocationPage(),
                        //       )
                        //   );
                        // }
                        // else{
                        //   print("no register");
                        // }
                      });

                        return;
                      }else{
                        print("UnSuccessfull");
                      }
                    },
                    child: Text("SIGN UP"),
                    
                  ),
                ),
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
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                          text:'Login' ,
                          style: const TextStyle(
                            color:  Color.fromARGB(231, 0, 0, 0), 
                          ),
                          recognizer:  TapGestureRecognizer()..onTap = (){
                            Navigator.pushNamed(context, "/login");
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
savereg(name, email,phone,userPassword,birthday,FirstName,LastName)
async {
  try {
    GenderSelectionController genderSelectionController = Get.find();
    
    print(name);
    print(email);
    print(phone);
    print(userPassword);
    print(birthday);
    print(FirstName);
    print(LastName);
    print(genderSelectionController.selectedGender.value);

    // return await dio.post(
    //     ('http://localhost:3002/user'), data: {"name": logname,"email": logEmail,"phone": logphone, "password": logpassword}, );
      return await dio.post(
        ('http://192.168.1.7:3002/user'),data: {"username": name,"email": email,"phone": phone, "password": userPassword,"birthday":birthday, "Gender":genderSelectionController.selectedGender.value,"name":{"Firstname":FirstName,"lastName":LastName}}, );
        } on DioError catch (e) {
              print(e);
  //       return Fluttertoast.showToast(msg: e.response!.data['msg'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red, textColor: Colors.black);
  }

  }