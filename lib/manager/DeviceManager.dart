import 'package:flutter/widgets.dart';
/// 设备信息管理
class DeviceManager {
  static final DeviceManager _instance = DeviceManager();
  static DeviceManager getInstance() {
    return _instance;
  }

  late double screenWidth;
  late double screenHeight;
  late double statusBarHeight;

  init(BuildContext context){
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    statusBarHeight = MediaQuery.of(context).padding.top;
  }

  double getScreenWidth(){
    return screenWidth;
  }


}