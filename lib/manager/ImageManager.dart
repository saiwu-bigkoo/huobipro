import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class ImageManager{
  static CachedNetworkImage load(String url, [double? w, double? h]){
    if (url == null) url = "";
    return CachedNetworkImage(
      width: w,
      height: h,
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset("assets/images/ic_defult.png", fit: BoxFit.contain),
      errorWidget: (context, url, error) => Image.asset("assets/images/ic_defult.png", fit: BoxFit.contain),
    );
  }
}