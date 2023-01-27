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
  
  double? distance;
  double? ageGap;

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
  });

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

