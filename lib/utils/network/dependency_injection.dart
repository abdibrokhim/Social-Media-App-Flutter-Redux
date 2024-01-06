import 'package:get/get.dart';

import 'package:socialmediaapp/utils/network/network_connection.dart';

class DependencyInjection {
  
  static void init() {
    Get.put<NetworkController>(NetworkController(),permanent:true);
  }
}