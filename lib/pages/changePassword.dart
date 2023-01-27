import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laqeene/pages/InputDeco_design.dart';
import 'package:laqeene/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class changePasswordPage extends StatefulWidget {
  @override
  _changePasswordPageState createState() => _changePasswordPageState();
}

class _changePasswordPageState extends State<changePasswordPage> {

  //  ForgotPasswordPage({Key? key}) : super(key: key);
   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
   String? password = "";
   
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(30.0),
        child:Container(
        child: Column(
        children: 
                 [
                   SizedBox(
                 
                  height: 30,
                ),
                
                Container(
                  child: Image.asset("assets/images/forgetpass.png",width: 350,height:210),
                ),
              
                  Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center ,
              children: [
                 
                  Text("Change Password", 
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),

                   SizedBox(height: 20,),
                   Padding(
                    padding: const EdgeInsets.only(bottom:10,left: 30,right: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      cursorHeight: 5.0,
                      decoration: buildInputDecoration(Icons.edit,"Enter new password"),
                      validator: (String? value){
                        if(value == null) {
                             return 'Please enter a value';
                        }
                        if(value.isEmpty)
                        {
                          return 'Please Enter Your Email';
                        }
                       
                        return null;
                      },
                      onChanged: (String? value){
                        password = value;
                      },
                    ),
                  ),
               
                   SizedBox(
                      width: 250,
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
                            
                              saveNewPassword(password).then((value) async { 
                              if (value.data['error']!= null) {
                                return Fluttertoast.showToast(msg: value.data['error'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                              
                              }
                              else if(value.data['message']!=null) {
                                Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(builder: (context) => loginPage()));
                                 
                             
                          }
                          });
                           return;
                          }else {
                            print("UnSuccessfull");
                          }
                        },
                        child: Text("Save New Password"),
                        
                      ),
                    ),
                  
                  
              ],
                 ),
                 ),
               ],
      ),
        ),
      ),
    );
  }
}
 var dio = Dio();
  saveNewPassword(password)
  async {
    
  try {
      final prefs = await SharedPreferences.getInstance();

      String? email = prefs.getString('verified-email');
      print(email);
      print(password);
      return await dio.patch(
        ('http://192.168.1.7:3002/user'),data: {"email": email,"password": password, }, );
        } on DioError catch (e) {
              print(e);
  
  }

  }
