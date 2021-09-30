import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/auth/widgets/logout_button.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key = const Key("homePage"),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ResponsiveText("Hello!"),
      ),
      body: Column(
        children: [
          Center(
            child: ResponsiveText("Welcome!"),
          ),
          LogoutButton(),
        ],
      ),
    );
  }
}
