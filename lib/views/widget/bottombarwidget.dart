
import 'package:destiny/views/about.dart';
import 'package:destiny/views/replayscreen.dart';
import 'package:destiny/views/youtube.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../homescreen.dart';

class BottomNavBarFb5 extends StatelessWidget {
  const BottomNavBarFb5({Key? key}) : super(key: key);

  final primaryColor = const Color(0xff4338CA);
  final secondaryColor = const Color(0xff6D28D9);
  final accentColor = const Color(0xffffffff);
  final backgroundColor = const Color(0xffffffff);
  final errorColor = const Color(0xffEF4444);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        color: Colors.black,
        //borderRadius: BorderRadius.circular(8),
      ),
      child: BottomAppBar(
        elevation: 0,
        color: Colors.transparent,
        child: SizedBox(
          height: 56,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBottomBar(
                    text: "Tv",
                    icon: Icons.tv,
                    selected: true,
                    onPressed: () {
                      Get.to(HomeScreen());
                    }),
                IconBottomBar(
                    text: "Replay",
                    icon: Icons.replay,
                    selected: false,
                    onPressed: () {
                      Get.to(ReplayScreen());
                    }),
                IconBottomBar(
                    text: "Youtube",
                    icon: Icons.youtube_searched_for,
                    selected: false,
                    onPressed: () {
                      Get.to(YoutubeScreen());
                    }),
                IconBottomBar(
                    text: "About",
                    icon: Icons.info,
                    selected: false,
                    onPressed: () {
                      Get.to(AbouScreen());
                    }),
                /*IconBottomBar(
                    text: "Calendar",
                    icon: Icons.date_range_outlined,
                    selected: false,
                    onPressed: () {})*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
        required this.text,
        required this.icon,
        required this.selected,
        required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon:
          Icon(icon, size: 25, color: selected ? accentColor : Colors.grey),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: .1,
              color: selected ? accentColor : Colors.grey),
        )
      ],
    );
  }
}
