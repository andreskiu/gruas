import 'package:flutter/material.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key key = const Key("logoutButton")}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthState>.value(
      value: GetIt.I.get<AuthState>(),
      builder: (context, child) {
        return Consumer<AuthState>(
          builder: (context, state, child) {
            return ElevatedButton(
                onPressed: () => state.logout(),
                child: ResponsiveText("LOGOUT!"));
          },
        );
      },
    );
  }
}
