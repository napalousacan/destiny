import 'package:destiny/model/info.dart';
import 'package:destiny/retrofit/remoteService.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class InfoController extends GetxController {
  var isLoading = true.obs;
  var info=Info(appDescription: '');
  final logger=Logger();

  @override
  void onInit() {
    super.onInit();
  }

  void fetchInfo(String url) async{
    try {
      isLoading(true);
      var allitems = await RemoteServices.fetchDataInfo(url);
      if(allitems !=null){
        info=allitems;
      }
    } finally {
      isLoading(false);
    }
  }
}