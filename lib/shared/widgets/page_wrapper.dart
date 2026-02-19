import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;
  final double horizontalPadding;

  const PageWrapper({
    super.key,
    required this.child,
    this.horizontalPadding = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: child,
      ),
    );
  }
}
