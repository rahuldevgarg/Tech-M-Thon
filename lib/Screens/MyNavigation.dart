import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcttechnician/Adapters/Technician.dart';
import 'package:pcttechnician/Providers/TechnicianProvider.dart';
import 'package:provider/provider.dart';


import '../main.dart';
import 'Home.dart';
import 'VolunteerRecords.dart';

class MyNavigation extends StatefulWidget {
  int selected = 0;
  String query = '';


  MyNavigation({this.selected = 0, this.query = '',});

  @override
  _MyNavigationState createState() => _MyNavigationState();
}

class _MyNavigationState extends State<MyNavigation> {
  final key = GlobalKey();
  bool isLoading = true;
  String val = '';
  List<Widget> pages = [
    Home(),
    VolunteerRecords(),
  ];

  Technician technicianModel = Technician();

  @override
  void initState() {
    this.technicianModel =
        Provider.of<TechnicianProvider>(context, listen: false).technicianModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
    List<Widget> appbars = [
      AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Home",
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: getDeviceHeight(context) * 0.025 - 0.72),
        ),
        leading: new Container(),
        centerTitle: true,
      ),
      AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Volunteer Records",
          style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: getDeviceHeight(context) * 0.025 - 0.72),
        ),
        leading: new Container(),
        centerTitle: true,
      ),
    ];

    final mediaQuery = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Are you sure you want to close app"),
              actions: <Widget>[
                FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ));
        return null;
      },
      child: Scaffold(
        appBar: appbars[widget.selected],
        //drawer: CustomDrawer(),
        body: ListView(
          children: <Widget>[
            Container(
              height: mediaQuery.height-
                  MediaQuery.of(context).padding.top-AppBar().preferredSize.height,
              child: pages[widget.selected],
            )
          ],
        ),
//        bottomMyNavigationBar: BottomMyNavigationBar(
//          currentIndex: widget.selected,
//          selectedItemColor: Theme.of(context).primaryColor,
//          unselectedItemColor: Colors.black,
//          type: BottomMyNavigationBarType.fixed,
//          items: [
//            BottomMyNavigationBarItem(
//              icon: ImageIcon(
//                AssetImage("assets/user.png"),
//                size: getDeviceHeight(context) * 0.0390625,
//              ),
//              title: Text(
//                'Profile',
//              ),
//            ),
//          ],
//          onTap: (index) {
//            setState(() {
//              widget.selected = index;
//              print(widget.selected);
//            });
//          },
//        ),
      ),
    );
  }
}
