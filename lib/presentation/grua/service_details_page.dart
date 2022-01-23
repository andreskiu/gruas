import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/auth/auth_state.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/domain/grua/models/service.dart';
import 'package:flutter_base/presentation/core/helpers/format_helper.dart';
import 'package:flutter_base/presentation/core/helpers/utils.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'map.dart';

class ServiceDetails extends StatefulWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  // final _state = GetIt.I.get<GruaServiceState>();
  // @override
  // void initState() {
  //   super.initState();
  // }

// MEJORAR LA NAVEGACION! SE ACTUALIZA EL MAPA CUANDO SE ACTUALIZA EL ESTADO
  // _navigateToService() {
  //   final _loggedUser = GetIt.I.get<AuthState>().loggedUser;
  //   final _service = _state.servicesSelected;
  //   if (_service == null) {
  //   } else {
  //     if (_service.username == _loggedUser.username &&
  //         _service.status != ServiceStatus.pending &&
  //         _service.status != ServiceStatus.finished) {
  //       WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
  //         print("Navegando a la pagina con el mapa grande");
  //         AutoRouter.of(context).current.name
  //         AutoRouter.of(context).popAndPush(ServiceAcceptedPageRoute(
  //           service: _service,
  //         ));
  //       });
  //     }
  //   }
  // }

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
              if (_state == null) {
                return Center(
                  child: ResponsiveText(
                    _state?.error?.message ??
                        "Ocurrio un error, por favor vuelva a intentarlo",
                  ),
                );
              }
              if (_state.servicesStream == null) {
                return Center(
                  child: _state.loading
                      ? CircularProgressIndicator.adaptive()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ResponsiveText(
                              _state.error?.message ??
                                  "Ocurrio un error, por favor vuelva a intentarlo",
                            ),
                            SizedBox(
                              height: Info.verticalUnit * 2,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setState(() {});
                                await _state.getServices();
                                setState(() {});
                              },
                              child: ResponsiveText('Reintentar'),
                            ),
                          ],
                        ),
                );
              }
              return StreamBuilder<List<Service>>(
                  stream: _state.servicesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: ResponsiveText("No hay servicios disponibles."),
                      );
                    }
                    final _service = snapshot.data!.first;
                    _state.servicesSelected = _service;
                    // TODO: uncomment to auto-navigate.
                    // final _loggedUser = GetIt.I.get<AuthState>().loggedUser;
                    // if (_service.username == _loggedUser.username &&
                    //     _service.status != ServiceStatus.pending &&
                    //     _service.status != ServiceStatus.finished) {
                    //   WidgetsBinding.instance!
                    //       .addPostFrameCallback((timeStamp) {
                    //     print("evaluando navegacion");
                    //     if (AutoRouter.of(context).current.name !=
                    //         ServiceAcceptedPageRoute.name) {
                    //       print("NAVEGANDO A LA PAGINA DE SERVICIO ACEPTADO");
                    //       AutoRouter.of(context).popAndPush(
                    //         ServiceAcceptedPageRoute(
                    //           service: _service,
                    //         ),
                    //       );
                    //     }
                    //   });
                    // }
                    return Column(
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
                        Card(
                          child: Container(
                            height: Info.verticalUnit * 45,
                            child: Center(
                              child: ServiceMap(
                                service: _service,
                                shouldUpdateUserPosition: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Info.verticalUnit * 4,
                        ),
                        _ServiceDetail(
                          service: _service,
                        ),
                      ],
                    );
                  });
            }),
      ),
    );
  }
}

class _ServiceDetail extends StatelessWidget {
  _ServiceDetail({
    Key? key,
    required this.service,
  }) : super(key: key);

  final Service service;

  Future<void> _acceptService(BuildContext context) async {
    final _state = GetIt.I.get<GruaServiceState>();
    final _success = await _state.updateServiceStatus(
      ServiceStatus.accepted,
    );
    if (_success) {
      _viewCurrentService(context);
    } else {
      Utils.showSnackBar(
        context,
        msg: _state.error?.message ??
            'Ocurrio un error. Por favor vuelva a intentarlo',
      );
    }
  }

  Future<void> _viewCurrentService(BuildContext context) async {
    // AutoRouter.of(context).replace(ServiceAcceptedPageRoute(
    // service: service,
    // )); //popForced();
    AutoRouter.of(context).push(ServiceAcceptedPageRoute(
      service: service,
    ));
    // print("==================================poniendo en stream =========");
    // GetIt.I.get<GruaServiceState>().updateRoutesStream.sink.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: GetIt.I.get<GruaServiceState>(),
      builder: (context, snapshot) {
        return Consumer<GruaServiceState>(
          builder: (context, state, child) {
            double _totalDistance = 0;
            double _totalTime = 0;
            if (state.routeToClient != null &&
                state.routeFromClientToDestination != null) {
              _totalDistance = state.routeToClient!.totalDistance +
                  state.routeFromClientToDestination!.totalDistance;

              _totalTime = state.routeToClient!.totalTime +
                  state.routeFromClientToDestination!.totalTime;
            }
            final _distanceLabel = _totalDistance == 0
                ? "Calculando..."
                : '${_totalDistance / 1000} KM';

            final _timeLabel = _totalTime == 0
                ? "Calculando..."
                : '${(_totalTime / 60).toStringAsFixed(2)} Min';
            return SingleChildScrollView(
              child: Column(
                children: [
                  InfoLine(
                    title: "Distancia Total",
                    value: _distanceLabel,
                  ),
                  SizedBox(
                    height: Info.verticalUnit * 2,
                  ),
                  InfoLine(
                    title: "Tiempo del Recorrido",
                    value: _timeLabel,
                  ),
                  // SizedBox(
                  //   height: Info.verticalUnit * 2,
                  // ),
                  // InfoLine(
                  //   title: "Nombre conductor",
                  //   value: service.clientName.isEmpty
                  //       ? "Desconocido"
                  //       : service.clientName,
                  // ),
                  SizedBox(
                    height: Info.verticalUnit * 2,
                  ),
                  InfoLine(
                    title: "Fecha Solicitud",
                    value: FormatHelper.userDateFormat()
                        .format(service.requestTime),
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
                  Consumer<GruaServiceState>(builder: (context, state, child) {
                    if (state.loading) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    return ElevatedButton(
                      onPressed: state.loading
                          ? null
                          : service.status != ServiceStatus.pending
                              ? () => _viewCurrentService(context)
                              : () => _acceptService(context),
                      child: ResponsiveText(
                        service.status != ServiceStatus.pending
                            ? "Retomar Servicio"
                            : "Aceptar Servicio",
                        textType: TextType.Headline5,
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
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
