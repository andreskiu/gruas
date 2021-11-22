import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/domain/auth/fields/password_field.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    this.enabled = true,
    this.onChange,
    this.onSaved,
    this.textController,
    this.validateSecurity = true,
  });
  final bool enabled;
  final void Function(String)? onChange;
  final void Function(String?)? onSaved;
  final TextEditingController? textController;

  final bool validateSecurity;

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  var obscureText = true;
  @override
  Widget build(BuildContext context) {
    return ResponsiveInput(
      controller: widget.textController,
      enabled: widget.enabled,
      obscureText: obscureText,
      hintText: tr(
        'auth.fields.password.label',
      ),
      labelText: tr(
        'auth.fields.password.label',
      ),
      suffixIconData: obscureText ? Icons.visibility : Icons.visibility_off,
      onIconPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
      validator: (input) {
        final psw = PasswordField(
          input,
          validateSecurity: widget.validateSecurity,
        );
        final _error = psw.getError();
        if (_error == null) {
          return null;
        }
        return tr(_error.message);
      },
      onChanged: widget.onChange,
      onSaved: widget.onSaved,
    );
  }
}
