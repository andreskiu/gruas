import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:image_picker/image_picker.dart';

class SaveFotoModal extends StatelessWidget {
  const SaveFotoModal({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final XFile photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Info.verticalUnit * 40,
      padding: EdgeInsets.symmetric(horizontal: Info.horizontalUnit * 10),
      child: Column(
        children: [
          ResponsiveText("Subir Foto"),
          SizedBox(
            height: Info.verticalUnit * 2,
          ),
          Container(
            height: Info.verticalUnit * 15,
            width: Info.verticalUnit * 15,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: FileImage(File(
                  photo.path,
                ),)
            
            )),
          ),
          SizedBox(
            height: Info.verticalUnit * 2,
          ),
          ResponsiveFormFieldButton(items: [
            DropdownMenuItem(
              value: 1,
              child: ResponsiveText("Atasco en tráfico"),
            ),
            DropdownMenuItem(
              value: 2,
              child: ResponsiveText("Vehículo Subido"),
            ),
            DropdownMenuItem(
              value: 3,
              child: ResponsiveText("Vehículo entregado"),
            ),
          ]),
          SizedBox(
            height: Info.verticalUnit * 2,
          ),
          ElevatedButton(
            onPressed: () {
              print("save me");
              AutoRouter.of(context).pop();
            },
            child: ResponsiveText("Subir foto"),
          ),
          SizedBox(
            height: Info.verticalUnit * 2,
          ),
        ],
      ),
    );
  }
}
