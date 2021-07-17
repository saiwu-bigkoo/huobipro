class UserBean{
  late String name;
  late String avatarUrl;

  UserBean.fromJson(Map<String, dynamic> json){
    name = json['name'];
    avatarUrl = json['avatarUrl'];
  }

}