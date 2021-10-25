import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'responsive_calculations.dart';

enum TextType {
  Headline1,
  Headline2,
  Headline5,
  Headline6,
  Subtitle1,
  Body1,
  Caption,
  ElevatedButton,
  OutlinedButton,
  InputFieldHint,
  InputFieldError,
  InputFieldLabel,
}

double calculateFontSize(int fontSize) {
  final _factor = (fontSize + 1) / 10;
  final _resizedFontSize = _factor * Info.verticalUnit;
  return _resizedFontSize;
}

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextType textType;
  final TextAlign? textAlign;
  final Color? color;
  final FontWeight? fontWeight;
  final TextOverflow? overflow;
  final int? maxLines;
  final int fontSize;
  final TextStyle? textStyle;
  final MaterialState? materialState;

  ResponsiveText(
    this.text, {
    Key? key,
    this.textType = TextType.Body1,
    this.fontSize = 26,
    this.textAlign,
    this.color,
    this.fontWeight,
    this.overflow,
    this.maxLines,
    this.textStyle,
    this.materialState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: calculateTextStyle(
        context,
        textType: textType,
        materialState: materialState,
      )?.copyWith(
        fontSize: Info.responsiveFontSize(fontSize),
        color: color,
        fontWeight: fontWeight,
      ),
      overflow: overflow,
      maxLines: maxLines,
      textAlign: textAlign,
    );
  }
}

class ResponsiveInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextEditingController? controller;
  final bool obscureText;
  final bool isDense;
  final bool enabled;
  final TextInputType keyboardType;
  final AutovalidateMode? autoValidateMode;
  final List<TextInputFormatter>? inputFormatter;
  final int maxLength;
  final int fontSize;
  final void Function(String?)? onSaved;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;
  final IconData? suffixIconData;
  final IconData? prefixIconData;
  final Color? iconColor;
  final Color? prefixIconColor;
  final void Function()? onIconPressed;
  final void Function()? onTap;

  ResponsiveInput({
    Key? key,
    this.labelText,
    this.hintText,
    this.fontSize = 26,
    this.initialValue,
    this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.autoValidateMode,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength = 50,
    this.inputFormatter,
    this.onSaved,
    this.onChanged,
    this.isDense = true,
    this.suffixIconData,
    this.prefixIconData,
    this.iconColor,
    this.prefixIconColor,
    this.onIconPressed,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  @override
  _ResponsiveInputState createState() => _ResponsiveInputState();
}

class _ResponsiveInputState extends State<ResponsiveInput> {
  final _focus = FocusNode();
  final _iconFieldSize = 3;
  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    // for styling
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      autovalidateMode: widget.autoValidateMode,
      showCursor: true,
      readOnly: widget.readOnly,
      cursorColor: _theme.errorColor,
      inputFormatters: widget.inputFormatter,
      focusNode: _focus,
      onTap: widget.onTap,
      obscureText: widget.obscureText,
      style: calculateTextStyle(
        context,
        textType: TextType.Headline6,
      )?.copyWith(
        fontSize: Info.responsiveFontSize(widget.fontSize),
        color: _focus.hasFocus
            ? _theme.primaryColor
            : _theme.primaryTextTheme.bodyText1!.color,
      ),
      maxLength: widget.maxLength,
      decoration: InputDecoration(
        fillColor: _theme.inputDecorationTheme.fillColor,
        filled: true,
        isDense: widget.isDense,
        contentPadding: EdgeInsets.only(
          left: Info.horizontalUnit * 2,
          top: Info.horizontalUnit * 2,
          bottom: Info.verticalUnit,
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        hintStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldHint,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize),
        ),
        errorStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldError,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize - 8),
        ),
        counter: SizedBox.shrink(),
        labelStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldLabel,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize),
        ),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        prefixIconConstraints: BoxConstraints(
          minHeight: Info.verticalUnit * _iconFieldSize,
          maxHeight: Info.verticalUnit * _iconFieldSize * 2,
          minWidth: Info.verticalUnit * (_iconFieldSize + 1),
          maxWidth: Info.verticalUnit * (_iconFieldSize + 1),
        ),
        prefixIcon: widget.prefixIconData != null
            ? Icon(
                widget.prefixIconData,
                color: widget.prefixIconColor,
                size: Info.verticalUnit * _iconFieldSize,
              )
            : null,
        suffixIcon: widget.suffixIconData != null
            ? InkWell(
                onTap: () {
                  if (widget.onIconPressed != null) {
                    widget.onIconPressed!();
                  }
                },
                child: Icon(
                  widget.suffixIconData,
                  color: widget.iconColor ?? _theme.iconTheme.color,
                  size: Info.verticalUnit * _iconFieldSize,
                ),
              )
            : null,
      ),
      validator: widget.validator,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved,
    );
  }
}

