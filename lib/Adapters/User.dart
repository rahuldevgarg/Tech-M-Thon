
class User {
  String uid;
  String name;
  String email;
  bool isAuth = false;
  String phone;

  User({this.uid, this.name,this.email,this.isAuth =false,this.phone});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    email = json['email'];
    isAuth = json['isAuth'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['email'] = this.email;
    data['isAuth'] = this.isAuth;
    data['phone'] = this.phone;
    return data;
  }
}