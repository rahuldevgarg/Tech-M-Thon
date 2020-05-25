

class Lab {

  String name;
  String labID;

  Lab({this.name,this.labID});

  Lab.fromJson(Map<String, dynamic> json) {

    name = json['name'];
    labID = json['name'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['labID'] = this.labID;
    return data;
  }
}