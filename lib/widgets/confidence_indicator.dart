import 'package:flutter/material.dart';

class ConfidenceIndicator extends StatelessWidget {
  final double confidence; // 0.0 to 1.0
  final bool compact;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
    this.compact = false,
  });

  Color _getConfidenceColor() {
    if (confidence >= 0.80) {
      return const Color(0xFF10B981); // Emerald / High
    } else if (confidence >= 0.60) {
      return const Color(0xFFF59E0B); // Amber / Medium
    } else {
      return const Color(0xFFEF4444); // Crimson / Low
    }
  }

  String _getConfidenceLabel() {
    if (confidence >= 0.80) {
      return 'High Confidence';
    } else if (confidence >= 0.60) {
      return 'Medium Confidence';
    } else {
      return 'Low Confidence';
    }
  }

  String _getConfidenceLabelTa() {
    if (confidence >= 0.80) {
      return 'உயர் நம்பிக்கை (High)';
    } else if (confidence >= 0.60) {
      return 'நடுத்தர நம்பிக்கை (Med)';
    } else {
      return 'குறைந்த நம்பிக்கை (Low)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getConfidenceColor();
    final percentage = (confidence * 100).toInt();

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '$percentage%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 4,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  _getConfidenceLabel(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: confidence.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          _getConfidenceLabelTa(),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
