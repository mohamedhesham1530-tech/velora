import 'dart:async';

import 'package:flutter/material.dart';

import 'success_cart_banner.dart';

void showSuccessCartBanner({
  required BuildContext context,
  required String title,
  required String image,
  required VoidCallback onViewCart,
}) {
  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) {
      return _AnimatedBanner(
        title: title,
        image: image,
        onViewCart: () {
          entry.remove();
          onViewCart();
        },
      );
    },
  );

  overlay.insert(entry);

  Timer(const Duration(seconds: 2), () {
    if (entry.mounted) {
      entry.remove();
    }
  });
}

class _AnimatedBanner extends StatefulWidget {
  final String title;
  final String image;
  final VoidCallback onViewCart;

  const _AnimatedBanner({
    required this.title,
    required this.image,
    required this.onViewCart,
  });

  @override
  State<_AnimatedBanner> createState() => _AnimatedBannerState();
}

class _AnimatedBannerState extends State<_AnimatedBanner> {
  bool visible = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 30), () {
      if (mounted) {
        setState(() => visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 35,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        offset: visible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1 : 0,
          child: SuccessCartBanner(
            title: widget.title,
            image: widget.image,
            onViewCart: widget.onViewCart,
          ),
        ),
      ),
    );
  }
}
