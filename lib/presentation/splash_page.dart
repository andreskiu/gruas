import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _animationDuration = Duration(seconds: 2);
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    final Animation<double> _curve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_curve);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      _handleNavigation(context);
    });
  }

  Future<void> _handleNavigation(BuildContext context) async {
    final initAuth = GetIt.I.getAsync<AuthState>();
    final waitAnimation = Future.delayed(_animationDuration);
    final results = await Future.wait([
      initAuth,
      waitAnimation,
    ]);
    final AuthState _authState = results[0];
    AutoRouter.of(context).removeLast();
    if (!_authState.isLoggedIn()) {
      context.router.popAndPush(LoginPageRoute());
    } else {
      AutoRouter.of(context).push(HomePageRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    return Scaffold(
      body: Hero(
        tag: "iconLogo",
        child: Container(
          color: Theme.of(context).primaryColor,
          child: Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
        ),
      ),
    );
  }
}
