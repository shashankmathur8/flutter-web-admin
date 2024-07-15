class Company {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? fax;
  String? createdAt;
  String? pOC;
  String? creditStatus;
  String? companyID;
  List? sales;
  List? negSales;
  List? level1Status;
  List? level2Status;
  List? level3Status;
  List topPerformers;

  Company(
      {this.id,
      this.name,
      this.email,
      this.companyID,
      this.phone,
      this.fax,
      this.createdAt,
      this.creditStatus,
      this.pOC,
      this.sales,
      this.negSales,
      this.level1Status,
      this.level2Status,
      this.level3Status,
      required this.topPerformers});

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "pOC": pOC??"Contact@${name}.com",
      "name": name,
      "creditStatus": creditStatus??"Good",
      "email": email,
      "companyID": companyID,
      "createdAt": createdAt,
      "fax": fax,
      "phone": phone,
      "sales": sales??[],
      "negSales": negSales??[],
      "topPerformers": topPerformers,
      "level1Status":level1Status,
      "level2Status":level2Status,
      "level3Status":level3Status

    };
  }

  factory Company.fromJson(Map<dynamic, dynamic> json) {
    return Company(
      id: json['_id'],
      phone: json['phone'],
      name: json['name'],
      fax: json['fax'],
      email: json['email'],
      companyID: json['companyID'],
      creditStatus: json['creditStatus'],
      pOC: json['pOC'],
      createdAt: json['createdAt'],
      sales: json['sales'],
      negSales: json['negSales'],
      topPerformers: json['topPerformers'],
      level1Status: json['level1Status'],
      level2Status: json['level2Status'],
      level3Status: json['level3Status']
    );
  }
}
