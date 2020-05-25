class ScannedUser {
  String type;
  String pctID;

  ScannedUser(this.type, this.pctID);

  factory ScannedUser.fromJson(dynamic json) {
    return ScannedUser(json['type'] as String, json['pctID'] as String);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['pctID'] = this.pctID;
    return data;
  }
  @override
  String toString() {
    return toJson().toString();
  }
}