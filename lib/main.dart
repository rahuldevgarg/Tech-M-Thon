import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcttechnician/Providers/UserProvider.dart';
import 'package:provider/provider.dart';

import 'Providers/TechnicianProvider.dart';
import 'Screens/Home.dart';
import 'Screens/Login.dart';

List<CameraDescription> cameras;

double getDeviceHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getDeviceWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
final FirebaseAuth auth = FirebaseAuth.instance;
final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserProvider()),
        ChangeNotifierProvider.value(value: TechnicianProvider()),
      ],
      child: StreamBuilder<ConnectivityResult>(
          stream: Connectivity().onConnectivityChanged,
          builder: (context, AsyncSnapshot<ConnectivityResult> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else {

              return MaterialApp(
                navigatorKey: navigatorKey,
                theme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.black,
                  accentColor: Colors.red,
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.black,
                  accentColor: Colors.red,
                ),
                debugShowCheckedModeBanner: false,
                home: snapshot.data == ConnectivityResult.none
                    ? NetError()
                    : SplashScreen(),
                routes: {
                  '/Home': (BuildContext context) => new Home(),
                  '/Login': (BuildContext context) => new Login(),
                },
              );
            }
          }),
    );
  }
}



class NetError extends StatefulWidget {
  @override
  _NetErrorState createState() => _NetErrorState();
}

class _NetErrorState extends State<NetError> {
  @override
  Widget build(BuildContext context) {
    var deviceHeight =
        getDeviceHeight(context) + MediaQuery.of(context).padding.top;
    var deviceWidth = getDeviceWidth(context);
    return Scaffold(
      body: Container(
        height: deviceHeight,
        width: deviceWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: Center(
          child: AlertDialog(
            title: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Please Check  Internet Connection"),
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {


  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Image.asset('assets/images/logos/techmahindra.png')),
    );
  }


  @override
  void initState() {

    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) {
      Navigator.of(context).pushReplacementNamed(Login.name);
    });

  }
}
