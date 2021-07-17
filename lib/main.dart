import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huobipro/widgets/BottomNavigationBarJerryItem.dart';
import 'package:lottie/lottie.dart';

import 'bean/TrendBean.dart';
import 'constants/ColorConstants.dart';
import 'manager/DeviceManager.dart';
import 'utils/ImageUtil.dart';
import 'widgetpage/HomePageWidget.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
  statusBar(true);
}

/// 沉浸式状态栏 这里吧，感觉flutter支持得很不好，如果在其他页面切换状态栏颜色切换时有明显卡顿
statusBar(bool isLight) {
  // 白色沉浸式状态栏颜色  白色文字
  SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF000000),
    systemNavigationBarDividerColor: null,

    /// 注意安卓要想实现沉浸式的状态栏 需要底部设置透明色
    statusBarColor: Colors.transparent,
    systemNavigationBarIconBrightness:
    isLight ? Brightness.light : Brightness.dark,
    statusBarIconBrightness: isLight ? Brightness.light : Brightness.dark,
    statusBarBrightness: isLight ? Brightness.dark : Brightness.light,
  );
  SystemChrome.setSystemUIOverlayStyle(light);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ///这里是首次运行向数据库插假数据，数据库有值后关闭即可。
    testData();
    testDataUpdate();
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            title: '火币Pro',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primaryColor: kPrimaryColor,
            ),
            home: MyHomePage(),
          );
        }
      },
    );



  }
}
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbgColorKChartDark,
      body: Stack(
        alignment:Alignment.center,
        children: [
          Positioned(child: Center(
            child: Lottie.asset('assets/lottie/huobisplashscreen_1.json', height: 200, fit: BoxFit.fitHeight),
          ), top: 150,),
          Positioned(child: Center(
            child: Lottie.asset('assets/lottie/huobisplashscreen_2.json', height: 40, fit: BoxFit.fitHeight)
          ), bottom: 50,),
        ],
      ),
    );
  }
}
void testData() {
  /***
   * 字段名称	数据类型	描述
      id	long	NA
      amount	float	以基础币种计量的交易量（以滚动24小时计）
      count	integer	交易次数（以滚动24小时计）
      open	float	本阶段开盘价（以滚动24小时计）
      close	float	本阶段最新价（以滚动24小时计）
      low	float	本阶段最低价（以滚动24小时计）
      high	float	本阶段最高价（以滚动24小时计）
      vol	float	以报价币种计量的交易量（以滚动24小时计）
      bid	object	当前的最高买价 [price, size]
      ask	object	当前的最低卖价 [price, size]
      pt	发行时间
   */
  FirebaseFirestore.instance.collection("trend").doc("BTC_USDT").set(Map.from({
    "ch":"BTC_USDT",
    "amount":114354533381,
    "ask":[
      36969.06,
      921
    ],
    "bid":[
      36969.05,
      3
    ],
    "close":36958.27,
    "count":853112,
    "high":37494.98,
    "id":1622269861,
    "low":34750,
    "open":36845.3,
    "pt":1622269861363,
    "vol":41074516,
    "weight":1,
    "rmb": 2635.98,
    "increase": -22.65
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("ETH_USDT").set(Map.from({
    "ch":"ETH_USDT",
    "amount":2362323348,
    "ask":[
      23648.06,
      5.5
    ],
    "bid":[
      23648.05,
      3
    ],
    "close":23648.27,
    "count":6353112,
    "high":26648.98,
    "id":1622269862,
    "low":23648.01,
    "open":23648.3,
    "pt":1622269861363,
    "vol":41074516,
    "weight":2,
    "rmb": 3466.98,
    "increase": 75.21
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("HT_USDT").set(Map.from({
    "ch":"HT_USDT",
    "amount":231134349,
    "ask":[
      9.745,
      362.65
    ],
    "bid":[
      8.521,
      3
    ],
    "close":9.27,
    "count":323112,
    "high":12.98,
    "id":1622269863,
    "low":4.23,
    "open":4.23,
    "pt":1622269861363,
    "vol":41074516,
    "weight":3,
    "rmb": 434.57,
    "increase": -6.04
  })).onError((error, stackTrace) => print(error.toString()));

  FirebaseFirestore.instance.collection("trend").doc("DOT_USDT").set(Map.from({
    "ch":"DOT_USDT",
    "amount":857667,
    "ask":[
      87.74522,
      23.6
    ],
    "bid":[
      87.74522,
      3
    ],
    "close":103.88,
    "count":853112,
    "high":105.2,
    "id":1622269861,
    "low":87.22,
    "open":87.59,
    "pt":1622269861363,
    "vol":41074516,
    "weight":4,
    "rmb": 52.3,
    "increase": 10.32
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("USDT_HUSD").set(Map.from({
    "ch":"USDT_HUSD",
    "amount":287909096,
    "ask":[
      26.7452208,
      35.9
    ],
    "bid":[
      26.7452208,
      3
    ],
    "close":26.27,
    "count":853112,
    "high":35.98,
    "id":1622269861,
    "low":24.32,
    "open":27.98,
    "pt":1622269861363,
    "vol":41074516,
    "weight":4,
    "rmb": 854.66,
    "increase": -15.49
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("SHIB_USDT").set(Map.from({
    "ch":"SHIB_USDT",
    "amount":5389909084,
    "ask":[
      534.7452,
      0.286
    ],
    "bid":[
      534.74525,
      3
    ],
    "close":566.27,
    "count":853112,
    "high":832.98,
    "id":1622269861,
    "low":832.02,
    "open":505.3,
    "pt":1622269861363,
    "vol":41074516,
    "weight":4,
    "rmb": 0.55,
    "increase": 32.12
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("ECH_USDT").set(Map.from({
    "ch":"ECH_USDT",
    "amount":4980980966,
    "ask":[
      46.745,
      0.215
    ],
    "bid":[
      46.05,
      3
    ],
    "close":46.27,
    "count":853112,
    "high":46.98,
    "id":1622269861,
    "low":43.2,
    "open":44.3,
    "pt":1622269861363,
    "vol":41074516,
    "weight":4,
    "rmb": 4754.03,
    "increase": -7.3
  })).onError((error, stackTrace) => print(error.toString()));
  FirebaseFirestore.instance.collection("trend").doc("BTC_SHIB").set(Map.from({
    "ch":"BTC_SHIB",
    "amount":223555523128,
    "ask":[
      2226.06,
      2.56
    ],
    "bid":[
      36969.05,
      3
    ],
    "close":2025.27,
    "count":853112,
    "high":3215.98,
    "id":1622269861,
    "low":2003.2,
    "open":2159.3,
    "pt":1622269861363,
    "vol":41074516,
    "weight":4,
    "rmb": 23.03,
    "increase": 24.21
  })).onError((error, stackTrace) => print(error.toString()));

  for(var i = 0; i < 20; i ++){
    FirebaseFirestore.instance.collection("trend").doc("BI${i}_USDT").set(Map.from({
      "ch":"BTC${i}_USDT",
      "amount":22562628,
      "ask":[
        2226.06,
        921
      ],
      "bid":[
        36969.05,
        3
      ],
      "close":2025.27,
      "count":853112,
      "high":3215.98,
      "id":1622269861,
      "low":2003.2,
      "open":2159.3,
      "pt":1622269861363,
      "vol":41074516,
      "weight":5,
      "rmb": 44.0523,
      "increase": -0.02*i
    })).onError((error, stackTrace) => print(error.toString()));
  }
}

///定时更新一次数据，伪造数据后更新到firestore，然后通过实时回调数据显示
void testDataUpdate(){
  const period = const Duration(seconds: 5);
  print('currentTime='+DateTime.now().toString());
  Timer.periodic(period, (timer) {
    //到时回调
    print('afterTimer=' + DateTime.now().toString());
    CollectionReference trend = FirebaseFirestore.instance.collection('trend');
    trend.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        TrendBean item =
        TrendBean.fromMap(doc.data() as Map<String, dynamic>);
        int random = Random().nextInt(20);
        int randomIncrease = Random().nextInt(5);
        int randomRmb = Random().nextInt(50);
        var close = item.close;
        var increase = item.increase;
        var rmb = item.rmb;
        if (Random().nextBool()){
          close = close + random;
          increase = increase + randomIncrease;
          rmb = rmb + randomRmb;
        }
        else{
          close = close - random;
          increase = increase - randomIncrease;
          rmb = rmb - randomRmb;
        }
        trend.doc(doc.id).update({'close': close, "rmb": rmb, "increase": increase}).catchError((error) => print("Failed to update user: $error"));
      });
    });
  });
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //这里用了PageView+BottomNavigationBar，子页面AutomaticKeepAliveClientMixin方案实现切换页面不重绘
  var _pages = [
    HomePageWidget(),
    Container(),
    Container(),
    Container(),
    Container(),
  ];
  int _tabIndex = 0;

  var _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DeviceManager.getInstance().init(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        body: PageView.builder(
            physics: NeverScrollableScrollPhysics(),
            //禁止页面左右滑动切换
            controller: _pageController,
            onPageChanged: _pageChanged,
            //回调函数
            itemCount: _pages.length,
            itemBuilder: (context, index) => _pages[index]),
        bottomNavigationBar: Theme(
          data: ThemeData( //去掉水波纹
            highlightColor: Color.fromRGBO(0, 0, 0, 0),
            splashColor: Color.fromRGBO(0, 0, 0, 0),
          ),
          child: BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: ImageUtil.getAssetsImage("tabbar_home", width: 24, height: 24),
                activeIcon: BottomNavigationBarJerryItem(
                  imgAsset: 'assets/images/tabbar_home_light.png',
                ),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: ImageUtil.getAssetsImage("tabbar_markets",  width: 24, height: 24),
                activeIcon: BottomNavigationBarJerryItem(
                  imgAsset: 'assets/images/tabbar_markets_light.png',
                ),
                label: '行情',
              ),
              BottomNavigationBarItem(
                icon: ImageUtil.getAssetsImage("tabbar_trade", width: 24, height: 24),
                activeIcon: BottomNavigationBarJerryItem(
                  imgAsset: 'assets/images/tabbar_trade_light.png',
                ),
                label: '交易',
              ),
              BottomNavigationBarItem(
                icon: ImageUtil.getAssetsImage("tabbar_contract", width: 24, height: 24),
                activeIcon: BottomNavigationBarJerryItem(
                  imgAsset: 'assets/images/tabbar_contract_light.png',
                ),
                label: '合约',
              ),
              BottomNavigationBarItem(
                icon: ImageUtil.getAssetsImage("tabbar_banlance", width: 24, height: 24),
                activeIcon: BottomNavigationBarJerryItem(
                  imgAsset: 'assets/images/tabbar_banlance_light.png',
                ),
                label: '资产',
              )
            ],
            currentIndex: _tabIndex,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: kPrimaryColor,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            unselectedItemColor: kTextColor,
            onTap: (index) {
              _pageController.jumpToPage(index);
            },
          ),
        ));
  }

  void _pageChanged(int index) {
    setState(() {
      if (_tabIndex != index) _tabIndex = index;
    });
  }

}
