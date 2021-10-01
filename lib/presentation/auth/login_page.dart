import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/auth/login_page_state.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/domain/core/core_fields/email_field.dart';
import 'package:flutter_base/presentation/auth/fields/password_form_field.dart';
import 'package:flutter_base/presentation/core/fields/email_form_field.dart';
import 'package:flutter_base/presentation/core/helpers/utils.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_checkbox.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_circular_indicator.dart';
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
  late EmailField email;
  late PasswordField password;
  late bool rememberMe;
  late Future<String> futureUser;
  late LoginPageState _state;
  final emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _state = GetIt.I.get<LoginPageState>();
    futureUser = _state.getRememberedUser();
    futureUser.then((value) {
      emailController.text = value;
      rememberMe = value.isNotEmpty;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Hero(
                    tag: "iconLogo",
                    child: LoginAppBar(
                      child: Image.asset("assets/images/logo.png"),
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
                          onSaved: (mail) {
                            email = EmailField(mail);
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
                            FutureBuilder<bool>(
                              future:
                                  futureUser.then((value) => value.isNotEmpty),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return ResponsiveCircularIndicator();
                                }
                                return ResponsiveCheckbox(
                                  initialValue: snapshot.data ??
                                      _state.username.isNotEmpty,
                                  onChange: (isChecked) {
                                    rememberMe = isChecked;
                                  },
                                );
                              },
                            ),
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
                        Container(
                          width: Info.horizontalUnit * 80,
                          child: ElevatedButton(
                            onPressed: () => _submitForm(context),
                            child: ResponsiveText(
                              "Login",
                              textType: TextType.Headline5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final _success = await Provider.of<LoginPageState>(context, listen: false)
          .login(email, password, rememberMe);
      if (_success) {
        // Navigate
        // pop method does not remove the last page in navigator
        AutoRouter.of(context).removeLast();
        context.router.popAndPush(ServiceDetailsRoute());
      } else {
        final _error =
            Provider.of<LoginPageState>(context, listen: false).error;
        if (_error != null) {
          Utils.showSnackBar(context, msg: tr(_error.message));
        }
      }
    }
  }
}
