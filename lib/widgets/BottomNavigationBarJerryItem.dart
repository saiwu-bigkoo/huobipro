import 'package:flutter/material.dart';

class BottomNavigationBarJerryItem extends StatefulWidget {
// 动画的时间
  final Duration duration;

// 动画图标的大小
  final Size size;

// 选中时的图片
  final String imgAsset;

  const BottomNavigationBarJerryItem({
    this.duration = const Duration(milliseconds: 500),
    this.size = const Size(24.0, 24.0),
    required this.imgAsset,
  });

  @override
  _JellyButtonState createState() => _JellyButtonState();
}

class _JellyButtonState extends State<BottomNavigationBarJerryItem>
    with TickerProviderStateMixin {
// 动画控制器 点击触发播放动画
  late AnimationController _controller;

// 非线性动画 用来实现点击效果
  late CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
// 初始化 Controller
    _controller = AnimationController(vsync: this, duration: widget.duration);
// 线性动画 可以让按钮从小到大变化
    Animation<double> linearAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_controller);
// 将线性动画转化成非线性动画 让按钮点击效果更加灵动
    _animation =
        CurvedAnimation(parent: linearAnimation, curve: Curves.elasticOut);
// 一开始不播放动画 直接显示原始大小
    _controller.forward(from: 1.0);
    print("==========initState========");
  }

  @override
  void dispose() {
// 记得要释放Controller的资源
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedOverflowBox(
            size: widget.size,
            child: Image.asset(
              widget.imgAsset,
              width: _animation.value * widget.size.width,
              height: _animation.value * widget.size.height,
            ),
          );
        });
  }

  void _playAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant BottomNavigationBarJerryItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("==========didUpdateWidget========");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("==========didChangeDependencies========");
    _playAnimation();
  }
}
