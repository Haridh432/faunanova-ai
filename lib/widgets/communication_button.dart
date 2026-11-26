import 'package:flutter/material.dart';

class CommunicationButton extends StatefulWidget {
  final bool isRecording;
  final bool isPlaying;
  final VoidCallback onTap;
  final String label;

  const CommunicationButton({
    super.key,
    required this.isRecording,
    required this.isPlaying,
    required this.onTap,
    this.label = 'Tap and speak in Tamil',
  });

  @override
  State<CommunicationButton> createState() => _CommunicationButtonState();
}

class _CommunicationButtonState extends State<CommunicationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = widget.isRecording || widget.isPlaying;
    final color = widget.isRecording
        ? Colors.redAccent
        : (widget.isPlaying ? Colors.teal : theme.colorScheme.primary);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              final scale = active ? 1.0 + (_animController.value * 0.1) : 1.0;
              final glowSpread = active ? 14.0 * _animController.value : 4.0;

              return Transform.scale(
                scale: scale,
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withValues(alpha: 0.85),
                        color,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.45),
                        blurRadius: glowSpread + 8,
                        spreadRadius: glowSpread,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      widget.isPlaying
                          ? Icons.volume_up_rounded
                          : (widget.isRecording ? Icons.mic : Icons.mic_none),
                      color: Colors.white,
                      size: 38,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Text(
          widget.isRecording
              ? 'Listening to speech...'
              : (widget.isPlaying ? '🔊 Playing animal signal' : widget.label),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: active ? color : null,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          widget.isRecording ? 'தமிழில் பேசவும்' : 'பேச தட்டவும்',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }
}
