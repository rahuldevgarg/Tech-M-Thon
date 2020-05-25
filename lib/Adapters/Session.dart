
import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  String uid;
  String scannedBy;
  String labID;
  int reason;
  int allowedFor;
  Timestamp enterTime;

  static List<String> Reasons = [
    "Reason 1",
    "Reason 2",
    "Reason 3"
  ];

  Session({this.uid, this.scannedBy,this.labID,this.reason,this.allowedFor,this.enterTime});

  Session.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    scannedBy = json['scannedBy'];
    labID = json['labID'];
    reason = json['reason'];
    allowedFor = json['allowedFor'];
    enterTime = json['enterTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['scannedBy'] = this.scannedBy;
    data['labID'] = this.labID;
    data['reason'] = this.reason;
    data['allowedFor'] =this.allowedFor;
    data['enterTime'] = this.enterTime;
    return data;
  }
}