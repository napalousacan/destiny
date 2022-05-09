import 'package:destiny/controllers/appcontroller.dart';
import 'package:get/get.dart';
class NetworkBinding extends Bindings{
  // dependence injection attach our class.
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AppDetailsController>(() => AppDetailsController());
  }
}