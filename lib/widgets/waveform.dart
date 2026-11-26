import 'package:flutter/material.dart';

class WaveformWidget extends StatelessWidget {
  final List<double> waveformPoints;
  final bool isListening;
  final bool isAnalyzing;
  final Color? activeColor;
  final double height;

  const WaveformWidget({
    super.key,
    required this.waveformPoints,
    this.isListening = true,
    this.isAnalyzing = false,
    this.activeColor,
    this.height = 110,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = activeColor ?? (isAnalyzing ? Colors.amber : theme.colorScheme.primary);

    // Fallback default points if empty
    final points = waveformPoints.isNotEmpty
        ? waveformPoints
        : List.generate(28, (i) => 0.12);

    return SizedBox(
      height: height,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(points.length, (index) {
            final val = points[index].clamp(0.08, 1.0);
            final barHeight = (height * 0.85) * val;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOutQuad,
              margin: const EdgeInsets.symmetric(horizontal: 2.2),
              width: 4.5,
              height: isListening ? barHeight : 6.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    color.withValues(alpha: 0.65),
                    color,
                  ],
                ),
                boxShadow: isListening && val > 0.45
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
            );
          }),
        ),
      ),
    );
  }
}
