import 'package:flutter/material.dart';
import 'package:laqeene/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';



class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Stack(
            children: [
              // Positioned(
              //   top:0,
              //   left:0,
              //   child: Image(
              //     image: AssetImage("assets/images/welcome_dec.png"),
              //     width: 80,
              //     height: 60,
              //   ),
              //   ),
              Positioned(
                top:80,
                left:20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\t WELCOME TO OUR APP!", style: Theme.of(context).textTheme.headline3?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text("\t Grow your social network \n \tand meet new people everyday",
                    style: Theme.of(context).textTheme.headline2?.copyWith(  
                       color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        ),
                        )
                  ],)
                ),
                const Positioned(
                  left:25,
                  bottom: 25,
                  child: Image(
                  image: AssetImage("assets/images/welcome.png"),
                  width: 450,
                  height: 550,
                ),
                ),
                Positioned(
                  bottom:60,
                  right:20,
                  child:GestureDetector(
                     onTap: ()=> onDone(context),
                     child: Container(
                      height: 85,
                      width:85,
                      decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Icon(Icons.arrow_forward,color:Colors.white,size: 40.0,),
                  ),
                ),
                )
            ],
               
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.center ,
            //   children: [
               
            //     SizedBox(
            //       width: 150,
            //       height: 50,
            //       child: ElevatedButton(
            //           style: ButtonStyle(
            //               backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
            //               foregroundColor:MaterialStateProperty.all<Color>(Colors.black),
            //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //                   RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(1),
            //                       side: BorderSide(color: Colors.grey)
            //                   ),
                             
            //               ),
            //                padding: MaterialStateProperty.all((EdgeInsets.symmetric(horizontal: 15 ))),
                    
            //           ),
                    
            //           onPressed: () => onDone(context),
                 
            //         child: Text("SIGN UP"),
                    
            //       ),
            //     ),
                
            //   ],
            // ),
         
        
      ),
      
    );
  }
  void onDone(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ON_BOARDING', false);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  SignUp()));
  }
}
 