class ResponsiveFormFieldButton<T> extends StatefulWidget {
  const ResponsiveFormFieldButton({
    Key? key,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.fontSize = 26,
    this.value,
    this.icon = Icons.arrow_drop_down,
    this.onIconTap,
    required this.items,
  }) : super(key: key);

  final Function(T?)? onSaved;
  final String Function(T?)? validator;
  final Function(T?)? onChanged;
  final String? labelText;
  final String? hintText;
  final List<DropdownMenuItem<T>> items;
  final int fontSize;
  final T? value;
  final IconData icon;
  final Function()? onIconTap;
  @override
  _ResponsiveFormFieldButtonState<T> createState() =>
      _ResponsiveFormFieldButtonState<T>();
}

class _ResponsiveFormFieldButtonState<T>
    extends State<ResponsiveFormFieldButton<T>> {
  final _iconFieldSize = 3;
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.hintText,
        isDense: true,
        contentPadding: EdgeInsets.only(
          left: Info.horizontalUnit / 2,
          bottom: Info.verticalUnit,
        ),
        hintStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldHint,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize),
        ),
        errorStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldError,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize - 4),
        ),
        labelStyle: calculateTextStyle(
          context,
          textType: TextType.InputFieldLabel,
        )?.copyWith(
          fontSize: Info.responsiveFontSize(widget.fontSize),
        ),
      ),
      icon: Padding(
        padding: EdgeInsets.only(right: Info.horizontalUnit / 4),
        child: InkWell(
          onTap: widget.onIconTap,
          child: Icon(
            widget.icon,
            size: Info.verticalUnit * _iconFieldSize,
          ),
        ),
      ),
      isDense: true,
      value: widget.value,
      items: widget.items,
      onChanged: (T? newValue) {
        setState(() {
          if (widget.onChanged != null) {
            widget.onChanged!(newValue);
          }
        });
      },
      validator: (T? newValue) {
        if (widget.validator != null) {
          return widget.validator!(newValue);
        }
        return null;
      },
      onSaved: (T? newValue) {
        setState(() {
          if (widget.onSaved != null) {
            widget.onSaved!(newValue);
          }
        });
      },
      isExpanded: true,
      elevation: 2,
      style: const TextStyle(color: Colors.black),
    );
  }
}

TextStyle? calculateTextStyle(
  BuildContext context, {
  TextType? textType,
  MaterialState? materialState,
}) {
  final _textTheme = Theme.of(context).primaryTextTheme;
  final _inputTheme = Theme.of(context).inputDecorationTheme;
  final _outlinedButtonTheme = Theme.of(context).outlinedButtonTheme;
  final _elevatedButtonTheme = Theme.of(context).elevatedButtonTheme;

  switch (textType) {
    case null:
      return null;

    case TextType.Subtitle1:
      return _textTheme.subtitle1;

    case TextType.Headline1:
      return _textTheme.headline1;

    case TextType.Headline2:
      return _textTheme.headline2;

    case TextType.Headline5:
      return _textTheme.headline5;

    case TextType.Headline6:
      return _textTheme.headline6;

    case TextType.Body1:
      return _textTheme.bodyText1;

    case TextType.Caption:
      return _textTheme.caption;

    case TextType.ElevatedButton:
      return _elevatedButtonTheme.style?.textStyle?.resolve({
            materialState ?? MaterialState.focused,
          }) ??
          null;

    case TextType.OutlinedButton:
      return _outlinedButtonTheme.style?.textStyle?.resolve({
        materialState ?? MaterialState.focused,
      });

    case TextType.InputFieldHint:
      return _inputTheme.hintStyle;

    case TextType.InputFieldError:
      return _inputTheme.errorStyle;

    case TextType.InputFieldLabel:
      return _inputTheme.labelStyle;
  }
}
