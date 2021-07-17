import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:huobipro/constants/ColorConstants.dart';
import 'package:lottie/lottie.dart';

/// 下拉Header
class LogoHeader extends Header {
  /// Key
  final Key? key;

  final LinkHeaderNotifier linkNotifier = LinkHeaderNotifier();

  LogoHeader({
    this.key,
    bool enableHapticFeedback = false,
  }) : super(
          extent: 60.0,
          triggerDistance: 60.0,
          float: false,
          enableHapticFeedback: enableHapticFeedback,
          enableInfiniteRefresh: false,
          completeDuration: const Duration(seconds: 1),
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration? completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    // 不能为水平方向以及反向
    assert(axisDirection == AxisDirection.down,
        'Widget can only be vertical and cannot be reversed');
    linkNotifier.contentBuilder(
        context,
        refreshState,
        pulledExtent,
        refreshTriggerPullDistance,
        refreshIndicatorExtent,
        axisDirection,
        float,
        completeDuration,
        enableInfiniteRefresh,
        success,
        noMore);
    return LogoHeaderWidget(
      key: key,
      linkNotifier: linkNotifier,
    );
  }
}

/// Header组件
class LogoHeaderWidget extends StatefulWidget {
  final LinkHeaderNotifier linkNotifier;

  const LogoHeaderWidget({
    Key? key,
    required this.linkNotifier,
  }) : super(key: key);

  @override
  LogoHeaderWidgetState createState() {
    return LogoHeaderWidgetState();
  }
}

class LogoHeaderWidgetState extends State<LogoHeaderWidget> {
  RefreshMode get _refreshState => widget.linkNotifier.refreshState;

  double get _pulledExtent => widget.linkNotifier.pulledExtent;//下拉高度

  double get _indicatorExtent => widget.linkNotifier.refreshIndicatorExtent;//header高度

  bool get _noMore => widget.linkNotifier.noMore;

  double _logoMaxHeight = 40;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_noMore) return Container();
    if (_refreshState == RefreshMode.armed ||
        _refreshState == RefreshMode.refresh) {
    } else if (_refreshState == RefreshMode.done ||
        _refreshState == RefreshMode.inactive) {}
    return Center(
      child: Container(
          margin: EdgeInsets.only(top: 10.0, bottom: _pulledExtent*10/_indicatorExtent),
          // height: _pulledExtent < _indicatorExtent
          //     ? _indicatorExtent
          //     : _pulledExtent,
          child: Column(
            children: [
              Lottie.asset('assets/lottie/refresh_header.json',
                  // fit: BoxFit.fitHeight,
                  height: _getLogoHeight()),
              Container(
                height: _pulledExtent < _logoMaxHeight + (_pulledExtent*10/_indicatorExtent)? 0 : 10,
                child: Text("huobi.pe",
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kPrimaryColor, fontSize: 8)),
              )
            ],
          )),
    );
  }

  double _getLogoHeight(){
    double height = _pulledExtent < _logoMaxHeight
        ? _pulledExtent : _logoMaxHeight;
    return height - 20;
  }
}
