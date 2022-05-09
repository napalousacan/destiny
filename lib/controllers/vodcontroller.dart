import 'package:destiny/model/vod.dart';
import 'package:destiny/retrofit/remoteService.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class VodController extends GetxController {
  var isLoading = true.obs;
  var AllVods =<Voditem>[].obs;
  final logger=Logger();

  @override
  void onInit() {
    super.onInit();
  }

  void fetchAllVods(String url) async{
    try {
      isLoading(true);
      var allitems = await RemoteServices.fetchAllVod(url);
      if(allitems !=null){
        AllVods.value=allitems;
      }
    } finally {
      isLoading(false);
    }
  }
}