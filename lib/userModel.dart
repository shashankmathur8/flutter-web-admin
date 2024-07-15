class User {
  String? id;
  String? username;
  String? name;
  String? password;
  String? email;
  String? companyID;
  String? phoneNo;
  String? fax;
  String? accessLevel;
  List? notif;
  String? city;
  String? state;
  String? country;
  double? rating;
  double? activity;
  bool? isEnabled;
  String? profile;
  bool? isAdmin;
  List?level3Access;

  bool? isLevel1Enabled;
  bool? isLevel2Enabled;
  bool? isLevel3Enabled;

  User({
    this.id,
    this.username,
    this.name,
    this.password,
    this.email,
    this.companyID,
    this.phoneNo,
    this.fax,
    this.accessLevel,
    this.city,
    this.state,
    this.country,
    this.rating,
    this.activity,
    this.isEnabled,
    this.profile,
    this.isAdmin,
    this.notif,
    this.level3Access,
    this.isLevel1Enabled,
    this.isLevel2Enabled,
    this.isLevel3Enabled
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "username": username,
      "name": name,
      "password": password,
      "email": email,
      "companyID": companyID,
      "phoneNo": phoneNo,
      "fax": fax,
      "accessLevel": accessLevel,
      "city": city,
      "state": state,
      "country": country,
      "rating": rating,
      "activity": activity,
      "isEnabled": isEnabled,
      "profile": profile,
      "isAdmin": isAdmin,
      "notif":notif,
      "level3Access":level3Access,
      "isLevel1Enabled":isLevel1Enabled,
      "isLevel2Enabled":isLevel2Enabled,
      "isLevel3Enabled":isLevel3Enabled,
    };
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        id: json['_id'],
        username: json['username'],
        name: json['name'],
        password: json['password'],
        email: json['email'],
        companyID: json['companyID'],
        phoneNo: json['phoneNo'],
        fax: json['fax'],
        accessLevel: json['accessLevel'],
        city: json['city'],
        state: json['state'],
        country: json['country'],
        rating: json['rating'],
        activity: json['activity'],
        isEnabled: json['isEnabled'],
        profile: json['profile'],
        isAdmin: json['isAdmin'],
        notif: json['notif'],
        level3Access: json['level3Access'],
        isLevel1Enabled:json["isLevel1Enabled"]??false,
        isLevel2Enabled:json["isLevel2Enabled"]??false,
        isLevel3Enabled:json["isLevel3Enabled"]??false,);
  }
}
