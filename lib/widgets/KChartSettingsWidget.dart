import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:huobipro/constants/ColorConstants.dart';
import 'package:huobipro/interface/KChartSettingsChangeCallBack.dart';

class KChartSettingsWidget extends StatefulWidget {
  final KChartSettingsChangeCallBack callBack;
  final int zhutuSelectPos;
  final int futuSelectPos;

  KChartSettingsWidget(this.zhutuSelectPos, this.futuSelectPos, this.callBack, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new KChartSettingsWidgetState();
  }
}

class KChartSettingsWidgetState extends State<KChartSettingsWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  late int zhutuSelectPos;
  late int futuSelectPos;


  initState() {
    super.initState();
    zhutuSelectPos = widget.zhutuSelectPos;
    futuSelectPos = widget.futuSelectPos;
    // // Controller设置动画时长
    // // vsync设置一个TickerProvider，当前State 混合了SingleTickerProviderStateMixin就是一个TickerProvider
    // controller = AnimationController(
    //     duration: Duration(seconds: 1),
    //     vsync: this //
    // );
    // // 设置动画曲线，开始快慢，先加速后减速
    // animation=CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // // Tween设置动画的区间值，animate()方法传入一个Animation，AnimationController继承Animation
    // animation = new Tween(begin: 0.0, end: 200.0).animate(animation)
    // // addListener监听动画每一帧的回调，这个调用setState()刷新UI
    //   ..addListener(() {
    //     setState(()=>{});
    //   });
    // //启动动画(正向执行)
    // controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              kbgColorKChartContentStart,
              kbgColorKChart,
            ]),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "主图",
                  style: TextStyle(fontSize: 12, color: kTextColorKChartTitle, decoration: TextDecoration.none),
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                        child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (zhutuSelectPos == 0)
                              zhutuSelectPos = -1;
                            else
                              zhutuSelectPos = 0;
                            widget.callBack.onZhuTuChange(zhutuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(double.infinity, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: zhutuSelectPos == 0
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                zhutuSelectPos != 0
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'MA',
                          style: TextStyle(
                              color: zhutuSelectPos == 0
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1,
                      child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (zhutuSelectPos == 1)
                              zhutuSelectPos = -1;
                            else
                              zhutuSelectPos = 1;
                            widget.callBack.onZhuTuChange(zhutuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: zhutuSelectPos == 1
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                zhutuSelectPos != 1
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'BOLL',
                          style: TextStyle(
                              color: zhutuSelectPos == 1
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1, child: Container(),),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1, child: Container(),)
                  ],
                ),
                Container(
                  height: 30,
                ),
                Text(
                  "副图",
                  style: TextStyle(fontSize: 12, color: kTextColorKChartTitle, decoration: TextDecoration.none),
                ),
                Container(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1, child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (futuSelectPos == 0)
                              futuSelectPos = -1;
                            else
                              futuSelectPos = 0;
                            widget.callBack.onFuTuChange(futuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: futuSelectPos == 0
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                futuSelectPos != 0
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'MACD',
                          style: TextStyle(
                              color: futuSelectPos == 0
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1, child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (futuSelectPos == 1)
                              futuSelectPos = -1;
                            else
                              futuSelectPos = 1;
                            widget.callBack.onFuTuChange(futuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: futuSelectPos == 1
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                futuSelectPos != 1
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'KDJ',
                          style: TextStyle(
                              color: futuSelectPos == 1
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1, child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (futuSelectPos == 2)
                              futuSelectPos = -1;
                            else
                            futuSelectPos = 2;
                            widget.callBack.onFuTuChange(futuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: futuSelectPos == 2
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                futuSelectPos != 2
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'RSI',
                          style: TextStyle(
                              color: futuSelectPos == 2
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ))),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                      flex: 1, child:
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (futuSelectPos == 3)
                              futuSelectPos = -1;
                            else
                              futuSelectPos = 3;
                            widget.callBack.onFuTuChange(futuSelectPos);
                          });
                        },
                        style: ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            minimumSize:
                                MaterialStateProperty.all(Size(80, 30)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  side: futuSelectPos == 3
                                      ? BorderSide(color: kTextColorKChartTab)
                                      : BorderSide.none,
                                  borderRadius: BorderRadius.circular(4.0)),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                futuSelectPos != 3
                                    ? kbgColorKChartDark
                                    : Colors.transparent)),
                        child: Text(
                          'WR',
                          style: TextStyle(
                              color: futuSelectPos == 3
                                  ? kTextColorKChartTab
                                  : kTextColorKChartTitle,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
