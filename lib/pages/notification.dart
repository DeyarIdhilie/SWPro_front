import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
class notificationsPage extends StatefulWidget {
const notificationsPage({Key? key}) : super(key: key);
@override
  State<notificationsPage> createState() => _notificationsPageState();
}
class _notificationsPageState extends State<notificationsPage> {
  late List<Request> requests;
  bool declined = false;
  bool accepted = false;
  bool _showprofile = false;
  late Map<String, dynamic> profile;
  @override
  void initState() {
    super.initState();
    _loadRequests();
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
 
  setState(() {
    
  });
  print(profile);
  print(profile["_id"]); // access _id property
  print(profile["firstname"]); // access firstname property
  }
   decline(String? id) async {
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response = await dio.patch('http://192.168.1.7:3002/request/decline',data:{"requestId":id},);
         if(response.data["success"]== true)
            return true;
         else
            return false;
   }
     accept(String? id, String? theDate, String? requestCreator) async {
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response = await dio.patch('http://192.168.1.7:3002/request/accept',data:{"requestId":id,"requestCreatorId":requestCreator,"dateId":theDate},);
         if(response.data["success"]== true)
            return true;
         else
            return false;
   }
  Future<List<Request?>>? _loadRequests() async {
    
    print("load request");
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'token');
    Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    Response response = await dio.get('http://192.168.1.7:3002/request');
    print(response);
    requests = (response.data as List).map((i) => Request.fromJson(i)).toList();
   
    for (int i = 0; i < requests.length; i++) {
    print(requests[i].toString());
}
    print(requests);
    print(requests[0].requestCreatorUsername);
    print(requests[0].name?.firstName);
    return(requests);
    
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
        Stack(
       children: <Widget>[
        FutureBuilder(
                future:  _loadRequests(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                     return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
          return Card(
          child: ListTile(
            leading: GestureDetector(
              child: CircleAvatar(
                          backgroundImage: NetworkImage(requests[index].image!),
                      ),
                       onTap: () {
                                    _getProfile(requests[index].requestCreator);
                                  },
            ),
            title: Text(requests[index].name!.firstName! + " " + requests[index].name!.lastName! ),
            subtitle: Text("@" + " "+ requests[index].requestCreatorUsername!),
            trailing:  requests[index].accepted! ?
                       (requests[index].isViewed! ?
                           Padding(
                             padding: const EdgeInsets.only(top:8.0,bottom:8,right:20),
                            child: Container(
                              decoration: BoxDecoration(
                              color: Color.fromARGB(255, 74, 214, 79).withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                              ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text("Accepted", style: TextStyle(color: Colors.black),),
                          ),
                         ) :    Padding(
                             padding: const EdgeInsets.only(top:8.0,bottom:8,right:20),
                            child: Container(
                              decoration: BoxDecoration(
                              color: Color.fromARGB(255, 251, 152, 4).withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                              ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text("Unkown", style: TextStyle(color: Colors.black),),
                          ),
                         )
                         ):
                         (
                          requests[index].isViewed! ?
                          Padding(
                         padding: const EdgeInsets.only(top:8.0,bottom:8,right:20),
                         child: Container(
                              decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                              ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text("Declined", style: TextStyle(color: Colors.black),),
                          ),
                       )
                          :
                          (
                         declined ? Padding(
                         padding: const EdgeInsets.only(top:8.0,bottom:8,right:20),
                         child: Container(
                              decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                              ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text("Declined", style: TextStyle(color: Colors.black),),
                          ),
                       ) : (accepted? 
                       Padding(
                             padding: const EdgeInsets.only(top:8.0,bottom:8,right:20),
                            child: Container(
                              decoration: BoxDecoration(
                              color: Color.fromARGB(255, 74, 214, 79).withOpacity(0.8),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                              ),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Text("Accepted", style: TextStyle(color: Colors.black),),
                          ),
                         ) : Row(
                       mainAxisSize: MainAxisSize.min,
                       children: <Widget>[
                                 IconButton(
                                 icon: Icon(Icons.check,color: Color.fromARGB(255, 30, 203, 36),),
                                 onPressed: () {
                                   accept(requests[index].id,requests[index].theDate,requests[index].requestCreator).then((value) async {
                                        accepted = value;
                                        print(accepted );
                                        setState(() {
                                          
                                        });
                                     });
                                 },
                                 ),
                                 IconButton(
                                 icon: Icon(Icons.close, color: Color.fromARGB(255, 229, 35, 21),),
                                 onPressed: () {
                                     decline(requests[index].id).then((value) async {
                                        declined = value;
                                        print(declined );
                                        setState(() {
                                          
                                        });
                                     });
                                    
                                 },
                                 ),
                       ],
                     )
                       )
                  
                          )
                         ),
              onTap: () {},
          ),
        );
    },
        );
        }else{
            return Center(
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center ,
              children: [
                Text("No notifications to show"),
                SizedBox(height: 10,),
                CircularProgressIndicator()
                ]
              )
              );
           }
                 
           }),
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
}
class Request {
  
  Name? name;
  bool? accepted;
  bool? isViewed;
  bool? isDeleted;
  String? id;
  String? requestCreator;
  String? requestCreatorUsername;
  String? theDate;
  String? image;
  String? dateCreator;
  String? dateCreatorUsername;
  DateTime? createdAt;

  Request({
    required this.name,
    required this.accepted,
    required this.isViewed,
    required this.isDeleted,
    required this.id,
    required this.requestCreator,
    required this.requestCreatorUsername,
    required this.theDate,
    required this.image,
    required this.dateCreator,
    required this.dateCreatorUsername,
    required this.createdAt,
   
  });
 String toString() {
    return 'Event: {id: $id, requestCreator: $requestCreator, requestCreatorUsername: $requestCreatorUsername}';
  }
 Request.fromJson(Map<String, dynamic> json) {
   
      
      name = (json['name'] != null
        ? new Name.fromJson(json['name'])
        : null)!;
      accepted= json['accepted'];
      isViewed= json['is_viewed'];
      isDeleted= json['is_deleted'];
      id= json['_id'];
      requestCreator= json['request_creator'];
      requestCreatorUsername= json['request_creator_username'];
      theDate= json['theDate'];
      image= json['image'];
      dateCreator= json['Date_creator'];
      dateCreatorUsername= json['Date_creator_username'];
      createdAt = DateTime.parse(json['createdAt']);
    
    
  }
   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name?.toJson();
    }
    
    data['accepted'] = this.accepted;
    data['isViewed'] = this.isViewed;
    data['isDeleted'] = this.isDeleted;
    data['requestCreator'] = this.requestCreator;
    data['requestCreatorUsername'] = this.requestCreatorUsername;
    data['createdAt'] = this.createdAt?.toIso8601String();
    data['theDate'] = this.theDate;
    data['image'] = this.image;
    data['dateCreator'] = this.dateCreator;
    data['dateCreatorUsername'] = this.dateCreatorUsername;

return data;
}
}
class Name {
String? firstName;
String? lastName;

Name({required this.firstName, required this.lastName});

Name.fromJson(Map<String, dynamic> json) {
firstName = json['firstName'];
lastName = json['lastName'];
}

Map<String, dynamic> toJson() {
final Map<String, dynamic> data = new Map<String, dynamic>();
data['firstName'] = this.firstName;
data['lastName'] = this.lastName;
return data;
}
}