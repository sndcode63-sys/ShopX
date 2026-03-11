// 360° Product View

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/models/product_model.dart';
import '../../../theme/app_theme.dart';
import 'app_network_image.dart';

class Product360View extends StatefulWidget {
  final ProductModel product;
  const Product360View({super.key, required this.product});

  @override
  State<Product360View> createState() => _Product360ViewState();
}

class _Product360ViewState extends State<Product360View>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _currentAngle = 0.0;

  bool _isPlaying = true;

  bool _isDragging = false;

  static const double _fullCircle = 2 * 3.14159265358979;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..addListener(() {
      if (!_isDragging) {
        setState(() => _currentAngle = _controller.value * _fullCircle);
      }
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails _) {
    _isDragging = true;
    _controller.stop();
    setState(() => _isPlaying = false);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final delta = details.delta.dx / 200 * _fullCircle;
    setState(() => _currentAngle += delta);
  }

  void _onDragEnd(DragEndDetails details) {
    _isDragging = false;
  }

  void _toggleAutoRotate() {
    if (_isDragging) return;
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _controller.value = (_currentAngle % _fullCircle) / _fullCircle;
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleAutoRotate,
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: 340,
        color: AppTheme.bgCard,
        child: Stack(
          children: [
            Center(
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(_currentAngle),
                child:  AppNetworkImage(
                  url: widget.product.image,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                  radius: 0,
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: Transform.scale(
                  scaleX: (0.4 +
                      0.6 *
                          (1 -
                              (_currentAngle % 3.14159265 / 3.14159265 -
                                  0.5)
                                  .abs() *
                                  2)
                              .abs())
                      .clamp(0.2, 1.0),
                  child: Container(
                    width: 120,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 16,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 14,
              left: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.swipe_rounded,
                      color: AppTheme.textMuted, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    _isDragging ? 'Rotating...' : 'Drag to rotate',
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 14,
              right: 16,
              child: GestureDetector(
                onTap: _toggleAutoRotate,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.bgSurface.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isPlaying
                            ? Icons.rotate_right_rounded
                            : Icons.play_arrow_rounded,
                        color: AppTheme.primary,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isPlaying ? 'Auto' : 'Play',
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}