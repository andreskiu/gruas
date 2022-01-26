import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/grua/dialogs.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'map.dart';
import 'modals.dart';

class ServiceAcceptedPage extends StatelessWidget {
  final GruaServiceState state = GetIt.I.get<GruaServiceState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GruaServiceState>.value(
      value: state,
      builder: (context, child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Stack(children: [
              Container(
                height: Info.verticalUnit * 100,
                child: Center(
                  child: Consumer<GruaServiceState>(
                      builder: (context, state, child) {
                    return ServiceMap(
                      service: state.servicesSelected!,
                      shouldUpdateUserPosition: false,
                      viewMode: ViewMode.drive,
                    );
                  }),
                ),
              ),
              Positioned(
                bottom: Info.safeAreaPadding.bottom,
                left: Info.horizontalUnit * 5,
                // right: Info.horizontalUnit * 5,
                child: ButtonBar(),
              )
            ]),
          ),
        );
      },
    );
  }
}

class ButtonBar extends StatefulWidget {
  ButtonBar({Key? key}) : super(key: key);

  @override
  State<ButtonBar> createState() => _ButtonBarState();
}

class _ButtonBarState extends State<ButtonBar> {
  bool _takePhotActive = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // TODO: CHEKQUEAR SI ESTO VA A IR.... NO ESTA IMPLEMENTADO.
        // ElevatedButton(
        //   onPressed: () async {
        //     final String? code =
        //         await AutoRouter.of(context).push<String?>(ScanQRPageRoute());
        //     if (code != null && code.isNotEmpty) {
        //       print("code read = " + code);
        //     }
        //   },
        //   child: ResponsiveText(
        //     "Escanear QR",
        //     textType: TextType.Headline5,
        //   ),
        // ),
        ElevatedButton(
          onPressed: _takePhotActive
              ? () async {
                  setState(() {
                    _takePhotActive = false;
                  });

                  final _photo = await Modals.takeFoto(context);

                  setState(() {
                    _takePhotActive = true;
                  });
                  if (_photo == null) {
                    return;
                  }
                  final _saved =
                      await Modals.showSaveFotoModal(context, _photo);
                }
              : null,
          child: ResponsiveText(
            "Tomar Foto",
            textType: TextType.Headline5,
          ),
        ),
        Consumer<GruaServiceState>(builder: (context, state, child) {
          String _text = "Vehiculo recogido";
          if (state.servicesSelected!.status == ServiceStatus.carPicked ||
              state.servicesSelected!.status == ServiceStatus.finished) {
            _text = "Finalizar Servicio";
          }
          return ElevatedButton(
            onPressed: () async {
              ServiceStatus _newStatus = ServiceStatus.carPicked;
              if (state.servicesSelected!.status == ServiceStatus.carPicked) {
                _newStatus = ServiceStatus.finished;
              }
              await showDialog<bool>(
                  context: context,
                  builder: (context) {
                    return ServiceStatusChangeDialog(
                      serviceStatus: _newStatus,
                      onAceptedButtonPressed: () async {
                        await state.updateServiceStatus(_newStatus);

                        AutoRouter.of(context).pop();
                      },
                    );
                  });

              if (state.serviceUpdatedSuccesfully) {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return ServiceStatusConfirmationDialog(
                        serviceStatus: _newStatus,
                      );
                    });
                if (_newStatus == ServiceStatus.finished) {
                  // go back to home if service is finished

                  // AutoRouter.of(context).replace(ServiceDetailsRoute());
                  AutoRouter.of(context).pop();
                }
              }
            },
            child: ResponsiveText(
              _text,
              textType: TextType.Headline5,
            ),
          );
        }),
        //   ],
        // ),
      ],
    );
  }
}
