import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pcttechnician/Adapters/Lab.dart';
import 'package:pcttechnician/Adapters/Session.dart';
import 'package:pcttechnician/Adapters/Technician.dart';
import 'package:pcttechnician/Adapters/globals.dart';

import '../main.dart';
class FirebaseDirectory {
  final firestoreInstance = Firestore.instance;
  String errorMessage;

  Future<Map<String, dynamic>> getUserFormId(String id) async {
    QuerySnapshot list = await firestoreInstance
        .collection('users')
        .where('uid', isEqualTo: id)
        .getDocuments();
    return list.documents[0].data;
  }
  Future<List<Session>> getSessionsForUser(String id,String labID) async {
    QuerySnapshot list = await firestoreInstance
        .collection('Sessions')
        .where('uid', isEqualTo: id).where('labID',isEqualTo: signTechnician.labID).orderBy('enterTime',descending: true).limit(4)
        .getDocuments();
    List<Session> temp = [];
    list.documents.forEach((element) { 
      temp.add(
        Session.fromJson(element.data)
      );
    });
    return temp;
  }
  Future<List<Session>> getAllSessionsForUser(String id,) async {
    QuerySnapshot list = await firestoreInstance
        .collection('Sessions')
        .where('uid', isEqualTo: id).orderBy('enterTime',descending: true).limit(4)
        .getDocuments();
    List<Session> temp = [];
    list.documents.forEach((element) {
      temp.add(
          Session.fromJson(element.data)
      );
    });
    return temp;
  }
  Future<Map<String,String>> getAllLabs() async {
    QuerySnapshot list = await firestoreInstance
        .collection('Labs')
        .getDocuments();
    Map<String,String> labs;
//    list.documents.forEach((element) {
//      labs.putIfAbsent(element.data['labID'], () => element.data['name']);
//
//    });
    labs = Map<String,String>.fromIterable(list.documents,key:(item)=>item['labID'],value: (item)=>item['name'] );
    return labs;
  }
  Future<Lab> getLabFromId(String labID) async {
    DocumentSnapshot ds = await Firestore.instance.collection("Labs").document(labID).get();
    Lab temp = Lab.fromJson(ds.data);
    return temp;
  }
  Future<Session> AddSessionForUser(Map<String,dynamic> data) async {
    Session temp = await
    Firestore.instance.collection('Sessions').add(data).then((value) async{
      DocumentSnapshot ds = await value.get();
      return Session.fromJson(ds.data);
    });

    return temp;
  }





  Future<Technician> getUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    final doctor = await firestoreInstance
        .collection('users')
        .where('uid', isEqualTo: user.uid)
        .getDocuments();
    return Technician.fromJson(doctor.documents[0].data);
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    AuthResult authResult = await auth.signInWithCredential(credential);
    final FirebaseUser guser = authResult.user;
    // Checking if email and name is null
    assert(guser.email != null);
    assert(guser.displayName != null);
    assert(guser.photoUrl != null);

    assert(!guser.isAnonymous);
    assert(await guser.getIdToken() != null);

    final FirebaseUser currentUser = await auth.currentUser();
    assert(guser.uid == currentUser.uid);

    return guser;
  }


  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await auth.currentUser();
    return user;
  }


  signOutGoogle() async {

    await GoogleSignIn().signOut();
    print("User Sign Out");
  }

  signOut() async {
    await auth.signOut();
    print("User Sign Out");
  }

  Future<FirebaseUser> signUpWithEmail(String email,String password) async {
    FirebaseUser signupuser;
    try {
      signupuser = (await auth.createUserWithEmailAndPassword(
        email: email, password: password,
      )).user;
      if (signupuser != null) {
        return signupuser;
      }

    } catch (e) {
      return null;

    }
  }

  Future<FirebaseUser> signInWithEmail(String email,String password) async {
    print("sign in with email");
    // marked async
    FirebaseUser euser;
    try {
      euser = (await auth.signInWithEmailAndPassword(
          email: email, password: password)).user;
      if (euser != null) {
        return euser;

      }else{
        print(errorMessage);
      }
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Incorrect password.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        default:
          errorMessage = "Something went wrong.";
      }
    }
  }

  void recoverPassword(String email){
    auth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> CheckLogin() async {
    FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    //print("User: ${_user.displayName==null ? "None":_user.displayName}");
    return _user;}










}

