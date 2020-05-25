
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:pcttechnician/Adapters/Lab.dart';
import 'package:pcttechnician/Adapters/Session.dart';
import 'package:pcttechnician/Adapters/globals.dart';
import 'package:pcttechnician/database/FirebaseDirectory.dart';

import '../main.dart';
import 'MyNavigation.dart';

class VolunteerRecords extends StatefulWidget {
  @override
  _VolunteerRecordsState createState() => _VolunteerRecordsState();
}

class _VolunteerRecordsState extends State<VolunteerRecords> {
  Lab current;
  int currentLabSessionCount = 0;
  FirebaseDirectory _firebaseDirectory = new FirebaseDirectory();
  Map<String, String> allLabs;
  int allOtherLabsSessionCount = 0;
  Session currentLabLastSession;
  bool loadingStats;
  int totalSessions = 0;
  Map<String, int> reasons;
  Map<String, dynamic> otherLabs;

  @override
  void initState() {
    setState(() {
      loadingStats = true;
    });
    loadStats();
    super.initState();
  }

  loadStats() async {
    await _firebaseDirectory.getAllLabs().then((value) {
      setState(() {
        allLabs = value;
      });
    });
    await _firebaseDirectory.firestoreInstance
        .collection('Sessions')
        .where('uid', isEqualTo: scanned.uid)
        .getDocuments()
        .then((value) {
      setState(() {
        totalSessions = value.documents.length;
      });
    });
    await _firebaseDirectory.firestoreInstance
        .collection('Sessions')
        .where('uid', isEqualTo: scanned.uid)
        .where('labID', isEqualTo: signTechnician.labID)
        .orderBy('enterTime', descending: true)
        .getDocuments()
        .then((value) {
      Map<String, int> rdata = new Map<String, int>();
      Session.Reasons.forEach((reason) {
        int icount = 0;
        value.documents.forEach((element) {
          if (Session.Reasons[element['reason']] == reason) icount += 1;
        });
        rdata[reason] = icount;
      });

      setState(() {
        currentLabSessionCount = value.documents.length;
        reasons = rdata;
        currentLabLastSession = Session.fromJson(value.documents.first.data);
      });

    });
    Map<String, int> ldata = new Map<String, int>();

//print(key);
     await  _firebaseDirectory.firestoreInstance
          .collection('Sessions')
          .where('uid', isEqualTo: scanned.uid)
          .getDocuments()
          .then((values) {
        print(values.documents.isEmpty);

        allLabs.forEach((key, value)  {
          int count= 0;
        values.documents.where((doc) => doc['labID']==key).forEach((element) {
          count+=1;
        });
        print(value+" "+count.toString());
        ldata[value] = count;
     });



        setState(() {
          otherLabs = ldata;
          print(otherLabs.toString());
          allOtherLabsSessionCount = ldata.length;
          loadingStats = false;
        });
      });



  }

