class GoogleCodeModel {
  String? status;
  String? code;
  String? link;

  GoogleCodeModel({this.status, this.code, this.link});

  GoogleCodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['code'] = this.code;
    data['link'] = this.link;
    return data;
  }
}
