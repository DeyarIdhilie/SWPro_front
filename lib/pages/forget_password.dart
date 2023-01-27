import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:laqeene/pages/InputDeco_design.dart';
import 'package:laqeene/pages/changePassword.dart';
import 'package:laqeene/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  //  ForgotPasswordPage({Key? key}) : super(key: key);
   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
   String? email = "";
   bool _isButtonVisible = true;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
           Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => loginPage()));
        }
        ,icon: const Icon(Icons.arrow_back_ios, color:Colors.black,size: 20, ),
        ),
        
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.white,
        elevation: 0.0,

        ),
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
                 
                  Text("Forget Password", 
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      )),

                  Padding(
                    padding: const EdgeInsets.only(left:40, right:40, top:5, bottom:10),
                    child: Text("Please add the email you used while registering\n so a verification link will be sent to you\n in order to make sure the email is yours", 
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                          color: Colors.black,
                                          
                                        ),
                                        textAlign: TextAlign.center),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(bottom:10,left: 30,right: 30),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      cursorHeight: 5.0,
                      decoration: buildInputDecoration(Icons.email_rounded,"Enter your email"),
                      validator: (String? value){
                        if(value == null) {
                             return 'Please enter a value';
                        }
                        if(value.isEmpty)
                        {
                          return 'Please Enter a password';
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
                  Visibility(
                    visible: _isButtonVisible,
                    child: SizedBox(
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
                            
                              sendEmail(email).then((value) async { 
                              if (value.data['error']!= null) {
                                return Fluttertoast.showToast(msg: value.data['error'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                              
                              }
                              else if(value.data['message']!=null) {
                                
                                  setState(() {
                                 _isButtonVisible = false;
                             });
                              return Fluttertoast.showToast(msg: "Check Your Inbox", toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                          }
                          });
                           return;
                          }else {
                            print("UnSuccessfull");
                          }
                        },
                        child: Text("Verify your email"),
                        
                      ),
                    ),
                  ),
                   Visibility(
                     visible: !_isButtonVisible,
                     child: SizedBox(
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
                            
                              checkStatus(email).then((value) async { 
                              if (value.data['error']!= null) {
                                return Fluttertoast.showToast(msg: value.data['error'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                              
                              }
                              else if(value.data['message']!=null) {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('verified-email',email! );
                                 Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(builder: (context) => changePasswordPage()));
                                // return Fluttertoast.showToast(msg: value.data['message'], toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Color.fromARGB(255, 102, 154, 196), textColor: Colors.black);
                            
                          }
                          });
                           return;
                          }else {
                            print("UnSuccessfull");
                          }
                        },
                        child: Text("Next"),
                        
                      ),
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
  sendEmail(email)
  async {
    
  try {
    
      print(email);
      return await dio.post(
        ('http://192.168.1.7:3002/send-verification-email'),data: {"email": email, }, );
        } on DioError catch (e) {
              print(e);
  
  }

  }
  checkStatus(email)
  async {
    
  try {
    
      print(email);
      return await dio.post(
        ('http://192.168.1.7:3002/is_verified'),data: {"email": email, }, );
        } on DioError catch (e) {
              print(e);
  
  }

  }