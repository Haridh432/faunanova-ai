import 'package:flutter/material.dart';

class LiveStatusBadge extends StatelessWidget {
  final bool isListening;
  final bool isCameraActive;
  final String modeText;

  const LiveStatusBadge({
    super.key,
    required this.isListening,
    this.isCameraActive = true,
    this.modeText = 'AI Active',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening ? const Color(0xFF10B981) : Colors.grey,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isListening ? '● LIVE AUDIO' : 'IDLE',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          const Text('•', style: TextStyle(color: Colors.grey)),
          const SizedBox(width: 8),
          Text(
            modeText,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
