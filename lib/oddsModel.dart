
class Odds {

  double draw;

  double v1Score;

  double v2Score;

  String? eventKey;

  Odds({
    required this.draw,
    required this.v1Score,
    required this.v2Score,
    required this.eventKey
  });
  Map<dynamic, dynamic> toJson() {
    return {
      "draw": draw,
      "v1Score": v1Score,
      "v2Score": v2Score,
      "eventKey": eventKey,
    };
  }

  factory Odds.fromJson(value,var json) {
    var respList = json['3Way Result'];
    var awayOdd=respList['Away']['1xbet'];
    var homeOdd=respList['Home']['1xbet'];
    var drawOdd=respList['Draw']['1xbet'];
    /*
    "12176": {
      "3Way Result"
     */
    return Odds(
      eventKey:value,
      v2Score: double.tryParse(awayOdd??"0.0")??0.0,
      v1Score: double.tryParse(homeOdd??"0.0")??0.0,
      draw: double.tryParse(drawOdd??"0.0")??0.0,
    );
  }
}

