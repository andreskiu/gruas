import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/auth/login_page_state.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/domain/auth/fields/username_field.dart';
import 'package:flutter_base/presentation/auth/fields/password_form_field.dart';
import 'package:flutter_base/presentation/core/fields/email_form_field.dart';
import 'package:flutter_base/presentation/core/helpers/utils.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_checkbox.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:flutter_base/presentation/auth/widgets/login_app_bar.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  late UsernameField username;
  late PasswordField password;

  late Future<String> futureUsername;
  late LoginPageState _state;
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _state = GetIt.I.get<LoginPageState>();
    futureUsername = _state.getRememberedUser().then((username) {
      emailController.text = username;
      return username;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginPageState>.value(
      value: _state,
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                color: Theme.of(context).canvasColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "iconLogo",
                      child: LoginAppBar(
                        child: Image.asset(
                          "assets/images/green_movil.png",
                          width: Info.horizontalUnit * 60,
                          // height: Info.horizontalUnit * 40,
                        ),
                        size: Size(
                          Info.screenWidth,
                          Info.verticalUnit * 35,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Info.horizontalUnit * 5,
                      ),
                      child: Container(
                        height: Info.verticalUnit * 65,
                        child: Column(
                          children: [
                            SizedBox(
                              height: Info.verticalUnit * 5,
                            ),
                            ResponsiveText(
                              tr("auth.login.labels.welcome"),
                              textType: TextType.Headline2,
                              fontSize: 40,
                            ),
                            SizedBox(
                              height: Info.verticalUnit * 8,
                            ),
                            EmailFormField(
                              textController: emailController,
                              mandatory: true,
                              onSaved: (user) {
                                username = UsernameField(user);
                              },
                            ),
                            SizedBox(
                              height: Info.verticalUnit * 2,
                            ),
                            PasswordFormField(
                              validateSecurity: false,
                              onSaved: (psw) {
                                password = PasswordField(psw);
                              },
                            ),
                            SizedBox(
                              height: Info.verticalUnit * 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Consumer<LoginPageState>(
                                    builder: (context, state, child) {
                                  return ResponsiveCheckbox(
                                    value: _state.rememberMe,
                                    onChange: (isChecked) {
                                      setState(() {
                                        _state.rememberMe = isChecked ?? false;
                                      });
                                    },
                                  );
                                }),
                                ResponsiveText(
                                  tr(
                                    'auth.login.labels.remember_me',
                                  ),
                                  textType: TextType.Body1,
                                  fontSize: 20,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: Info.verticalUnit * 5,
                            ),
                            Consumer<LoginPageState>(
                              builder: (context, state, child) {
                                return state.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(
                                        width: Info.horizontalUnit * 80,
                                        child: ElevatedButton(
                                          onPressed: () => _submitForm(context),
                                          child: ResponsiveText(
                                            "Login",
                                            textType: TextType.Headline5,
                                          ),
                                        ),
                                      );
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // final _state = Provider.of<LoginPageState>(context, listen: false);
      _formKey.currentState!.save();
      final _success = await _state.login(
        username,
        password,
        _state.rememberMe,
      );
      if (_success) {
        // Navigate
        // dont know why, but navigation does not work without this delay
        Future.delayed(Duration(milliseconds: 10)).then((value) {
          AutoRouter.of(context).removeLast();
          context.router.push(ServiceDetailsRoute());
        });
      } else {
        if (_state.error != null) {
          Utils.showSnackBar(context, msg: tr(_state.error!.message));
        }
      }
    }
  }
}
