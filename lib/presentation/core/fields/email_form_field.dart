import 'package:flutter/material.dart';
import 'package:flutter_base/domain/auth/fields/username_field.dart';
import '../responsivity/responsive_text.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({
    this.enabled = true,
    this.onChange,
    this.onSaved,
    this.textController,
    this.mandatory = false,
  });
  final bool enabled;
  final void Function(String)? onChange;
  final void Function(String?)? onSaved;
  final TextEditingController? textController;
  final bool mandatory;
  @override
  Widget build(BuildContext context) {
    return ResponsiveInput(
      controller: textController,
      enabled: enabled,
      hintText: 'Usuario',
      labelText: 'Usuario',
      validator: (String? input) {
        final _email = UsernameField(input, mandatory: mandatory);
        final _error = _email.getError();
        if (_error == null) {
          return null;
        }
        return _error.message;
      },
      onChanged: onChange,
      onSaved: onSaved,
    );
  }
}
