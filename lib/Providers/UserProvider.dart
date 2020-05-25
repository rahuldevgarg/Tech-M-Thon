
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcttechnician/Adapters/Technician.dart';
import 'package:pcttechnician/Adapters/User.dart';

import '../main.dart';

class UserProvider with ChangeNotifier {
  String id;
  User userModel;
  Firestore db = Firestore.instance;

  Future<User> getUserFromUid(String volunteer) async {
    final cuser = await db
        .collection('users')
        .where('uid', isEqualTo:volunteer).getDocuments();
    if(cuser.documents.length==0){
      return null;
    }
    userModel=User.fromJson(cuser.documents[0].data);

    notifyListeners();
    return userModel;
  }




}






