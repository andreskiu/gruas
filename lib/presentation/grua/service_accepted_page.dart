import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:flutter_base/presentation/grua/save_photo_modal.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'map.dart';

class ServiceAcceptedPage extends StatelessWidget {
  const ServiceAcceptedPage({
    Key? key,
    required this.service,
  }) : super(key: key);
  final Service service;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GruaServiceState>.value(
      value: GetIt.I.get<GruaServiceState>(),
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(children: [
              Container(
                height: Info.verticalUnit * 100,
                child: Center(
                  child: ServiceMap(
                    service: service,
                  ),
                ),
              ),
              Positioned(
                top: Info.safeAreaPadding.top,
                left: Info.horizontalUnit * 5,
                right: Info.horizontalUnit * 5,
                child: Consumer<GruaServiceState>(
                    builder: (context, state, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      ServiceStatus _newStatus = ServiceStatus.carPicked;
                      if (service.status == ServiceStatus.carPicked) {
                        _newStatus = ServiceStatus.finished;
                      }
                      final _success = await state.updateServiceStatus(
                        _newStatus,
                      );
                      if (_success && _newStatus == ServiceStatus.finished) {
                        AutoRouter.of(context).pop();
                      }
                    },
                    child: ResponsiveText(
                      service.status == ServiceStatus.accepted
                          ? "Vehiculo recogido"
                          : "Finalizar Servicio",
                      textType: TextType.Headline5,
                    ),
                  );
                }),
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
      },
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
                        width: 0.5,
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
