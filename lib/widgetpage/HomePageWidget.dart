import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:huobipro/bean/TrendBean.dart';
import 'package:huobipro/constants/ColorConstants.dart';
import 'package:huobipro/manager/DeviceManager.dart';
import 'package:huobipro/utils/ImageUtil.dart';
import 'package:huobipro/widgets/LogoHeader.dart';
import 'package:huobipro/widgets/banner/banner_view.dart';
import 'package:lottie/lottie.dart';

import 'KChartPageWidget.dart';

class HomePageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomePageWidgetState();
  }
}

class HomePageWidgetState extends State
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true; //切换界面不重新绘制
  late EasyRefreshController _controller;
  var _bannerImages = [
    "https://huobi-1253283450.file.myqcloud.com/bit/banner/80e33e08-d7d3-49ad-b0af-1d113f8b5074.jpg",
    "https://huobi-1253283450.file.myqcloud.com/bit/banner/bb4dc165-5097-4076-8089-ad1db430ca1f.jpg"
  ];
  var _newsData = [
    "Huobi Gobal定于5月13日18:30开放03币币交易",
    "关于支持对TRX、BTT、JST持有者空投NFT的公告",
    "火币将于5月20日14:00暂停ERC20代币提现",
    "Huobi 创新区新增币种XCH"
  ];
  List<Map<String, String>> _tools = [
    {"icon": "index_tools_01", "title": "邀请奖励"},
    {"icon": "index_tools_02", "title": "充币"},
    {"icon": "index_tools_03", "title": "Huobi Earn"},
    {"icon": "index_tools_04", "title": "积分中心"},
    {"icon": "index_tools_05", "title": "联系客服"},
    {"icon": "index_tools_06", "title": "波卡生态板块"},
    {"icon": "index_tools_07", "title": "NFT板块"},
    {"icon": "index_tools_08", "title": "HECO专区"},
    {"icon": "index_tools_09", "title": "USDT合约"},
    {"icon": "index_tools_10", "title": "网络策略"},
  ];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = EasyRefreshController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            margin: EdgeInsets.only(
                top: DeviceManager.getInstance().statusBarHeight),
            child: _getTopBarWidget(),
          )),
      body: EasyRefresh(
          child: SingleChildScrollView(
            child: Column(
              children: _getPageContent(),
            ),
          ),
          enableControlFinishRefresh: true,
          controller: _controller,
          bottomBouncing: true,
          header: LogoHeader(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              _controller.finishRefresh();
            });
          }),
    );
  }

  ///顶部搜索
  Widget _getTopBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        IconButton(
            icon: ImageUtil.getAssetsImage("account_user_image",
                width: 28, height: 28),
            onPressed: _onOpenCustomerService),
        new Expanded(
            flex: 1,
            child: Container(
              height: 32,
              margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
//                border: new Border.all(color: Color(0x80FFFFFF), width: 0.5), // 边色与边宽度
                  color: kbgSearch, // 底色
                  borderRadius: BorderRadius.circular(24.0), //像素圆角
                ),
                child: Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: [
                        ImageUtil.getAssetsImage("search_icon",
                            width: 14, height: 14),
                        SizedBox(
                          width: 8,
                        ),
                        Text("搜索您关心的币种",
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: kTextColorSearch,
                                fontSize: 11,
                                fontWeight: FontWeight.w400))
                      ],
                    )),
              ),
            )),
        IconButton(
            icon: ImageUtil.getAssetsImage("information_icon",
                width: 28, height: 28),
            onPressed: _onOpenCustomerService())
      ],
    );
  }

  var _alignmentPopularX = -1.0;

  _onOpenCustomerService() {}

  bool _handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    print('滚动组件最大滚动距离:${metrics.maxScrollExtent}');
    print('当前滚动位置:${metrics.pixels}');
    setState(() {
      _alignmentPopularX = -1 + (metrics.pixels / metrics.maxScrollExtent) * 2;
    });
    return true;
  }

  List<Widget> _getPageContent() {
    return [
      CustomBanner(
        (BuildContext context, int index) {
          return Card(
              margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
              //z轴的高度，设置card的阴影
              elevation: 0,
              //设置shape，这里设置成了R角
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
              clipBehavior: Clip.antiAlias,
              semanticContainer: false,
              child: CachedNetworkImage(
                imageUrl: _bannerImages[index],
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Container(
                    decoration: new BoxDecoration(
                  color: Colors.grey,
                )),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/default_banner_image.png',
                  // 在项目中添加图片文件夹
                  fit: BoxFit.fitHeight,
                ),
              ));
        },
        _bannerImages.length,
        height: 132,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: Row(
          children: [
            ImageUtil.getAssetsImage("home_news_image", width: 15, height: 15),
            Expanded(
              child: CustomBanner(
                (BuildContext context, int index) {
                  return Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Text(
                        _newsData[index],
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ));
                },
                _newsData.length,
                scrollDirection: Axis.vertical,
                showIndicator: false,
                physics: NeverScrollableScrollPhysics(),
                height: 30,
              ),
            ),
            IconButton(
                onPressed: _onNewsMore,
                icon: ImageUtil.getAssetsImage("home_notice_more",
                    width: 22, height: 22))
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        color: kDividerColor,
        height: 1,
        width: double.infinity,
      ),
      NotificationListener(
          onNotification: _handleScrollNotification,
          child: Stack(
            children: [
              Container(
                height: 88,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("trend")
                      .orderBy("weight")
                      .limit(6)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Lottie.asset(
                        'assets/lottie/skeleton_home_a.json',
                        fit: BoxFit.fitHeight,
                      );

                    return _getPopularList(context, snapshot);
                  },
                ),
              ),
              //滚动条
              Container(
                height: 88,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                alignment: Alignment.bottomCenter,
                child: Card(
                  //z轴的高度，设置card的阴影
                  elevation: 0,
                  //设置shape，这里设置成了R角
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  ),
                  //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
                  clipBehavior: Clip.antiAlias,
                  semanticContainer: false,
                  child: Container(
                    alignment: Alignment(_alignmentPopularX, 1),
                    width: 35,
                    height: 2,
                    color: Color(0xffe5e5e8),
                    child: Container(
                        width: 20,
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black,
                        )),
                  ),
                ),
              ),
            ],
          )),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      //快捷买币
      Container(
        padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
        height: 60,
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: ImageUtil.getAssetsImage("otc_receivables_bank_card",
                      width: 20, height: 20),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: ImageUtil.getAssetsImage("otc_receivables_wechat",
                      width: 20, height: 20),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(26, 16, 0, 0),
                  child: ImageUtil.getAssetsImage("otc_receivables_zhifubao",
                      width: 20, height: 20),
                )
              ],
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "快捷买币",
                    style: TextStyle(
                        fontSize: 13,
                        color: kTextColor,
                        fontWeight: FontWeight.w700),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    height: 3,
                  ),
                  Text(
                    " 支持BTC、USDT、ETH等",
                    style: TextStyle(
                        fontSize: 9,
                        color: kTextColorSearch,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            )),
            ImageUtil.getAssetsImage("home_otc_enter",
                height: 40, fit: BoxFit.fitHeight)
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          children: [
            GridView(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              children: _getToolsWidgetList(),
            ),
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
                  child: ImageUtil.getAssetsImage("index_savings_cn_bg",
                      width: double.infinity, fit: BoxFit.fitWidth),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 5, 14, 0),
                  child: ImageUtil.getAssetsImage("index_saving_cn_img",
                      height: 50, fit: BoxFit.fitHeight),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(90, 14, 14, 0),
                  child: ImageUtil.getAssetsImage("index_savings_chinese",
                      height: 45, fit: BoxFit.fitHeight),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: ImageUtil.getAssetsImage("index_savings_cn_butten",
                        height: 30, fit: BoxFit.fitHeight),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      TabBar(
        unselectedLabelColor: kTextColorSearch,
        indicatorColor: kPrimaryColor,
        labelColor: kPrimaryColor,
        labelStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        controller: _tabController,
        tabs: const <Widget>[
          Tab(
            text: "涨幅榜",
          ),
          Tab(
            text: "成交额榜",
          ),
          Tab(
            text: "新币榜",
          ),
        ],
      ),
      SizedBox(
          width: double.infinity,
          height: 600,
          child: TabBarView(
            controller: _tabController,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("trend")
                    .orderBy("increase", descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                  return Column(children: _getIncreaseList(context, snapshot),);
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("trend")
                    .orderBy("amount", descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                  return Column(children: _getAmoutList(context, snapshot),);
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("trend")
                    .orderBy("pt", descending: true)
                    .limit(10)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container();
                  return Column(children: _getIncreaseList(context, snapshot),);
                },
              ),
            ],
          )),
    ];
  }

  List<Widget> _getIncreaseList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      TrendBean item =
      TrendBean.fromMap(document.data() as Map<String, dynamic>);
      List<String> names = item.ch.split("_");
      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            height: 50,
            child: Row(
              children: [
                Text(names[0], style: TextStyle(fontSize: 14, color: kTextColor, fontWeight: FontWeight.w700),),
                Text("/${names[1]}", style: TextStyle(fontSize: 8, color: kTextGrayColor, ),),
                Expanded(child: Text("${item.close}", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: kTextColor, fontWeight: FontWeight.w700),)),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                  height: 32,
                    width: 75,
                    decoration: new BoxDecoration(
                      color: item.increase > 0
                          ? kTextColorIncreaseUp
                          : kTextColorIncreaseDown,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  child: Text("${item.increase > 0 ? '+' : ''}"+ "${item.increase.toStringAsFixed(2)}%", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w700), maxLines: 1,),
                )
              ],
            ),
          ),
          Container(width: double.infinity, height: 0.5, color: kDividerColor,),
        ],
      );
    }).toList();

  }

  List<Widget> _getAmoutList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map((DocumentSnapshot document) {
      TrendBean item =
      TrendBean.fromMap(document.data() as Map<String, dynamic>);
      List<String> names = item.ch.split("_");
      var amountString = item.amount.toString();
      if (item.amount >= 100000000){
        amountString = "${(item.amount / 100000000).toStringAsFixed(2)}亿";
      }
      else if (item.amount >= 10000000){
        amountString = "${(item.amount / 10000000).toStringAsFixed(2)}千万";
      }
      else if (item.amount >= 1000000){
        amountString = "${(item.amount / 1000000).toStringAsFixed(2)}百万";
      }
      else if (item.amount >= 10000){
        amountString = "${(item.amount / 10000).toStringAsFixed(2)}万";
      }
      else{
        amountString = item.amount.toStringAsFixed(2);
      }



      return Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            height: 50,
            child: Row(
              children: [
                Text(names[0], style: TextStyle(fontSize: 14, color: kTextColor, fontWeight: FontWeight.w700),),
                Text("/${names[1]}", style: TextStyle(fontSize: 8, color: kTextGrayColor, ),),
                Expanded(child: Text("${item.close}", textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: kTextColor, fontWeight: FontWeight.w700),)),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(14, 0, 0, 0),
                  height: 32,
                    width: 75,
                    decoration: new BoxDecoration(
                      color:  kPrimaryLightColor,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  child: Text("$amountString", style: TextStyle(fontSize: 14, color: kPrimaryColor, fontWeight: FontWeight.w700), maxLines: 1, textAlign: TextAlign.center,),
                )
              ],
            ),
          ),
          Container(width: double.infinity, height: 0.5, color: kDividerColor,),
        ],
      );
    }).toList();

  }

  ListView _getPopularList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return new ListView(
      scrollDirection: Axis.horizontal,
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        TrendBean item =
            TrendBean.fromMap(document.data() as Map<String, dynamic>);

        return
        GestureDetector(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    KChartPageWidget(name: item.ch)));
          },
        child:
          Container(
          padding: EdgeInsets.fromLTRB(14, 10, 2, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    item.ch.replaceAll("_", "/"),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  Container(
                    width: 3,
                  ),
                  Text(
                    "${item.increase > 0 ? '+' : ''}"+ "${item.increase.toStringAsFixed(2)}%",
                    style: TextStyle(
                        fontSize: 10,
                        color: item.increase > 0
                            ? kTextColorIncreaseUp
                            : kTextColorIncreaseDown,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              Container(
                height: 6,
              ),
              Text(
                "${item.close.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 17,
                    color: item.increase > 0
                        ? kTextColorIncreaseUp
                        : kTextColorIncreaseDown,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                height: 4,
              ),
              Text(
                "¥${item.rmb.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 9,
                    color: kTextColorSearch,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ));
      }).toList(),
    );
  }

  ///跳公告页
  void _onNewsMore() {}

  List<Widget> _getToolsWidgetList() {
    List<Widget> list = [];
    _tools.forEach((item) {
      String title = item["title"] ?? "";
      String icon = item["icon"] ?? "";
      list.add(Column(
        children: [
          Container(
            height: 10,
          ),
          ImageUtil.getAssetsImage(icon, height: 30, fit: BoxFit.cover),
          Container(
            height: 5,
          ),
          Text(
            title,
            style: TextStyle(
                fontSize: 9, color: kTextColor, fontWeight: FontWeight.w500),
            textAlign: TextAlign.left,
          )
        ],
      ));
    });
    return list;
  }
}
