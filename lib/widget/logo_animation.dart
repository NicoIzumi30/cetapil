import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// class EnhancedFadeInSvg extends StatefulWidget {
//   final String svgPath;
//   final double width;
//   final double height;
//   final Duration duration;
//   final Curve curve;
//   final bool scaleEffect;
//   final bool slideEffect;
//
//   const EnhancedFadeInSvg({
//     Key? key,
//     required this.svgPath,
//     this.width = 100,
//     this.height = 100,
//     this.duration = const Duration(milliseconds: 1000),
//     this.curve = Curves.easeInOut,
//     this.scaleEffect = true,
//     this.slideEffect = true,
//   }) : super(key: key);
//
//   @override
//   State<EnhancedFadeInSvg> createState() => _EnhancedFadeInSvgState();
// }
//
// class _EnhancedFadeInSvgState extends State<EnhancedFadeInSvg>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _opacityAnimation;
//   late Animation<double> _scaleAnimation;
//   late Animation<Offset> _slideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );
//
//     _opacityAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: widget.curve,
//     ));
//
//     _scaleAnimation = Tween<double>(
//       begin: 0.8,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: widget.curve,
//     ));
//
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 0.2),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: widget.curve,
//     ));
//
//     Future.delayed(const Duration(milliseconds: 100), () {
//       _controller.forward();
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child = SvgPicture.asset(
//       widget.svgPath,
//       width: widget.width,
//       height: widget.height,
//     );
//
//     if (widget.scaleEffect) {
//       child = ScaleTransition(
//         scale: _scaleAnimation,
//         child: child,
//       );
//     }
//
//     if (widget.slideEffect) {
//       child = SlideTransition(
//         position: _slideAnimation,
//         child: child,
//       );
//     }
//
//     return FadeTransition(
//       opacity: _opacityAnimation,
//       child: child,
//     );
//   }
// }



class EnhancedFadeInImage extends StatefulWidget {
  final String imagePath;
  final double width;
  final double height;
  final Duration duration;
  final Curve curve;
  final bool scaleEffect;
  final bool slideEffect;
  final BoxFit fit;

  const EnhancedFadeInImage({
    Key? key,
    required this.imagePath,
    this.width = 100,
    this.height = 100,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.scaleEffect = true,
    this.slideEffect = true,
    this.fit = BoxFit.contain,
  }) : super(key: key);

  @override
  State<EnhancedFadeInImage> createState() => _EnhancedFadeInImageState();
}

class _EnhancedFadeInImageState extends State<EnhancedFadeInImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Image.asset(
      widget.imagePath,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );

    if (widget.scaleEffect) {
      child = ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      );
    }

    if (widget.slideEffect) {
      child = SlideTransition(
        position: _slideAnimation,
        child: child,
      );
    }

    return FadeTransition(
      opacity: _opacityAnimation,
      child: child,
    );
  }
}



