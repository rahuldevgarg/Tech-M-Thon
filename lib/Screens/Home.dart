import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pcttechnician/Adapters/ScannedUser.dart';
import 'package:pcttechnician/Adapters/User.dart';
import 'package:pcttechnician/Adapters/globals.dart';
import 'package:pcttechnician/Providers/UserProvider.dart';
import 'package:pcttechnician/Screens/MyNavigation.dart';
import 'package:pcttechnician/database/FirebaseDirectory.dart';
import 'package:pcttechnician/main.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class Home extends StatefulWidget{

  static const name = '/Home';
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Home>{
  bool hasCamera;
  User scannedUser;
  String _scanBarcode = 'Unknown';
  FirebaseDirectory _firebaseDirectory = new FirebaseDirectory();
  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }
  Future<void> scanUserID() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
    else{
      if(barcodeScanRes=="-1"){
        setState(() {
          scannedUser=null;
          gettingUser =false;
        });
      }else{
        setState(() {
          _scanBarcode = barcodeScanRes;
          gettingUser = true;
        });
        getfromdb(_scanBarcode);
      }

    }


  }
  User getfromdb(String pctID){
    ScannedUser scannedData;
    try{
      scannedData = ScannedUser.fromJson(jsonDecode(pctID));

    }catch(e){
      Fluttertoast.showToast(
          msg: "Bad Id",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        gettingUser =false;
      });
    }

    Provider.of<UserProvider>(context, listen: false)
        .getUserFromUid(scannedData.pctID).then((tuser) async {
          setState(() {
            scannedUser =tuser;
            scanned = tuser;
          });
          Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>MyNavigation(selected: 1,)));


      return tuser;
    });
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
  void initState() {
    super.initState();
    print(signTechnician.uid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getDeviceHeight(context),
      width: getDeviceWidth(context),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          gettingUser?
              Center(child: _loadingDialog(context, "Getting User..."))
              :Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: getDeviceHeight(context)*0.05,
                width: getDeviceWidth(context),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).accentColor)
                ),
                child: Center(child: Text("Lab : "+signTechnician.labID)),
              ),
              SizedBox(
                height: getDeviceHeight(context)*0.08,
              ),
              Container(
                height: getDeviceHeight(context)*0.25,
                width: getDeviceWidth(context),
                decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).accentColor)
                ),
                padding: EdgeInsets.all(getDeviceHeight(context)*0.015625),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Name : "),Text(signTechnician.name),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Phone : "),Text(signTechnician.phone),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Authorized : "),signTechnician.isAuth?Icon(Icons.check,color: Colors.green,):Icon(Icons.block,color: Colors.red,),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getDeviceHeight(context)*0.08,
              ),
              GestureDetector(
                onTap: () => scanUserID(),
                child: Container(
                  height: getDeviceHeight(context)*0.4,
                  width: getDeviceWidth(context)*0.4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                      border: Border.all(color: Colors.green)
                  ),
                  child: Center(
                    child: Text("Scan",style: TextStyle(fontSize: 16,
                      color: Colors.green
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}