import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum SnackBarType { success, failed, warning }

class CustomSnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Dismiss any existing snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.zero,
          child: CustomSnackBarContent(message: message, type: type),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.success);
  }

  static void showError(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.failed);
  }

  static void showWarning(BuildContext context, String message) {
    show(context: context, message: message, type: SnackBarType.warning);
  }
}

class CustomSnackBarContent extends StatefulWidget {
  final String message;
  final SnackBarType type;
  const CustomSnackBarContent({
    super.key,
    required this.message,
    required this.type,
  });

  @override
  State<CustomSnackBarContent> createState() => _CustomSnackBarContentState();
}

class _CustomSnackBarContentState extends State<CustomSnackBarContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationFade;
  late Animation<Offset> _animationSlide;
  late Animation<double> _animationScale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animationFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationSlide = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return Colors.green.shade800;
      case SnackBarType.failed:
        return Colors.red.shade800;
      case SnackBarType.warning:
        return Colors.orange.shade800;
    }
  }

  Color _getBorderColor() {
    switch (widget.type) {
      case SnackBarType.success:
        return Colors.green.shade500;
      case SnackBarType.failed:
        return Colors.red.shade500;
      case SnackBarType.warning:
        return Colors.orange.shade500;
    }
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackBarType.success:
        return Icons.check_circle_outline;
      case SnackBarType.failed:
        return Icons.error_outline;
      case SnackBarType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  String _getTitle() {
    switch (widget.type) {
      case SnackBarType.success:
        return 'Success';
      case SnackBarType.failed:
        return 'Error';
      case SnackBarType.warning:
        return 'Warning';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: ScaleTransition(
          scale: _animationScale,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.w),
            margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.w),
            decoration: BoxDecoration(
              color: _getBackgroundColor(),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: _getBorderColor().withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(color: _getBorderColor(), width: 1.5),
            ),
            child: Row(
              children: [
                _buildPulseIcon(),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.close, color: Colors.white70),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  iconSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPulseIcon() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.2),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Icon(_getIcon(), color: Colors.white, size: 28),
    );
  }
}
