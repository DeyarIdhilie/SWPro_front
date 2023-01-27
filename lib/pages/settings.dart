import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laqeene/pages/login.dart';
import 'package:laqeene/pages/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laqeene/controller/signup_controller.dart';
import 'dart:io';

import 'package:get/get.dart'hide Response,FormData,MultipartFile;
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../app.dart';
class settingsPage extends StatefulWidget {
  
  const settingsPage({Key? key}) : super(key: key);

  @override
  _settingsPageState createState() => _settingsPageState();
}

class _settingsPageState extends State<settingsPage> {
  _settingsPageState(){
        _loadPreferences().then((preferences) {
  image = preferences[0];
  print("@");
  print(image);
  username = preferences[1];
  firstname = preferences[2];
  lastname = preferences[3];
});
  }
  File? pickedFile;
   SignUpController signUpController = Get.put(SignUpController());
   SignUpController signUpControllerr = Get.find();
   ImagePicker imagePicker = ImagePicker();
   String? image ;
   String? username;
   String? firstname;
   String? lastname;

  @override
  void initState() {
    super.initState();
    
    
  }
  
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
   
    return  Scaffold(
      body: SingleChildScrollView(
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
                    List<String?>? preferences = snapshot.data;
                    image = preferences![0];
                    
                    return Center(
                     child:Stack
             (
              alignment: Alignment.center,
              children: 
              [
                Obx(() => CircleAvatar(
                          backgroundImage:
                            
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
                              
              ],
              ),
            );
           } else{
            return CircularProgressIndicator();
           }
                 
           }),
             SizedBox(height: size.height * 0.011,),
             FutureBuilder(
                future: _loadPreferences(),
                builder: (context, snapshot) 
                {
                  if (snapshot.hasData) {
                    List<String?>? preferences = snapshot.data;
                     firstname = preferences![2];
                    lastname = preferences![3];
                    username = preferences![1];
                    return Container( 
                      child:Column(
                      children:[
                        Text(firstname! + " " + lastname!,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),

                        ),
                        SizedBox(height: size.height * 0.0051,),
                        Text("@" + username!,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                    ),
                        ),
                        ],
                      ),
                    );
                  } 
                  else {
      return CircularProgressIndicator();
    }
                 }
                 ),
                  SizedBox(height: size.height * 0.021,),
                  SizedBox(
                    width:200,
                    child: ElevatedButton(
                      onPressed: () {
                         Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => profilePage()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        side: BorderSide.none,
                        shape: const StadiumBorder(),
                      ),
                      child: const Text("Edit Profile",
                      style: TextStyle(
                        color:Colors.white,
                      ),),
                    ),
                  ),
                  SizedBox(height: size.height * 0.021,),
                  Divider(),
                  SizedBox(height: size.height * 0.011,),
                  ListTile(
                    leading: Container(
                      width: size.width * 0.125,
                      height: size.width * 0.125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(350),
                        color: Colors.grey.withOpacity(0.2)
                      ),
                      child: const Icon(Icons.article, color: Colors.black, size: 35),
                    ),
                    title: Text("Give Feedback",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                    )
                    ),
                    
                    trailing: Container(
                      width: size.width * 0.075,
                      height: size.width * 0.075,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(200),
                        color: Colors.grey.withOpacity(0.1)
                      ),
                      child: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black, size: 20,),
                    
                    ),
                    

                  ),
                  SizedBox(height: size.height * 0.011,),
                  ListTile(
                    leading: Container(
                      width: size.width * 0.125,
                      height: size.width * 0.125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(350),
                        color: Colors.grey.withOpacity(0.2)
                      ),
                      child: const Icon(Icons.logout_outlined, color: Colors.black,size: 35,),
                    ),
                    title: Text("Logout",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Color.fromARGB(255, 148, 3, 3),
                        // fontWeight: FontWeight.bold,
                        fontSize: 16,
                    )
                    ),
                    onTap: ()=> logOut(context),
                    // trailing: Container(
                    //   width: size.width * 0.075,
                    //   height: size.width * 0.075,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(200),
                    //     color: Colors.grey.withOpacity(0.1)
                    //   ),
                    //   child: const Icon(Icons.arrow_forward_ios_outlined, color: Colors.black,size: 20,),
                    
                    // ),
                    

                  ),
                  ],
                  ),
        ),
      ),
    );
  }
     

  Future<List<String?>> _loadPreferences() async {
   final prefs = await SharedPreferences.getInstance();

    String? image = prefs.getString('imageUrl');
    print(image);
    String? username = prefs.getString('username');
    print(username);
    String? firstname = prefs.getString('firstname');
    print(firstname);
    String? lastname = prefs.getString('lastname');
    print(lastname);
    return [image, username, firstname, lastname];
}
void logOut(context) async {
  try {
      

    final storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedout', true);
    await StreamChatCore.of(context).client.disconnectUser();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  loginPage()));
     }
     on Exception catch (e, st) {
      logger.e('Could not sign out', e, st);
      
  }
  
}
}
