
import 'UserBean.dart';

class CommentBean{
  late UserBean user;
  late String content;
  List<String>? images;

  CommentBean.fromJson(Map<String, dynamic> json){
    user = UserBean.fromJson(json['user']);
    content = json['content'];
    var emptyImages = json['images'];
    if (emptyImages != null)
        images = emptyImages.cast<String>();
  }
}