import 'package:flutter/widgets.dart';

class ImageUtil{
  static Widget getAssetsImage(String iconName, {double? width, double? height, BoxFit? fit, Color? color, BlendMode? colorBlendMode}) {
    return Image.asset(
      'assets/images/${iconName}.png', // 在项目中添加图片文件夹
      width: width,
      height: height,
      fit: fit,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }

}