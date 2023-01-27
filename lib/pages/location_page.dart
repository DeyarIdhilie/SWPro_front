import 'dart:async';
import 'dart:convert';
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
import 'package:laqeene/pages/create_date.dart';
import 'package:laqeene/pages/map.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class LocationPage extends StatefulWidget {
const LocationPage({Key? key}) : super(key: key);
@override
  State<LocationPage> createState() => _LocationPageState();
}
class _LocationPageState extends State<LocationPage> {
  Position? _currentPosition;
  late LatLng newCenter;
  String? tag;
  bool isAlertSet = false;
  bool serviceEnabled = false;
  bool? g;
  double radius = 6640.251439174424;
  late List<Event> events;
  List<LatLng> coordinates = [];
  late Event _selectedEvent ;
  bool _showEventCard = false;
  bool _showprofile = false;
  late Map<String, dynamic> profile;
  late GoogleMapController googleMapController;
  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
    _liveLocation();
  }
Future<bool> _handleLocationPermission() async {
    print("checkforpermisiions");
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
         showDialog(
         context: context,
         builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Location Permission denied'),
          content: const Text('Please allow location tracking to continue'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                _getCurrentPosition();
              },
              child: const Text('OK'),
            ),
          ],
        )
         );
         return false;
  }
      }
       print("u have the permissions");
    
    return true;
  }
