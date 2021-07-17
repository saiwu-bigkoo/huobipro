import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:huobipro/bean/CommentBean.dart';
import 'package:huobipro/bean/TrendBean.dart';
import 'package:huobipro/constants/ColorConstants.dart';
import 'package:huobipro/interface/KChartSettingsChangeCallBack.dart';
import 'package:huobipro/manager/DeviceManager.dart';
import 'package:huobipro/manager/ImageManager.dart';
import 'package:huobipro/utils/ImageUtil.dart';
import 'package:huobipro/widgets/KChartSettingsWidget.dart';
import 'package:huobipro/widgets/LogoHeader.dart';
import 'package:huobipro/widgets/kchart/flutter_k_chart.dart';
import 'package:nine_grid_view/nine_grid_view.dart';

class KChartPageWidget extends StatefulWidget {
  final String name;

  KChartPageWidget({Key? key, required this.name}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new KChartPageWidgetState();
  }
}

class KChartPageWidgetState extends State<KChartPageWidget>
    with TickerProviderStateMixin, KChartSettingsChangeCallBack{
  late EasyRefreshController _controller;
  late TabController _tabController;
  late TabController _tabTimeController;
  bool isSettingChecked = false;
  bool isTimeMoreChecked = false;
  late int zhutuSelectPos = 1;
  late int futuSelectPos = 1;

  late List<CommentBean> comments = [];
  late List<KLineEntity> datas = [];
  late List<DepthEntity> _bids, _asks;

  MainState _mainState = MainState.BOLL;
  bool _volHidden = false;
  bool _depthShow = false;
  SecondaryState _secondaryState = SecondaryState.KDJ;
  bool isLine = false;

  ChartStyle chartStyle = new ChartStyle();
  ChartColors chartColors = new ChartColors();

  GlobalKey _tapSettingsWidget = GlobalKey();
  OverlayEntry? settingsOverlay;
  int tabBottomPosition = 0;

  @override
  void initState() {
    super.initState();
    getData("assets/json/k1day.json");
    getComments("assets/json/comments.json");

    _controller = EasyRefreshController();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      setState(() {
      tabBottomPosition = _tabController.index;
      });
    });
    _tabTimeController = TabController(initialIndex: 3, vsync: this, length: 7);
    _tabTimeController.addListener(() {
      switch(_tabTimeController.index){
        case 0:
          _depthShow = false;
          getData("assets/json/k15m.json");
          break;
        case 1:
          _depthShow = false;
          getData("assets/json/k1hour.json");
          break;
        case 2:
          _depthShow = false;
          getData("assets/json/k4hour.json");
          break;
        case 3:
          _depthShow = false;
          getData("assets/json/k1day.json");
          break;
        case 4:
          _depthShow = false;
          getData("assets/json/k1week.json");
          break;
        case 5:
          _depthShow = false;
          getData("assets/json/k1mounth.json");
          break;
        case 6:
          //深度图
          _depthShow = true;
          getDepth();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColorKChartDark,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            color: kbgColorKChartDark,
            margin: EdgeInsets.only(
                top: DeviceManager.getInstance().statusBarHeight),
            child: _getTopBarWidget(),
          )),
      body: EasyRefresh(
          child: _getContent(),
          enableControlFinishRefresh: true,
          controller: _controller,
          bottomBouncing: true,
          header: LogoHeader(),
          onRefresh: () async {
            await Future.delayed(Duration(seconds: 2), () {
              _controller.finishRefresh();
            });
          }),
      bottomNavigationBar: Container(
        color: kbgColorKChartDark,
        padding: EdgeInsets.all(12),
        width: double.infinity,
        height: 65,
        child: Row(
          children: [
            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize:
                        MaterialStateProperty.all(Size(93, double.infinity)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(kTextColorIncreaseUp)),
                child: Text(
                  '买入',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Container(
              width: 10,
            ),
            TextButton(
                onPressed: () {},
                style: ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize:
                        MaterialStateProperty.all(Size(93, double.infinity)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(kTextColorIncreaseDown)),
                child: Text(
                  '卖出',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Container(
              width: 10,
            ),
            Expanded(
                child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage("kline_laver_button",
                            height: 27, fit: BoxFit.fitHeight),
                        Text(
                          "杠杆",
                          style:
                              TextStyle(color: kTextColorOrange, fontSize: 9),
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage("kline_icon_remind_night",
                            height: 27, fit: BoxFit.fitHeight),
                        Text(
                          "提醒",
                          style: TextStyle(
                              color: kTextColorKChartTitle, fontSize: 9),
                        )
                      ],
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage("kline_icon_collect_night",
                            height: 27, fit: BoxFit.fitHeight),
                        Text(
                          "自选",
                          style: TextStyle(
                              color: kTextColorKChartTitle, fontSize: 9),
                        )
                      ],
                    )),
              ],
            ))
          ],
        ),
      ),
    );
  }

  ///顶部
  Widget _getTopBarWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.ltr,
      children: <Widget>[
        IconButton(
            icon: ImageUtil.getAssetsImage("ic_toolbar_back_normal",
                width: 32, height: 20, fit: BoxFit.scaleDown),
            onPressed: _onBack),
        Container(
          height: 15,
          width: 0.5,
          color: kTextColorKChartTitle,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: ImageUtil.getAssetsImage("trade_drawer_open_kline_page",
              height: 28, fit: BoxFit.fitHeight),
        ),
        Expanded(
            child: Text(
          widget.name.replaceAll("_", "/"),
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: kTextColorKChartTitle),
          textAlign: TextAlign.left,
        )),
        IconButton(
            icon: ImageUtil.getAssetsImage("full_kline_btn",
                height: 28, fit: BoxFit.fitHeight),
            onPressed: () {}),
        IconButton(
            icon: ImageUtil.getAssetsImage("share_kline_btn",
                height: 28, fit: BoxFit.fitHeight),
            onPressed: () {}),
      ],
    );
  }

  _onBack() {
    Navigator.pop(context);
  }

  Widget _getContent() {
    return CustomScrollView(
      physics: ScrollPhysics(),
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: false,
          floating: false,
          delegate: _SliverAppBarDelegate(
            maxHeight: 580,
            minHeight: 580,
            child: Container(
              width: double.infinity,
              color: kbgColorKChartDark,
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("trend")
                        .doc(widget.name)
                        .snapshots(includeMetadataChanges: true),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) return Container();
                      return Container(
                        padding: EdgeInsets.fromLTRB(14, 5, 14, 5),
                        child: _getBaseInfoWidget(context, snapshot),
                      );
                    },
                  ),
                  Container(
                      key: _tapSettingsWidget,
                      width: double.infinity,
                      height: 30,
                      child: Stack(children: [
                        Align(
                          child: Container(
                            width: double.infinity,
                            height: 0.1,
                            color: kTextGrayBlueColor,
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                        Row(
                          children: [
                            Expanded(child: Stack(
                              children: [
                                TabBar(
                                  unselectedLabelColor: kTextGrayBlueColor,
                                  indicatorColor: kTextColorKChartTab,
                                  labelColor: kTextColorKChartTab,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  labelPadding: EdgeInsets.zero,
                                  labelStyle:
                                  TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                                  controller: _tabTimeController,
                                  tabs: <Widget>[
                                    Tab(
                                      text: "15分",
                                    ),
                                    Tab(text: "1时"),
                                    Tab(text: "4时"),
                                    Tab(text: "1天"),
                                    Tab(text: "1周"),
                                    Tab(text: "更多  "),
                                    Tab(text: "深度图"),
                                  ],
                                ),
                                Positioned(
                                  right: 45,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isTimeMoreChecked = !isTimeMoreChecked;
                                        });
                                      },
                                      child: Container(
                                        width: 40,
                                        padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                                        child: ImageUtil.getAssetsImage(
                                            "market_info_index_collpsed",
                                            height: 5,
                                            fit: BoxFit.fitHeight,
                                            color: Colors.white,
                                            colorBlendMode: isTimeMoreChecked
                                                ? BlendMode.srcIn
                                                : BlendMode.dst),
                                      ),
                                    )
                                )
                              ],
                            )),
                            Container(
                              height: 10,
                              width: 0.1,
                              color: kTextGrayBlueColor,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSettingChecked = !isSettingChecked;
                                  _showOverlay(isSettingChecked);
                                });
                              },
                              child: Container(
                                width: 50,
                                child: ImageUtil.getAssetsImage(
                                    "kline_index_setting_icon",
                                    height: 20,
                                    fit: BoxFit.fitHeight,
                                    color: kPrimaryColor,
                                    colorBlendMode: isSettingChecked
                                        ? BlendMode.srcIn
                                        : BlendMode.dst),
                              ),
                            )
                          ],
                        )
                      ])),
                  Expanded(child: _depthShow?DepthChart(_bids, _asks, this.chartColors):_getKChartWidget()),
                  Container(
                    width: double.infinity,
                    color: kbgColorKChart,
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          floating: false,
          delegate: _SliverAppBarDelegate(
            maxHeight: 45,
            minHeight: 45,
            child: Container(
                color: kbgColorKChartDark,
                child: Stack(
                  children: [
                    Align(
                      child: Container(
                        width: double.infinity,
                        height: 0.1,
                        color: kTextGrayBlueColor,
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    TabBar(
                      unselectedLabelColor: kTextGrayBlueColor,
                      indicatorColor: kTextColorKChartTab,
                      labelColor: kTextColorKChartTab,
                      labelStyle:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      controller: _tabController,
                      tabs: <Widget>[
                        Tab(
                          text: "社区",
                        ),
                        Tab(text: "委托挂单"),
                        Tab(text: "成交"),
                        Tab(text: "简介"),
                      ],
                    ),
                  ],
                )),
          ),
        ),
        _getBottomWidaget()
        // SliverFillRemaining(
        //   child: TabBarView(
        //     controller: _tabController,
        //     children: <Widget>[
        //       _getCommentList(),
        //       Container(
        //         color: kbgColorKChartDark,
        //         height: 200,
        //       ),
        //       Container(
        //         color: kbgColorKChartDark,
        //         height: 200,
        //       ),
        //       Container(
        //         color: kbgColorKChartDark,
        //         height: 200,
        //       ),
        //     ],
        //   ),
        // )
      ],
    );
  }

  Widget _getBaseInfoWidget(
      BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    TrendBean item =
        TrendBean.fromMap(snapshot.data!.data() as Map<String, dynamic>);
    updateLast(item);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${item.close.toStringAsFixed(2)}",
                style: TextStyle(
                    fontSize: 27,
                    color: item.increase > 0
                        ? kTextColorIncreaseUp
                        : kTextColorIncreaseDown,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              Container(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "≈${item.rmb.toStringAsFixed(2)} CNY",
                    style: TextStyle(
                      fontSize: 11,
                      color: kTextGrayBlueColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "   ${item.increase > 0 ? '+' : ''}" +
                        "${item.increase.toStringAsFixed(2)}%",
                    style: TextStyle(
                      fontSize: 10,
                      color: item.increase > 0
                          ? kTextColorIncreaseUp
                          : kTextColorIncreaseDown,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          width: 75,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "高",
                    style: TextStyle(
                        fontSize: 11,
                        color: kTextGrayBlueColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      "${item.high}",
                      style: TextStyle(
                        fontSize: 10,
                        color: kTextColorKChartTitle,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              Container(
                height: 2,
              ),
              Row(
                children: [
                  Text(
                    "低",
                    style: TextStyle(
                        fontSize: 10,
                        color: kTextGrayBlueColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      "${item.low}",
                      style: TextStyle(
                        fontSize: 10,
                        color: kTextColorKChartTitle,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
              Container(
                height: 2,
              ),
              Row(
                children: [
                  Text(
                    "24H",
                    style: TextStyle(
                        fontSize: 10,
                        color: kTextGrayBlueColor,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                  Expanded(
                    child: Text(
                      "${item.count}",
                      style: TextStyle(
                        fontSize: 10,
                        color: kTextColorKChartTitle,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _getKChartWidget() {
    return KChartWidget(
      datas,
      chartStyle,
      chartColors,
      bgColor: [kbgColorKChartContentStart, kbgColorKChartContentEnd],
      isLine: isLine,
      mainState: _mainState,
      volHidden: _volHidden,
      secondaryState: _secondaryState,
      fixedLength: 2,
      timeFormat: TimeFormat.YEAR_MONTH_DAY,
      isChinese: true,
    );
  }

  Future<void> getData(String path) async {
    String result = await rootBundle.loadString(path);
    Map parseJson = json.decode(result);
    List list = parseJson['data'];
    datas = list
        .map((item) => KLineEntity.fromJson(item))
        .toList()
        .reversed
        .toList()
        .cast<KLineEntity>();
    DataUtil.calculate(datas);
    setState(() {});
  }

  void updateLast(TrendBean item){
    if (datas == null || datas.isEmpty) return;
    if (datas.last.close < item.close.toDouble())
        datas.last.close = item.close.toDouble();
    if (datas.last.high < item.high.toDouble())
      datas.last.high = item.high.toDouble();
    if (datas.last.low > item.low.toDouble())
      datas.last.low = item.low.toDouble();
    DataUtil.updateLastData(datas);
  }

  Widget _getSettingsPop(){
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              kbgColorKChart,
              kbgColorKChart,
            ]),
      ),
    );
  }

  //现实显示具体方法 在需要的地方掉用即可
  _showOverlay(bool isShow) {
    if (isShow) {
        settingsOverlay = _createSelectViewWithContext(
            context, _tapSettingsWidget);
        Overlay.of(context)!.insert(settingsOverlay!);

    } else {
          settingsOverlay?.remove();
    }
  }

  OverlayEntry _createSelectViewWithContext(BuildContext context, GlobalKey tapWidget){
    //屏幕宽高
    RenderBox  renderBox = context.findRenderObject() as RenderBox;
    var screenSize = renderBox.size;
    //触发事件的控件的位置和大小
    var tapWidgetRx = tapWidget.currentContext!.findRenderObject() as RenderBox;
    Size? parentSize = tapWidgetRx.size;
    var parentPosition = tapWidgetRx.localToGlobal(Offset.zero);
    //正式创建Overlay
    return OverlayEntry(
        builder: (context) => Positioned (
          top: parentPosition.dy+parentSize.height,
          width: screenSize.width,
          height:screenSize.height-parentPosition.dy-parentSize.height,
          child:Stack(
              children:<Widget>[
                GestureDetector(//黑色 26透明度背景
                  onTap:(){
                    setState( () {
                      isSettingChecked = false;
                      _showOverlay(isSettingChecked);
                    });
                  },
                  child: Container(
                    height: screenSize.height-parentPosition.dy-parentSize.height,
                    width:screenSize.width,
                    color:Colors.black54,
                  ),
                ),
                KChartSettingsWidget(zhutuSelectPos, futuSelectPos, this)
                ,//悬浮窗口自定义
              ]
          ),
        )
    );

  }
  @override
  void dispose() {
    settingsOverlay?.remove();
    super.dispose();
  }

  @override
  void onFuTuChange(int position) {
    futuSelectPos = position;
    switch(position){
      case 0:
        _secondaryState = SecondaryState.MACD;
        break;
      case 1:
        _secondaryState = SecondaryState.KDJ;
        break;
      case 2:
        _secondaryState = SecondaryState.RSI;
        break;
      case 3:
        _secondaryState = SecondaryState.WR;
        break;
      default:
        _secondaryState = SecondaryState.NONE;
        break;
    }
    setState( () {
      isSettingChecked = false;
      _showOverlay(isSettingChecked);
    });

  }

  @override
  void onZhuTuChange(int position) {
    zhutuSelectPos = position;
    switch(position){
      case 0:
        _mainState = MainState.MA;
        break;
      case 1:
        _mainState = MainState.BOLL;
        break;
      default:
        _mainState = MainState.NONE;
        break;
    }

    setState( () {
      isSettingChecked = false;
      _showOverlay(isSettingChecked);
    });
  }

  void getDepth() {
    rootBundle.loadString('assets/json/depth.json').then((result) {
      final parseJson = json.decode(result);
      Map tick = parseJson['tick'];
      var bids = tick['bids']
          .map((item) => DepthEntity(item[0], item[1]))
          .toList()
          .cast<DepthEntity>();
      var asks = tick['asks']
          .map((item) => DepthEntity(item[0], item[1]))
          .toList()
          .cast<DepthEntity>();
      initDepth(bids, asks);
    });
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    _bids = [];
    _asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _bids.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //累加卖出委托量
    asks.forEach((item) {
      amount += item.vol;
      item.vol = amount;
      _asks.add(item);
    });
    setState(() {});
  }

  Future<void> getComments(String path) async {
    String result = await rootBundle.loadString(path);
    Map parseJson = json.decode(result);
    List list = parseJson['data'];
    setState(() {
      comments = list
          .map((item) => CommentBean.fromJson(item))
          .toList()
          .cast<CommentBean>();
    });
  }



  SliverList _getCommentList() {
    return SliverList(delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        return Container(
          padding: EdgeInsets.fromLTRB(14, 20, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: ImageManager.load(
                        comments[index].user.avatarUrl, 48, 48),
                  ),
                  Container(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comments[index].user.name,
                        style: TextStyle(
                            color: kTextColorKChartTitle, fontSize: 12),
                      ),
                      Text(
                        "刚刚",
                        style:
                            TextStyle(color: kTextGrayBlueColor, fontSize: 8),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                height: 15,
              ),
              Text(
                comments[index].content,
                style: TextStyle(color: kTextColorKChartTitle, fontSize: 12),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              comments[index].images != null?
              NineGridView(
                margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                space: 10,
                type: NineGridType.weiBo,
                //NineGridType.weChat, NineGridType.weiBo
                itemCount: comments[index].images!.length,
                itemBuilder: (BuildContext context, int i) {
                  return ImageManager.load(comments[index].images![i]);
                },
              ):Container(),

              Container(margin: EdgeInsets.fromLTRB(0, 15, 0, 0), width: double.infinity, height: 0.1, color: kTextGrayBlueColor,)
            ],
          ),
        );
      },
        childCount: comments.length,
    ));
  }

  Widget _getBottomWidaget() {
    switch (tabBottomPosition) {
      case 0:
        return _getCommentList();
      default:
        return SliverFillRemaining(child: Container());
    }
  }


}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => this.minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
