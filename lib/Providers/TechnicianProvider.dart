
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcttechnician/Adapters/Technician.dart';

import '../main.dart';

class TechnicianProvider with ChangeNotifier {
  FirebaseUser user;
  Technician technicianModel;
  Firestore db = Firestore.instance;

  Future<FirebaseUser> getCurrentUser() async {
    user = await auth.currentUser();
    return user;
  }

  Future<Technician> getTechnicianFromUid(FirebaseUser techUser) async {
    final cuser = await db
        .collection('users')
        .where('uid', isEqualTo:techUser.uid).getDocuments();
    if(cuser.documents.length==0){
      return null;
    }
    technicianModel=Technician.fromJson(cuser.documents[0].data);

    notifyListeners();
    return technicianModel;
  }




}