  Widget UserRecords() {
    if(otherLabs!=null)
    otherLabs.remove(allLabs[signTechnician.labID]);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: getDeviceHeight(context) * 0.02,
          ),
          currentLabLastSession != null
              ? Text(
                  "${allLabs[signTechnician.labID]} accessed ${currentLabSessionCount} times. Last on ${DateFormat("MMM dd, yyyy").format(currentLabLastSession.enterTime.toDate())}")
              : Text(
                  "Nothing Here",
                  style: TextStyle(color: Colors.white),
                ),
          SizedBox(
            height: getDeviceHeight(context) * 0.02,
          ),
          Container(
            height: getDeviceHeight(context) * 0.15,
            width: getDeviceWidth(context),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor)),
            padding: EdgeInsets.all(getDeviceHeight(context) * 0.015625),
            child: currentLabSessionCount > 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (int i = 0; i < Session.Reasons.length; i++)
                        Row(
                          children: <Widget>[
                            Text(
                              '${i + 1}. ' +
                                  Session.Reasons[i] +
                                  ' : ' +
                                  reasons[Session.Reasons[i]].toString(),
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                    ],
                  )
                : Text("No Previous Record for this Lab"),
          ),
          SizedBox(
            height: getDeviceHeight(context) * 0.08,
            child: Text("Other Labs"),
          ),

              Container(
            height: getDeviceHeight(context) * 0.15,
            width: getDeviceWidth(context),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor)),
            padding: EdgeInsets.all(getDeviceHeight(context) * 0.015625),
            child: allOtherLabsSessionCount > 0?Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      for (int i = 0; i < otherLabs.length; i++)
                        Row(
                          children: <Widget>[
                            Text('${i + 1}. ' +
                                allLabs.values.toList().elementAt(i) +
                                ' : ' +otherLabs[allLabs.values.toList().elementAt(i)].toString()
                                )
                          ],
                        ),
                    ],
                  ): Text("No Previous Record "),

          ),
        ],
      ),
    );
  }
  Widget Allow(BuildContext context){
    String phone =scanned.phone;
    int reason = 0;
    final _FormKey = GlobalKey<FormState>();
    FocusNode focusNode = FocusNode();
    TextEditingController editphone = new TextEditingController();
    TextEditingController duration = new TextEditingController();
    List _reasons = Session.Reasons;


    List<DropdownMenuItem<int>> getDropDownMenuReasonItems() {
      List<DropdownMenuItem<int>> items = new List();
      for (String reason in _reasons) {
        items.add(
            new DropdownMenuItem(value: Session.Reasons.indexOf(reason), child: new Text(reason)));
      }
      return items;
    }
    List<DropdownMenuItem<int>> _dropDownMenuReasonItems=getDropDownMenuReasonItems() ;

    void changedDropDownItem(int selectedReason) {
      setState(() {
        reason = selectedReason;
      });
    }
    return Container(
      height: getDeviceHeight(context)*0.4,
      width: getDeviceWidth(context)*0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[

          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
            new Text("Reason: "),
            new Container(
              padding: new EdgeInsets.all(16.0),
            ),
            new DropdownButton(
              value: reason,
              items: _dropDownMenuReasonItems,
              onChanged: changedDropDownItem,
            )
          ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Name : "),Text(scanned.name)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text("Verified : "),scanned.isAuth?Icon(Icons.check,color: Colors.green,):Icon(Icons.block,color: Colors.red,)
            ],
          ),
          Form(
            key: _FormKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      left: getDeviceWidth(context) * 0.055555556,
                      right: getDeviceWidth(context) * 0.055555556),
                  child: TextFormField(
                    onEditingComplete: () {
                      FocusNode().requestFocus(focusNode);
                    },
                    style: TextStyle(
                        color: Colors.white
                    ),
                    controller: duration,
                    cursorColor: Colors.redAccent,
                    keyboardType: TextInputType.phone,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        hintText: "Allowed for (min)"
                    ),
                    validator: (value) {
                      if (value.length<10) {
                        return 'Allowed For';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                      left: getDeviceWidth(context) * 0.055555556,
                      right: getDeviceWidth(context) * 0.055555556),
                  child: TextFormField(
                    onEditingComplete: () {
                      FocusNode().requestFocus(focusNode);
                    },
                    style: TextStyle(
                        color: Colors.white
                    ),
                    controller: editphone,
                    cursorColor: Colors.redAccent,
                    keyboardType: TextInputType.phone,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                        hintText: phone
                    ),

                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: ()  {

                  if((editphone.text.isNotEmpty && editphone.text.length<10) ||duration.text.isEmpty){
                    Fluttertoast.showToast(
                        msg: "Fill details",
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }else{
                    Session newSession = Session(uid: scanned.uid,scannedBy: signTechnician.uid,labID: signTechnician.labID,reason: reason,allowedFor: int.parse(duration.text),enterTime: Timestamp.now());
                    _firebaseDirectory.AddSessionForUser(newSession.toJson()).then((value) {
                      print(value.enterTime.toDate());
                      setState(() {
                        scanned=null;
                      });
                      _firebaseDirectory.AddSessionForUser(newSession.toJson()).whenComplete((){
                        Fluttertoast.showToast(
                            msg: "Record Updated",
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => MyNavigation()));
                      });
                    });

                  }
                },
                child: Container(
                  height: getDeviceHeight(context)*0.05,
                  width: getDeviceWidth(context)*0.1,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green)
                  ),
                  child: Center(
                    child: Text("Allow",style: TextStyle(color: Colors.green),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    scanned=null;
                  });
                  Fluttertoast.showToast(
                      msg: "Rejected",
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MyNavigation()));

                  print("Rejected");
                },
                child: Container(
                  height: getDeviceHeight(context)*0.05,
                  width: getDeviceWidth(context)*0.1,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red)
                  ),
                  child: Center(
                    child: Text("Reject",style: TextStyle(color: Colors.red),),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
  Widget _loadingDialog(BuildContext context,String text) {
    return Center(
      child: Container(
          width: MediaQuery.of(context).size.width * 0.750,
          height: MediaQuery.of(context).size.height * 0.084,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(getDeviceWidth(context) * 0.027777778 * 1.00)),
            color: Colors.grey[900],
            elevation: getDeviceWidth(context) * 0.027777778 * 1.5,
            child: Center(
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: getDeviceWidth(context)*0.055555556,
                    ),
                    CircularProgressIndicator(
                        valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.greenAccent)),
                    SizedBox(
                      width: getDeviceWidth(context)*0.055555556,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: getDeviceWidth(context) * 0.027777778 * 2.0),
                    ),
                  ],
                )),
          )),
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: scanned==null?

          Center(
            child: _loadingDialog(context, "Authorizing..."),
          )



          :Column(
        children: <Widget>[
          Container(
            height: getDeviceHeight(context) * 0.05,
            width: getDeviceWidth(context),
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).accentColor)),
            child: Center(child: Text("Volunteer : " + scanned.name)),
          ),
          totalSessions != 0
              ? UserRecords()
              : Container(
                  height: getDeviceHeight(context) * 0.5,
                  width: getDeviceWidth(context),
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "No Previous Record.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          SizedBox(
            height: getDeviceHeight(context) * 0.01,
          ),
          Allow(context)
        ],
      ),
    );
  }
}
