import 'package:destiny/controllers/appcontroller.dart';
import 'package:destiny/controllers/infocontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class AbouScreen extends StatelessWidget  {
   AbouScreen({Key? key}) : super(key: key);
  final InfoController c=Get.put(InfoController());
  final AppDetailsController appDetailsController=Get.put(AppDetailsController());

  @override
  Widget build(BuildContext context) {
    c.fetchInfo(appDetailsController.AppDetailsList[0].appDescription);
    return Scaffold(
      /*appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Image.asset('assets/images/logodestiny.png',
          width: 130,
        ),
        backgroundColor: Colors.white,
      ),*/
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Obx(() {
            if (c.isLoading.value)
              return Center(child: CircularProgressIndicator());
            else
              return HtmlWidget(c.info.appDescription);
          }),
        ),
      ),
    );
  }
}
