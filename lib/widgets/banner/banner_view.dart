import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBanner extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final double height;
  final ValueChanged<int>? onTap;
  final Curve curve;
  final int itemCount;
  final bool showIndicator;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  CustomBanner(this.itemBuilder,
      this.itemCount,
      {
        this.height = 200,
        this.onTap,
        this.physics,
        this.showIndicator = true,
        this.scrollDirection = Axis.horizontal,
        this.curve = Curves.linear,
      });

  @override
  _CustomBannerState createState() => _CustomBannerState();
}

class _CustomBannerState extends State<CustomBanner> {
  late PageController _pageController;
  late int _curIndex;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _curIndex = widget.itemCount * 5;
    _pageController = PageController(initialPage: _curIndex);
    _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _buildPageView(),
        widget.showIndicator?_buildIndicator():Container(),
      ],
    );
  }

  Widget _buildIndicator() {
    return Positioned(
        bottom: 10,
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
          child: Row(
            children: _getSizeWidget(),
          ),
        ));
  }

  List<Widget> _getSizeWidget() {
    return List.generate(
        widget.itemCount,
            (index) =>
            Container(
              width: 15,
              height: 4,
              color: index == _curIndex % widget.itemCount
                  ? Colors.white
                  : Color(0x30000000),
            )

    );
  }

  Widget _buildPageView() {
    var length = widget.itemCount;
    return Container(
      height: widget.height,
      child: PageView.builder(
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _curIndex = index;
            if (index == 0) {
              _curIndex = length;
              _changePage();
            }
          });
        },
        itemBuilder: (context, index) {
          return GestureDetector(
              onPanDown: (details) {
                _cancelTimer();
              },
              onTap: () {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text('当前 page 为 ${index % length}'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              },
              child: widget.itemBuilder(context, index % length));
        },
      ),
    );
  }

  /// 点击到图片的时候取消定时任务
  _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
      _initTimer();
    }
  }

  /// 初始化定时任务
  _initTimer() {
    if (_timer == null) {
      _timer = Timer.periodic(Duration(seconds: 3), (t) {
        _curIndex++;
        _pageController.animateToPage(
          _curIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      });
    }
  }

  /// 切换页面，并刷新小圆点
  _changePage() {
    Timer(Duration(milliseconds: 350), () {
      _pageController.jumpToPage(_curIndex);
    });
  }
}
