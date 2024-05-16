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
      required this.topPerformers});

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id,
      "pOC": pOC,
      "name": name,
      "creditStatus": creditStatus,
      "email": email,
      "companyID": companyID,
      "createdAt": createdAt,
      "fax": fax,
      "phone": phone,
      "sales": sales,
      "negSales": negSales,
      "topPerformers": topPerformers,
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
    );
  }
}
