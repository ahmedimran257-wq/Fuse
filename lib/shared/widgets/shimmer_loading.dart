import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// A shimmer loading skeleton that mimics content layout.
/// Use instead of CircularProgressIndicator for premium loading states.
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoading({
    super.key,
    this.width = double.infinity,
    this.height = 200,
    this.borderRadius = 8,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: const [
                Color(0xFF1C1C1E),
                Color(0xFF2C2C2E),
                Color(0xFF1C1C1E),
              ],
              stops: const [0.1, 0.5, 0.9],
              begin: Alignment(-1.0 + 2.0 * _controller.value, 0),
              end: Alignment(1.0 + 2.0 * _controller.value, 0),
            ),
          ),
        );
      },
    );
  }
}

/// A full-screen shimmer skeleton for post loading
class PostShimmer extends StatelessWidget {
  const PostShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: const Column(
        children: [
          // Image area
          Expanded(child: ShimmerLoading(borderRadius: 0)),
          // Bottom info panel
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author row
                Row(
                  children: [
                    ShimmerLoading(width: 32, height: 32, borderRadius: 16),
                    SizedBox(width: 8),
                    ShimmerLoading(width: 100, height: 14, borderRadius: 4),
                  ],
                ),
                SizedBox(height: 12),
                // Caption
                ShimmerLoading(height: 14, borderRadius: 4),
                SizedBox(height: 8),
                ShimmerLoading(width: 200, height: 14, borderRadius: 4),
                SizedBox(height: 16),
                // Timer
                Center(
                  child: ShimmerLoading(
                    width: 160,
                    height: 24,
                    borderRadius: 4,
                  ),
                ),
                SizedBox(height: 8),
                ShimmerLoading(height: 4, borderRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
