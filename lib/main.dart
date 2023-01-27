import 'package:get/get.dart';
import 'package:laqeene/app.dart';
import 'package:laqeene/pages/create_profiel.dart';
import 'package:laqeene/pages/location_page.dart';
import 'package:laqeene/widget/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:laqeene/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laqeene/pages/signup.dart';
import 'package:laqeene/pages/login.dart';
import 'package:laqeene/pages/on_boarding.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:laqeene/theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

bool show = true;
bool profile = true;
//when u register successfully the app will save a token if so authenticated will be true
bool authenticated= false;
bool loggedout = false;
void main() async{
  final client = StreamChatClient(streamKey);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  //IF U visited the app before and land on onboarding screen and skip it show will be false otherwise it's true
  

  show = prefs.getBool('ON_BOARDING') ?? true;
  //IF U visited the app and visit create profile screen and skip it profile will be false otherwise it's true
  //if null(not found)set as true
  profile = prefs.getBool('create_profile') ?? true;
  loggedout = prefs.getBool('loggedout') ?? false;
  print("show =");
  print(show);
  print("profile = ");
  print(profile);
  print("loggedout=");
  print(loggedout);
  // Create a storage object
  final storage = new FlutterSecureStorage();
    
// Read the token
   String? token = await storage.read(key: "token");

// Check if the token is null or not
if (token == null) {
  print("No token saved");
} else {
  print("Token saved: $token");
  authenticated = true;
}
print("authenticated = ");
print(authenticated);

  runApp( MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
    }) : super(key: key);

  // This widget is the root of your application.
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
       builder: (context, child) {
        return StreamChatCore(
          client: client,
          child: ChannelsBloc(
            child: UsersBloc(
              child: child!,
            ),
          ),
        );
      },
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,

      
      home:  show ? OnboardingScreen() :  (authenticated? ( profile? CreateProfilePage() : MainScreen()) : (loggedout? loginPage(): SignUp())),
      
      routes: {
        '/home':(context) =>  HomePage(),
        '/login':(context) =>  loginPage(),
        '/register':(context) =>  SignUp()
      },
    );
  }
  
}




