import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String checkPattern = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <circle cx="50" cy="50" r="35" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <path d="M65 40 L45 60 L35 50" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
</svg>
''';

const String errorPattern = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <circle cx="50" cy="50" r="35" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <path d="M35 35 L65 65 M65 35 L35 65" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
</svg>
''';

const String loadingPattern = '''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <circle cx="50" cy="50" r="40" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <circle cx="50" cy="50" r="35" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <path d="M50 25 L50 45 M50 55 L50 75" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
  <path d="M25 50 L45 50 M55 50 L75 50" fill="none" stroke="white" stroke-width="2" opacity="0.1"/>
</svg>
''';

class CustomAlerts {
  static OverlayEntry? _loadingEntry;
  static OverlayEntry? _successEntry;
  static OverlayEntry? _errorEntry;

  static void showSuccess(BuildContext context, String title, String subtitle) {
    _successEntry?.remove();
    _successEntry = OverlayEntry(
      builder: (context) => _CustomAlertOverlay(
        title: title,
        subtitle: subtitle,
        color: Color(0xFF0277BD),
        pattern: checkPattern,
      ),
    );

    Overlay.of(context).insert(_successEntry!);

    Future.delayed(Duration(seconds: 3), () {
      dismissSuccess();
    });
  }

  static void showError(BuildContext context, String title, String subtitle) {
    _errorEntry?.remove();
    _errorEntry = OverlayEntry(
      builder: (context) => _CustomAlertOverlay(
        title: title,
        subtitle: subtitle,
        color: Color(0xFFD32F2F),
        pattern: errorPattern,
      ),
    );

    Overlay.of(context).insert(_errorEntry!);

    Future.delayed(Duration(seconds: 3), () {
      dismissError();
    });
  }

  static void showLoading(BuildContext context, String title, String subtitle) {
    _loadingEntry?.remove();
    _loadingEntry = OverlayEntry(
      builder: (context) => _CustomLoadingOverlay(
        title: title,
        subtitle: subtitle,
      ),
    );

    Overlay.of(context).insert(_loadingEntry!);
  }

  static void dismissSuccess() {
    _successEntry?.remove();
    _successEntry = null;
  }

  static void dismissError() {
    _errorEntry?.remove();
    _errorEntry = null;
  }

  static void dismissLoading() {
    _loadingEntry?.remove();
    _loadingEntry = null;
  }
}

class _CustomAlertOverlay extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final String pattern;

  const _CustomAlertOverlay({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.pattern,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -15,
                top: -25,
                child: ClipRRect(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: SvgPicture.string(
                      pattern,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomLoadingOverlay extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CustomLoadingOverlay({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Color(0xFF673AB7),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(24),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                right: -15,
                top: -25,
                child: ClipRRect(
                  child: SizedBox(
                    width: 90,
                    height: 90,
                    child: RotatingLoadingPattern(),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedLoadingText(text: title),
                  SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RotatingLoadingPattern extends StatefulWidget {
  @override
  _RotatingLoadingPatternState createState() => _RotatingLoadingPatternState();
}

class _RotatingLoadingPatternState extends State<RotatingLoadingPattern>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: SvgPicture.string(
        loadingPattern,
        fit: BoxFit.contain,
      ),
    );
  }
}

class AnimatedLoadingText extends StatefulWidget {
  final String text;

  const AnimatedLoadingText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  _AnimatedLoadingTextState createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..addListener(() {
        setState(() {
          if (_controller.value < 0.25) {
            _dotCount = 0;
          } else if (_controller.value < 0.5) {
            _dotCount = 1;
          } else if (_controller.value < 0.75) {
            _dotCount = 2;
          } else {
            _dotCount = 3;
          }
        });
      })..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 4),
        Container(
          width: 24,
          child: Text(
            '.' * _dotCount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}