class UploadFiles {
  String? id;
  String? name;
  String? extension;
  String? base64;
  String? uploadedBy;
  String? forCustomer;

  UploadFiles({
    this.id,
    this.name,
    this.extension,
    this.base64,
    this.uploadedBy,
    this.forCustomer,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      "id": id.toString(),
      "name": name.toString(),
      "extension": extension.toString(),
      "base64": base64.toString(),
      "uploadedBy": uploadedBy.toString(),
      "forCustomer": forCustomer.toString(),
    };
  }

  factory UploadFiles.fromJson(Map<dynamic, dynamic> json) {
    return UploadFiles(
      id: json['_id'],
      name: json['name'],
      extension: json['extension'],
      base64: json['base64'],
      uploadedBy: json['uploadedBy'],
      forCustomer: json['forCustomer'],
    );
  }
}