Future<void> _getCurrentPosition() async {
   print("getcurrentloactionisaclled");

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled && isAlertSet == false) {
       showDialogBox();
       setState(() => isAlertSet = true);
       return;
     }
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _saveLocation();
      if(googleMapController != null){
      print("location saved lets show marker");
       googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 12)));
       markers.clear();
  markers.add(Marker(markerId: const MarkerId('currentLocation'),
                     position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  events.map((event) => markers.add(
                 Marker(
                         markerId: MarkerId(event.id.toString()),
                         position: LatLng(event.location!.coordinates![1]?? 0.0, event.location!.coordinates![0]?? 0.0),
                         onTap: () {
                          _selectedEvent = event;
                          _showEventCard = true;
                          setState((){});
                         
                         },
                       ))).toSet();
  setState(() {});
      }
    }
    );
 
  }
  Future<void> _saveLocation() async {
    print("get location");
   final prefs = await SharedPreferences.getInstance();
   final storage = new FlutterSecureStorage();
   String? token = await storage.read(key: 'token');
   double? latitude = _currentPosition?.latitude;
   prefs.setDouble("latitude",latitude!);
   double? longitude = _currentPosition?.longitude;
    prefs.setDouble("longitude",longitude!);
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response = await dio.patch('http://192.168.1.7:3002/user/location',data: {"location":{"type":"point","coordinates":[longitude,latitude]}},);
    print(response);
    if (response.statusCode == 200) {
      _getDates();
    print("authenticated");
  } else {
     print("not authenticated");
  }

  }
  Widget showEventCard(Event event) {
   return _showEventCard ?  Stack(
      children: [
    // Your existing widgets here
      Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Card(
       child: Column(
        children: <Widget>[
            Text(event.id.toString()),
            Text(event.description.toString()),
        ],
    ),
) ,
    ),
  ],
): Container();

  }
  
    Future<void> _getProfile(String? creator) async {
    print("show profile");
    
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

  var queryParams = {
  'id': creator,
  
};

Response response = await dio.get('http://192.168.1.7:3002/profile', queryParameters: queryParams);
  // List data = response.data;
  print(response);
  profile = response.data;
  _showprofile = true;
  _showEventCard = false;
  setState(() {
    
  });
  print(profile);
  print(profile["_id"]); // access _id property
  print(profile["firstname"]); // access firstname property
  }
    Future<void> _sendRequest()async {
      final prefs = await SharedPreferences.getInstance();
      final storage = new FlutterSecureStorage();
      String? token = await storage.read(key: 'token');
      String? firstname = prefs.getString('firstname');
      String? lastname = prefs.getString('lastname');
      String? image = prefs.getString('imageUrl');
      Dio dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      
      Response response = await dio.post(
        ('http://192.168.1.7:3002/request'),data: {"theDate": _selectedEvent.id,"name":{"firstName":firstname,"lastName":lastname},"image":image, "Date_creator":_selectedEvent.creator, "Date_creator_username":_selectedEvent.creator_username}, );
        if(response.data["success"]==true){
             showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                              title: const Text('Request is sent successfuly'),
                              content: Row(
                                      children: <Widget>[
                                      Icon(Icons.add_task_rounded, size: 40,color: Colors.lightGreen,),
                                      SizedBox(width: 10),
                                      Text('A request to join is sent \nto the creator,\n wait for the appproval'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    
                },
                child: const Text('OK'),
              ),
            ],
          )
           );
        }
        else{
               showDialog(
                              context: context,
                              builder: (BuildContext context) => CupertinoAlertDialog(
                              title: const Text('Error Message'),
                              content: Row(
                                      children: <Widget>[
                                      Icon(Icons.error, size: 40,color: Colors.red,),
                                      SizedBox(width: 10),
                                      Text("The request can't be sent\nTry later"),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    
                },
                child: const Text('OK'),
              ),
            ],
          )
           );
        }
    }
    Future<void> _getDates() async {
    print("show Dates");
    final prefs = await SharedPreferences.getInstance();
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    double? latitude = _currentPosition?.latitude;
   
    double? longitude = _currentPosition?.longitude;
    String? gender = prefs.getString('gender');
    String? birthday = prefs.getString('birthday');
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
     var queryParams;
  if(tag!=null){
   queryParams = {
  'lat': newCenter.latitude,
  'lng': newCenter.longitude,
  'userlat':latitude,
  'userlng':longitude,
  'raduis': radius,
  'gender': gender,
  'birthday': birthday,
  'tag':tag,
};}else{
  queryParams = {
  'lat': newCenter.latitude,
  'lng': newCenter.longitude,
  'userlat':latitude,
  'userlng':longitude,
  'raduis': radius,
  'gender': gender,
  'birthday': birthday,
  
};
}

Response response = await dio.get('http://192.168.1.7:3002/date', queryParameters: queryParams);
  List data = response.data;
  events = (response.data as List).map((i) => Event.fromJson(i)).toList();
  markers.clear();
  markers.add(Marker(markerId: const MarkerId('currentLocation'),
                     position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                      onTap: () {
                          print("my location");
                         
                         },
                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  events.map((event) => markers.add(
                 Marker(
                         markerId: MarkerId(event.id.toString()),
                         position: LatLng(event.location!.coordinates![1]?? 0.0, event.location!.coordinates![0]?? 0.0),
                         onTap: () {
                          _selectedEvent = event;
                          _showEventCard = true;
                          setState((){});
                         
                         },
                       ))).toSet();
  setState(() {});

  }
  Future<void> _liveLocation() async {
    print("live tracking");
     LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    
    Geolocator.getPositionStream(locationSettings: locationSettings).
    listen((Position position) { 
       setState(() => _currentPosition = position);
       googleMapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 12)));
   markers.clear();
  markers.add(Marker(markerId: const MarkerId('currentLocation'),
                     position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  events.map((event) => markers.add(
                 Marker(
                         markerId: MarkerId(event.id.toString()),
                         position: LatLng(event.location!.coordinates![1]?? 0.0, event.location!.coordinates![0]?? 0.0),
                         onTap: () {
                          _selectedEvent = event;
                          _showEventCard = true;
                          setState((){});
                         
                         },
                       ))).toSet();
  setState(() {});
       _saveLocation();
    });
  
  }
  void _onCameraIdle() {
    
  // googleMapController.moveCamera(CameraUpdate.newLatLng(LatLng(_currentPosition!.latitude, _currentPosition!.longitude)));
  calculateRadius(LatLng(newCenter.latitude,newCenter.latitude));
  
}
void calculateRadius(LatLng center) async {
    
    print(center);
    
    
    // print(visibleArea);
    LatLngBounds bounds = await googleMapController.getVisibleRegion();
    // print(bounds);
    LatLng northeast = bounds.northeast;
    LatLng southwest = bounds.southwest;
    LatLng northwest = new LatLng(bounds.northeast.latitude, bounds.southwest.longitude);
    LatLng southeast = new LatLng(bounds.southwest.latitude, bounds.northeast.longitude);
    // print(northeast);
    // print(southwest);
    double diagonal1 = await Geolocator.distanceBetween(northeast.latitude, northeast.longitude, southwest.latitude, southwest.longitude);
    // print(diagonal1);
    double diagonal2 = await Geolocator.distanceBetween(northwest.latitude, northwest.longitude, southeast.latitude, southeast.longitude);
    // print(diagonal2);
    double width1 = await Geolocator.distanceBetween(northwest.latitude, northwest.longitude, northeast.latitude, northeast.longitude);
    // print(width1);
    double width2 = await Geolocator.distanceBetween(southwest.latitude, southwest.longitude, southeast.latitude, southeast.longitude);
    // print(width2);
    double height1 = await Geolocator.distanceBetween(northwest.latitude, northwest.longitude, southwest.latitude, southwest.longitude);
    // print(height1);
    double height2 = await Geolocator.distanceBetween(northeast.latitude, northeast.longitude, southeast.latitude, southeast.longitude);
    // print(height2);
    double minDiagonal = min(diagonal1, diagonal2);
    double minWidth = min(width1, width2);
    double minHeight = min(height1, height2);
    double minDistance = minDiagonal;
    minDistance = min(minDistance, minWidth);
    minDistance = min(minDistance, minHeight);
    // print(minDistance);
    radius = 0.5 * minDistance;
    print(radius);
    _getDates();
}
 
   Set<Marker> markers = {};
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       
       body:Stack(
  children: <Widget>[
    
       _currentPosition == null
        ?  Center(child: CircularProgressIndicator())
        :  GoogleMap(
        onCameraIdle: _onCameraIdle,
        initialCameraPosition: CameraPosition(target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude), zoom: 12),
         markers: markers,
        // scrollGesturesEnabled: false,
        // rotateGesturesEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
            setState(() {
              print("showGoogleMap");
             googleMapController = controller;
             });
          googleMapController = controller;
          markers.clear();
  markers.add(Marker(markerId: const MarkerId('currentLocation'),
                     position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue)));
  events.map((event) => markers.add(
                 Marker(
                         markerId: MarkerId(event.id.toString()),
                         position: LatLng(event.location!.coordinates![1]?? 0.0, event.location!.coordinates![0]?? 0.0),
                         onTap: () {
                          _selectedEvent = event;
                          _showEventCard = true;
                          setState((){});
                         
                         },
                       ))).toSet();
  setState(() {});
        },
         onCameraMove: (CameraPosition position) {
         double zoom = position.zoom;
         newCenter = position.target;
        //  Future.delayed(Duration(milliseconds: 1000), () => _onCameraIdle(zoom));
         
        },
      ),
        Positioned(
          right: 40,
          top: 40,
          child: PopupMenuButton<String>(
                  onSelected: (String value) {
                  tag = value;
                  _getDates();
             },
             onCanceled: () {
               tag = null;
                _getDates();
             },
             tooltip: "choose",
             color: Color.fromARGB(255, 157, 179, 197),
           
                itemBuilder: (BuildContext context) {
                
                 return <PopupMenuEntry<String>>[
                 PopupMenuItem<String>(
                    value: 'Have a drink',
                    child: Text('Have a drink'),
                     ),
                   PopupMenuItem<String>(
                    value: 'Study partner',
                    child: Text('Study partner'),
                       ),
                       PopupMenuItem<String>(
                    value: 'Talking',
                    child: Text('Talking'),
                     ),
                   PopupMenuItem<String>(
                    value: 'Voluntery',
                    child: Text('Voluntery'),
                       ),
                       PopupMenuItem<String>(
                    value: 'Grab a bite',
                    child: Text('Grab a bite'),
                     ),
                   PopupMenuItem<String>(
                    value: 'Walking',
                    child: Text('Walking'),
                       ),
                       ];
                      },
                   child: Icon(Icons.more_vert_outlined,color: Colors.black,size:40),
)

     ),
        Positioned(
          left: 20,
          bottom: 20,
          child: FloatingActionButton.extended(
          label: const Text("Create a date"),
          icon: const Icon(Icons.schedule),
          backgroundColor:  Color.fromARGB(255, 102, 154, 196),
          onPressed: () {
            Navigator.pushReplacement(
                         context,
                        MaterialPageRoute(builder: (context) => CreateDatePage()));
  },
),
        ),
        _showEventCard ?  Stack(
      children: [
    // Your existing widgets here
      Positioned(
      top: 40,
      left: 40,
      right: 40,
      bottom: 40,
      child: Card(
       child: SingleChildScrollView(
         child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start ,
          children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20,left:20,bottom:20,right:20),
                child: IconButton(onPressed: (){
             setState(() { _showEventCard = false; });
          }
          ,icon: const Icon(Icons.close, color:Colors.black,size: 20, ),
          ),
              ),
              Row(
                children:[
                Expanded(
                  flex:1,
                  child:GestureDetector(
                    child: CircleAvatar(
                              backgroundImage:
                                NetworkImage(_selectedEvent.creator_image??'https://storage.googleapis.com/laqeene-bucket/%D9%84%D8%A7%D9%82%D9%8A%D9%86%D9%8A_(9).png',
                                scale:1.0
                                ),
                                 radius:30,
                                 backgroundColor: Colors.transparent,
                                 ),
                                  onTap: () {
                                    _getProfile(_selectedEvent.creator);
                                  },
                  ),
                ),
                
                Expanded(
                  flex:1,
                  child: Text(_selectedEvent.creator_username.toString(),
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                      ),),
                ),
                Expanded(
                  flex:1,
                  child: 
                  // Column(
                  //     children: [
                        Row(children: [
                  Icon(Icons.social_distance),
                  (_selectedEvent.distance! >= 1000) ?
                  Text(((_selectedEvent.distance!*0.001).toInt()).toString()+ " "+"Km")
                  : Text(((_selectedEvent.distance!).toInt()).toString()+ " "+"m")
                ],),
                //  Row(children: [
                //   Icon(Icons.percent_outlined),Text("70")
                // ],),
                    //   ],
                    // ),
                )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  Padding(
                     padding: const EdgeInsets.only(top:25,left: 30,right:30),
                     child:
                     Row(
                       children: [
                        Expanded(flex:1,
                        child: 
                        Row(
                          children: [
                            Icon(_selectedEvent.creator_gender == 'Female' ? (Icons.female_outlined) : Icons.male_outlined, size: 30,color: Colors.black,),
                            Text(_selectedEvent.creator_gender == 'Female' ? "Female" : "Male"),
                          ],
                        )),
                        VerticalDivider(color: Colors.black,width: 2),
                        Expanded(
                          flex:1,
                          child: Row(
                            children: [
              
                              Icon(Icons.elderly,size: 30, color: Colors.black,),
                              SizedBox(width:5),
                              Text(_selectedEvent.ageGap!.round().toString()+ " "+"Y"),

                            ],
                          ),
                        ),
                             Expanded(
                          flex:1,
                          child: Row(
                            children: [
              
                              Icon(Icons.incomplete_circle ,size: 30, color: Colors.black,),
                              SizedBox(width:5),
                              Text(_selectedEvent.similarity!.toString()+"%"),

                            ],
                          ),
                        ),
                       ],
                     ),
                  ),
                 
                 
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Text(_selectedEvent.description.toString()),
                    
                  ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:25.0,left: 30,right:30),
                      child: Row(
                children:[
                Expanded(
                  flex:2,
                  child: Row(children: [
                  Icon(Icons.date_range),
                  Text(_selectedEvent.startDate.toString().substring(0, 10),
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                           
                            fontSize: 14,
                        ),)
                ],)),
                 SizedBox(width:10),
                 Expanded(
                  flex:1,
                  child: Row(children: [
                  Icon(Icons.schedule_outlined),
                  Text(_selectedEvent.startDate.toString().substring(11,16),
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            
                            fontSize: 14,
                        ),
                  )
                ],)),
                Text("\t-\t",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                        ),),
               
                 Expanded(
                  flex:1,
                  child: Row(children: [
                  Icon(Icons.schedule_outlined),
                  Text(_selectedEvent.endDate.toString().substring(11,16),
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: Colors.black,
                            
                            fontSize: 14,
                        ),
                  )
                ],)),
                // Expanded(
                //   flex:1,
                //   child: Row(children: [
                //   Icon(Icons.social_distance),
                //   Text(((_selectedEvent.distance!*0.001).toInt()).toString()+ " "+"Km")
                // ],))
                ],
              ),
                    ),
                                Padding(
                 padding: const EdgeInsets.only(bottom:25,left: 30,right: 30 ),
                child: Column(
                  children: <Widget>[
    // other widgets
                    Wrap(
                    children: [
                 for (var tag in _selectedEvent.tags!) 
                      Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Chip(label: Text(tag!),
                      backgroundColor: Colors.pink.shade100,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                 ),),
                    ),
      ],
    ),
    // other widgets
  ],
)
                ),
                 Padding(
                   padding: const EdgeInsets.only(left:230),
                   child: GestureDetector(
                         onTap: (){
                          _sendRequest();
        
                         },
                         child: Container(
                          height: 65,
                          width:65,
                          decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 183, 236, 186),
                        ),
                        child: Row(
                          children: [
                            Text("\t\t\tJoin"),
                            Icon(Icons.check,color:Colors.black,size: 20.0,),
                          ],
                        ),
                      ),
                    ),
                 ),
                  
                ],
              ),
              
          ],
    ),
       ),
) ,
    ),
  ],
): Container(),
_showprofile ?  Stack(
      children: [
    // Your existing widgets here
      Positioned(
      top: 40,
      left: 40,
      right: 40,
      bottom: 40,
      child: Card(
       child: SingleChildScrollView(
         
         child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start ,
          children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top:20,left:20,bottom:20,right:20),
                child: IconButton(onPressed: (){
             setState(() { _showprofile = false; 
                         _showEventCard= true;
           });
          }
          ,icon: const Icon(Icons.close, color:Colors.black,size: 20, ),
          ),
              ),
              Row(
                children:[
                  SizedBox(width:20),
                Expanded(
                  flex:1,
                  child:GestureDetector(
                    child: CircleAvatar(
                              backgroundImage:
                                NetworkImage(profile["image"]??'https://storage.googleapis.com/laqeene-bucket/%D9%84%D8%A7%D9%82%D9%8A%D9%86%D9%8A_(9).png',
                                scale:1.0
                                ),
                                 radius:35,
                                 backgroundColor: Colors.transparent,
                                 ),
                                  onTap: () {
                                    // _getProfile(_selectedEvent.creator);
                                  },
                  ),
                ),
                
                Expanded(
                  flex:2,
                  child: Container( 
                      child:Column(
                      children:[
                        Text(profile["firstname"]! + " " + profile["lastname"]!,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    ),

                        ),
                        SizedBox(height:5),
                        Text("@" + _selectedEvent.creator_username.toString()!,
                        style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 15,
                    ),
                    
                        ),
                        SizedBox(height:5),
                        Row(
                          children: [
                            Icon(Icons.star, color:Colors.yellow,size: 10, ),
                            Icon(Icons.star, color:Colors.yellow,size: 10, ),
                            Icon(Icons.star, color:Colors.yellow,size: 10, ),
                            Icon(Icons.star, color:Colors.yellow,size: 10, ),
                            Icon(Icons.star_border, color:Colors.black,size: 10, ),
                          ],
                        )
                        ],
                      ),
                    ),
                ),
                Expanded(
                  flex:1,
                  child: SizedBox(width:10),
                ),
            
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center ,
                children: [
                  SizedBox(height:35),
                 Center(
                   
                   child: Text(profile["bio"].toString()),
                 ),
                    
                 
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: [
                  if(profile["job"]!="")
                    Padding(
                      padding: const EdgeInsets.only(top:45,bottom:10.0,left: 30),
                
                  child: Row(children: [
                  Icon(Icons.work),
                  SizedBox(width: 5,),
                      Flexible(
                                child:
                                RichText(
                                     text: TextSpan(
                                           text: "Works as\t",
                                           style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 15),
                                           children: <TextSpan>
                                           [
                                               TextSpan(text: profile["job"], 
                                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                            ],
                                      ),
                                      softWrap: true,
                                 ),
                                 ),
                 
                ],)),
                if(profile["university"]!="")
               
                       Padding
                       (
                          padding: const EdgeInsets.only(bottom:10.0,left: 30),
                          child: 
                          Row
                          (
                            children:
                            [
                                Icon(Icons.location_city),
                                SizedBox(width: 5,),
                                 Flexible(
                                child:
                                RichText(
                                     text: TextSpan(
                                           text: "Studies/Studied at\t",
                                           style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 15),
                                           children: <TextSpan>
                                           [
                                               TextSpan(text: profile["university"], 
                                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                            ],
                                      ),
                                      softWrap: true,
                                 ),
                                 ),
                                
                            
                            ],
                          )
                        ),
                if(profile["school"]!="")
               
                       Padding
                       (
                          padding: const EdgeInsets.only(bottom:10.0,left: 30),
                          child: 
                          Row
                          (
                            children:
                            [
                                Icon(Icons.school),
                                SizedBox(width: 5,),
                                  Flexible(
                                child:
                                RichText(
                                     text: TextSpan(
                                           text: "Went/going to\t",
                                           style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 15),
                                           children: <TextSpan>
                                           [
                                               TextSpan(text: profile["school"], 
                                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                            ],
                                      ),
                                      softWrap: true,
                                 ),
                                 ),
                               
                            ],
                          )
                        ),
                if(profile["city"]!="")
               
                       Padding
                       (
                          padding: const EdgeInsets.only(bottom:10.0,left: 30),
                          child: 
                          Row
                          (
                            children:
                            [
                                Icon(Icons.location_on),
                                SizedBox(width: 5,),
                                 Flexible(
                                child:
                                RichText(
                                     text: TextSpan(
                                           text: "From\t",
                                           style: Theme.of(context).textTheme.headline5?.copyWith(fontSize: 15),
                                           children: <TextSpan>
                                           [
                                               TextSpan(text: profile["city"], 
                                               style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                                            ],
                                      ),
                                      softWrap: true,
                                 ),
                                 ),
                               
                            ],
                          )
                        ),
                    
                    
                 Padding(
                 padding: const EdgeInsets.only(top:15,bottom:25,left: 30,right: 30 ),
                child: Column(
                  children: <Widget>[
    // other widgets
                    Wrap(
                    children: [
                 for (var tag in profile["interests"]!) 
                      Padding(
                      padding: const EdgeInsets.only(left:8.0),
                      child: Chip(label: Text(tag!),
                      backgroundColor: Colors.blue.shade100,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                 ),),
                    ),
      ],
    ),
    // other widgets
  ],
)
                ),
                
                  
                ],
              ),
              
          ],
    ),
       ),
) ,
    ),
  ],
): Container(),

],
    ),
     

    );
  }
    
   showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Location Services Disabled'),
          content: const Text('Please enable location services to continue.'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                serviceEnabled = await Geolocator.isLocationServiceEnabled();
                if (!serviceEnabled && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
                 else {
            _getCurrentPosition();
          }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
}

class Event {
  String? id;
  AgeGap? preferable_age_gap;
  List<String?>? tags;
  bool? is_full;
  String? creator;
  String? creator_username;
  DateTime? creator_birthday;
  String? creator_gender;
  String?creator_image;
  String? preferable_gender;
  Location? location;
  String? description;
  DateTime? startDate;
  DateTime? endDate;
  num? distance;
  double? ageGap;
  int? similarity;

  Event({
    required this.id,
    required this.preferable_age_gap,
    required this.tags,
    required this.is_full,
    required this.creator,
    required this.creator_username,
    required this.creator_birthday,
    required this.creator_gender,
    required this.creator_image,
    required this.preferable_gender,
    required this.location,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.distance,
    required this.ageGap,
    required this.similarity,
  });
  //  String toString() {
  //   return 'Event: {id: $id, creator: $creator_username, birthday: $creator_birthday}';
  // }

  Event.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    preferable_age_gap = (json['preferable_age_gap'] != null
        ? new AgeGap.fromJson(json['preferable_age_gap'])
        : null)!;
    tags = json['tags'].cast<String>();
    is_full = json['is_full'];
    creator = json['creator'];
    creator_username = json['creator_username'];
    creator_birthday = DateTime.parse(json['creator_birthday']);
    creator_gender = json['creator_gender'];
    creator_image = json['creator_image'];
    preferable_gender = json['preferable_gender'];
    location = (json['location'] != null
        ? new Location.fromJson(json['location'])
        : null)!;
    description = json['description'];
    startDate = DateTime.parse(json['startDate']);
    endDate = DateTime.parse(json['endDate']);
    distance = json['distance'];
    ageGap = json['ageGap'];
    similarity= json['similarity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.preferable_age_gap != null) {
      data['preferable_age_gap'] = this.preferable_age_gap?.toJson();
    }
    data['tags'] = this.tags;
    data['is_full'] = this.is_full;
    data['creator'] = this.creator;
    data['creator_username'] = this.creator_username;
    data['creator_birthday'] = this.creator_birthday?.toIso8601String();
data['creator_gender'] = this.creator_gender;
data['creator_image'] = this.creator_image;
data['preferable_gender'] = this.preferable_gender;
if (this.location != null) {
data['location'] = this.location?.toJson();
}
data['description'] = this.description;
data['startDate'] = this.startDate?.toIso8601String();
data['endDate'] = this.endDate?.toIso8601String();
data['distance'] = this.distance;
data['ageGap'] = this.ageGap;
data['similarity'] = this.similarity;
return data;
}
}

class AgeGap {
int? min_age_gap;
int? max_age_gap;

AgeGap({required this.min_age_gap, required this.max_age_gap});

AgeGap.fromJson(Map<String, dynamic> json) {
min_age_gap = json['min_age_gap'];
max_age_gap = json['max_age_gap'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['min_age_gap'] = this.min_age_gap;
data['max_age_gap'] = this.max_age_gap;
return data;
}
}

class Location {
String? type;
String? id;
List<double?>? coordinates;

Location({required this.type, required this.id, required this.coordinates});

Location.fromJson(Map<String, dynamic> json) {
type = json['type'];
id = json['_id'];
coordinates = json['coordinates'].cast<double>();
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['type'] = this.type;
data['_id'] = this.id;
data['coordinates'] = this.coordinates;
return data;
}
}

