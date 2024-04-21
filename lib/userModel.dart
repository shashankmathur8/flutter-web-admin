class User {
  String? id;

  String? losingBets;

  String? betID;

  String? country;

  bool? isDarkMOdeSelected;

  bool? isPrimeUSer;

  String? name;

  String? state;

  String? userEmail;

  String? userID;

  String? walletID;

  String? winingBets;

  String? password;

  User({
    this.id,
    required this.losingBets,
    required this.betID,
    required this.country,
    required this.isDarkMOdeSelected,
    required this.isPrimeUSer,
    required this.name,
    required this.state,
    required this.userEmail,
    required this.userID,
    required this.walletID,
    required this.winingBets,
    this.password
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "losingBets": losingBets,
      "betID": betID,
      "country": country,
      "isDarkMOdeSelected": isDarkMOdeSelected,
      "isPrimeUSer": isPrimeUSer,
      "name": name,
      "state": state,
      "userEmail": userEmail,
      "userID": userID,
      "walletID": walletID,
      "winingBets": winingBets,
    };
  }

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      id: json['_id'],
      winingBets: json['winingBets'],
      walletID: json['walletID'],
      userID: json['userID'],
      userEmail: json['userEmail'],
      state: json['state'],
      name: json['name'],
      isPrimeUSer: json['isPrimeUSer'],
      isDarkMOdeSelected: json['isDarkMOdeSelected'],
      country: json['country'],
      betID: json['betID'],
      losingBets: json['losingBets'],
      password: json['password']
    );
  }
}
