class Bet {
  String? id;

  String betSlipID;

  String game;

  String oponents;

  String placement;

  double rate;

  double returnRate;

  int stakes;

  String status;

  double totalPrice;

  String type;

  String homeIcon;

  String awayIcon;

  String createdByEmail;

  String createdByBetID;

  String createdAt;

  String eventKey;

  String walletID;


  Bet({
    this.id,
    required this.betSlipID,
    required this.game,
    required this.oponents,
    required this.placement,
    required this.rate,
    required this.returnRate,
    required this.stakes,
    required this.status,
    required this.totalPrice,
      required this.type,
      required this.homeIcon,
      required this.awayIcon,
      required this.createdByBetID,
      required this.createdByEmail,
      required this.createdAt,
      required this.eventKey,
      required this.walletID});
  Map<String, dynamic> toJson() {
    return {
      "betSlipID": betSlipID,
      "game": game,
      "oponents": oponents,
      "placement": placement,
      "rate": rate,
      "returnRate": returnRate,
      "stakes": stakes,
      "status": status,
      "totalPrice": totalPrice,
      "type": type,
      "homeIcon":homeIcon,
      "awayIcon":awayIcon,
      "createdByBetID":createdByBetID,
      "createdByEmail":createdByEmail,
      "createdAt":createdAt,
      "eventKey":eventKey,
      "walletID":walletID

    };
  }

  factory Bet.fromJson(Map<dynamic, dynamic> json) {
    return Bet(
      id: json['_id'],
      betSlipID: json['betSlipID'],
      oponents: json['oponents'],
      placement: json['placement'],
      game: json['game'],
      rate: json['rate'],
      returnRate: json['returnRate'],
      stakes: json['stakes'],
      status: json['status'],
      totalPrice: json['totalPrice'],
      type: json['type'],
      awayIcon: json['awayIcon'],
      homeIcon: json['homeIcon'],
      createdByBetID: json['createdByBetID'],
      createdByEmail: json['createdByEmail'],
      createdAt: json['createdAt'],
      walletID: json['walletID'],
      eventKey: json['eventKey'],
    );
  }
}
