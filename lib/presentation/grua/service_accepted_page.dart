import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:flutter_base/presentation/grua/save_photo_modal.dart';
import 'package:image_picker/image_picker.dart';

class ServiceAcceptedPage extends StatelessWidget {
  const ServiceAcceptedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Card(
            child: Container(
              height: Info.verticalUnit * 100,
              child: Center(
                child: ResponsiveText('Mapa'),
              ),
            ),
          ),
          Positioned(
            top: Info.safeAreaPadding.top,
            left: Info.horizontalUnit * 5,
            right: Info.horizontalUnit * 5,
            child: ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).pop();
              },
              child: ResponsiveText(
                "Finalizar Servicio",
                textType: TextType.Headline5,
              ),
            ),
          ),
          Positioned(
            bottom: Info.safeAreaPadding.bottom,
            left: Info.horizontalUnit * 5,
            right: Info.horizontalUnit * 5,
            child: ButtonBar(),
          )
        ]),
      ),
    );
  }
}

class ButtonBar extends StatelessWidget {
  ButtonBar({Key? key}) : super(key: key);

  final ImagePicker _picker = ImagePicker();
  Future<XFile?> _takePhoto() {
    return _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () async {
                final String? code = await AutoRouter.of(context)
                    .push<String?>(ScanQRPageRoute());
                if (code != null && code.isNotEmpty) {
                  print("code read = " + code);
                }
              },
              child: ResponsiveText(
                "Escanear QR",
                textType: TextType.Headline5,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                const _borderRadius = 8;
                final _photo = await _takePhoto();
                if (_photo == null) {
                  return;
                }
                showBottomSheet(
                    context: context,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                            Info.horizontalUnit * _borderRadius),
                        topLeft: Radius.circular(
                            Info.horizontalUnit * _borderRadius),
                      ),
                      side: BorderSide(
                        color: Colors.black54,
                      ),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: Info.horizontalUnit * _borderRadius),
                        child: SaveFotoModal(
                          photo: _photo,
                        ),
                      );
                    });
              },
              child: ResponsiveText(
                "Sacar Foto",
                textType: TextType.Headline5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
