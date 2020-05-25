
class Technician {
  String uid;
  String name;
  String email;
  String labID;
  bool isAuth;
  String phone;

  Technician({this.uid, this.name,this.email,this.labID});

  Technician.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    labID = json['labID'];
    isAuth = json['isAuth'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['labID'] = this.labID;
    data['isAuth'] = this.isAuth;
    data['phone'] = this.phone;
    return data;
  }
}