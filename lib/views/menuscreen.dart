import 'dart:io';
import 'package:destiny/views/about.dart';
import 'package:destiny/views/homescreen.dart';
import 'package:destiny/views/replayscreen.dart';
import 'package:destiny/views/youtube.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:wakelock/wakelock.dart';

import '../constants.dart';
class MenuScreen extends StatefulWidget {
  static int idpage = 0;

  @override
  _MenuState createState() => _MenuState();
}

enum AppState { idle, connected, mediaLoaded, error }
const int maxFailedLoadAttempts = 3;
class _MenuState extends State<MenuScreen>
    with AutomaticKeepAliveClientMixin<MenuScreen> {
  @override
  bool get wantKeepAlive => true;
  String title = "Home";
  int isShow = 0;
  @override
  void initState() {
    super.initState();
    Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void pageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
        MenuScreen.idpage = index;
        /*if (index == 0) {
          title = "Accueil";
        } else*/
        if (index == 0) {
          title = "Home";
        } else if (index == 1) {
          title = "Replay";
        } else if (index == 2) {
          title = "YouTube";
        }else if (index == 3) {
          title = "About";
        }
      },
      children: <Widget>[
        new HomeScreen(),
        new ReplayScreen(),
        new YoutubeScreen(),
        new AbouScreen(),
        /*new YoutubeChannelScreen(
          apiKey: widget.apiResponse.api[2].apiKey,
          channelId: widget.apiResponse.api[2].feedUrl,
        ),*/
      ],
    );
  }

  int _page = 0;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    fontFamily: 'CeraPro',
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              SizedBox(width: 50,)
            ],
          ),
          actions: [
          ],
          centerTitle: true,
          flexibleSpace: Container(
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: buildPageView(),
        bottomNavigationBar: salomonBottomNavigation(),
        backgroundColor: colorPrimary,
      ),
    );
  }


  Widget salomonBottomNavigation() {
    return SalomonBottomBar(
      currentIndex: _page,
      curve: Curves.ease,
      onTap: (i) => setState((){
        _page= i;
        pageController.animateToPage(i,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
      } ),
      unselectedItemColor: Colors.white,
      items: [
        SalomonBottomBarItem(
          icon: Icon(FontAwesomeIcons.tv),
          title: Text(" TV"),
          selectedColor: Colors.white,
        ),

        SalomonBottomBarItem(
          icon: new SvgPicture.asset(
            "$imageUri/replay.svg",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          title: Text("Replay"),
          selectedColor: Colors.white,
        ),

        SalomonBottomBarItem(
          icon: new SvgPicture.asset(
            "$imageUri/youtube.svg",
            width: 20,
            height: 20,
            color: Colors.white,
          ),
          title: Text("YouTube"),
          selectedColor: Colors.white,
        ),

        SalomonBottomBarItem(
          icon: Icon(Icons.info),
          title: Text("About"),
          selectedColor: Colors.white,
        ),
      ],
    );
  }

  Widget appBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontFamily: 'CeraPro',
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          SizedBox(width: 50,)
        ],
      ),
      actions: [
      ],
      centerTitle: true,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [colorPrimary, colorPrimary],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          /*borderRadius:
                  BorderRadius.circular(10.0)*/
        ),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }
}
