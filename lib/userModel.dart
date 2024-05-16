class User {
  String? id;
  String? username;
  String? name;
  String? password;
  String? email;
  String? companyID;
  String? phoneNo;
  String? fax;
  List? accessLevel;
  String? city;
  String? state;
  String? country;
  double? rating;
  double? activity;
  bool? isEnabled;
  String? profile;
  bool? isAdmin;

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


    );
  }
}
