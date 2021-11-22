import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/domain/grua/models/service.dart';

import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

import 'modals.dart';

class ServiceStatusConfirmationDialog extends StatelessWidget {
  final ServiceStatus serviceStatus;

  const ServiceStatusConfirmationDialog({
    Key? key,
    required this.serviceStatus,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed: () {
            AutoRouter.of(context).pop();
          },
          child: Center(
            child: Text(
              "Aceptar",
            ),
          ),
        ),
      ],
      title: ResponsiveText(
        serviceStatus == ServiceStatus.carPicked
            ? "Vehículo recogido"
            : "Servicio finalizado con éxito",
        fontWeight: FontWeight.bold,
      ),
      content: Text(
        serviceStatus == ServiceStatus.carPicked
            ? "Entendido, el vehículo ahora se encuentra en camino a su punto de destino"
            : "Ya puede cerrar esta ventana",
      ),
    );
  }
}

class ServiceStatusChangeDialog extends StatefulWidget {
  final void Function() onAceptedButtonPressed;
  final ServiceStatus serviceStatus;
  const ServiceStatusChangeDialog({
    Key? key,
    required this.onAceptedButtonPressed,
    required this.serviceStatus,
  }) : super(key: key);

  @override
  State<ServiceStatusChangeDialog> createState() =>
      _ServiceStatusChangeDialogState();
}

class _ServiceStatusChangeDialogState extends State<ServiceStatusChangeDialog> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        _isLoading
            ? CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        final _photo = await Modals.takeFoto(context);
                        if (_photo != null) {
                          await Modals.showSaveFotoModal(context, _photo);
                        }
                      },
                child: Center(
                  child: Text(
                    "Subir Foto",
                  ),
                ),
              ),
        _isLoading
            ? Container()
            : ElevatedButton(
                onPressed: widget.onAceptedButtonPressed,
                child: Center(
                  child: Text(
                    widget.serviceStatus == ServiceStatus.carPicked
                        ? "Vehiculo Recogido"
                        : "Finalizar Servicio",
                  ),
                ),
              ),
      ],
      title: ResponsiveText(
        widget.serviceStatus == ServiceStatus.carPicked
            ? "Vehiculo Recogido?"
            : "Servicio finalizado con éxito",
        fontWeight: FontWeight.bold,
      ),
      content: Text(
        widget.serviceStatus == ServiceStatus.carPicked
            ? "Si el vehiculo ya fue cargado en la grua o reparado, haga click en aceptar. No olvide subir la foto con el mismo"
            : "Ya puede cerrar esta ventana",
      ),
    );
  }
}
