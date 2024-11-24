import 'package:flutter/material.dart';


class GlossyProgressBar extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final double height;
  final bool showPercentage;
  final Color progressColor;
  final Color backgroundColor;

  const GlossyProgressBar({
    Key? key,
    required this.progress,
    this.height = 10,
    this.showPercentage = true,
    this.progressColor = const Color(0xFF64B5F6),
    this.backgroundColor = const Color(0xFFE0E0E0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 7,),
        Container(
          // height: 18,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Stack(
              children: [
                // Progress bar background with subtle gradient
                Container(
                  width: double.infinity,
                  // height: 18,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.black.withOpacity(0.05),
                      ],
                    ),
                  ),
                ),

                // Actual progress bar
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    // height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          progressColor,
                          progressColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: progressColor.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text("",style: TextStyle(height: 1,fontSize: 10),),
                    ),
                ),
                ),
                /// agar jika data 0% tampilan tidak ngebug
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Text("${(progress * 100).toInt()} %",style: TextStyle(fontSize: 10,height: 1,color: progress < 0 ? Colors.blue : Colors.white,backgroundColor: Colors.transparent,)


                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}

class AnimatedGlossyProgressBar extends StatefulWidget {
  final double progress;
  // final double height;
  final bool showPercentage;
  final Color progressColor;
  final Color backgroundColor;
  final Duration animationDuration;

  const AnimatedGlossyProgressBar({
    Key? key,
    required this.progress,
    // this.height = 12.0,
    this.showPercentage = true,
    this.progressColor = const Color(0xFF64B5F6),
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<AnimatedGlossyProgressBar> createState() => _AnimatedGlossyProgressBarState();
}

class _AnimatedGlossyProgressBarState extends State<AnimatedGlossyProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedGlossyProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return GlossyProgressBar(
          progress: _animation.value,
          // height: widget.height,
          showPercentage: widget.showPercentage,
          progressColor: widget.progressColor,
          backgroundColor: widget.backgroundColor,
        );
      },
    );
  }
}