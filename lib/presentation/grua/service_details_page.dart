import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/presentation/core/helpers/format_helper.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:get_it/get_it.dart';

import 'map.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ATV"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              GetIt.I.get<AuthState>().logout();
            },
            icon: Icon(
              Icons.logout_rounded,
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Info.horizontalUnit * 5,
        ),
        child: FutureBuilder<GruaServiceState>(
            future: GetIt.I.getAsync<GruaServiceState>(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: ResponsiveText("Buscando servicio"),
                );
              }
              final _state = snapshot.data;
              if (_state == null || _state.error != null) {
                return Center(
                  child: ResponsiveText(
                    _state?.error?.message ??
                        "Ocurrio un error, por favor vuelva a intentarlo",
                  ),
                );
              }
              return StreamBuilder<List<Service>>(
                  stream: _state.servicesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: ResponsiveText("No se encontró ningun servicio"),
                      );
                    }
                    final _service = snapshot.data!.first;
                    _state.servicesSelected = _service;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Info.horizontalUnit * 2,
                          ),
                          ResponsiveText(
                            "Servicio disponible",
                            fontSize: 35,
                          ),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          _ServiceDetail(
                            service: _service,
                          ),
                        ],
                      ),
                    );
                  });
            }),
      ),
    );
  }
}

class _ServiceDetail extends StatelessWidget {
  const _ServiceDetail({
    Key? key,
    required this.service,
  }) : super(key: key);

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
        child: Container(
          height: Info.verticalUnit * 45,
          child: Center(
            child: ServiceMap(
              service: service,
            ),
          ),
        ),
      ),
      SizedBox(
        height: Info.verticalUnit * 4,
      ),
      InfoLine(
        title: "Tipo de Servicio",
        value: tr("grua.enums." + service.type.toString()),
      ),
      SizedBox(
        height: Info.verticalUnit * 2,
      ),
      InfoLine(
        title: "Nombre conductor",
        value: service.clientName.isEmpty ? "Desconocido" : service.clientName,
      ),
      SizedBox(
        height: Info.verticalUnit * 2,
      ),
      InfoLine(
        title: "Fecha Solicitud",
        value: FormatHelper.userDateFormat().format(service.requestTime),
      ),
      SizedBox(
        height: Info.verticalUnit * 2,
      ),
      InfoLine(
        title: "Carro",
        value: service.carModel,
      ),
      SizedBox(
        height: Info.verticalUnit * 5,
      ),
      ElevatedButton(
        onPressed: () async {
          final _success =
              await GetIt.I.get<GruaServiceState>().updateServiceStatus(
                    ServiceStatus.accepted,
                  );
          if (_success) {
            AutoRouter.of(context).push(ServiceAcceptedPageRoute(
              service: service,
            ));
          }
        },
        child: ResponsiveText(
          "Aceptar Servicio",
          textType: TextType.Headline5,
        ),
      ),
    ]);
  }
}

class InfoLine extends StatelessWidget {
  const InfoLine({Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ResponsiveText(
          title,
          fontSize: 20,
        ),
        ResponsiveText(
          value,
          fontSize: 20,
        ),
      ],
    );
  }
}
