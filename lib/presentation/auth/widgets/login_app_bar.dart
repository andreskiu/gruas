import 'package:flutter/material.dart';

class LoginAppBar extends PreferredSize {
  final Widget child;
  final Size size;
  const LoginAppBar({
    required this.child,
    required this.size,
  }) : super(preferredSize: size, child: child);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: LoginClipPath(),
      child: Container(
        color: Theme.of(context).primaryColor,
        width: size.width,
        height: size.height,
        child: Center(child: child),
      ),
    );
  }
}

class LoginClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 4 / 5);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
