import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/routes/app_router.gr.dart';

class ServiceDetails extends StatelessWidget {
  const ServiceDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Info.horizontalUnit * 5,
          ),
          child: Column(children: [
            SizedBox(
              height: Info.safeAreaPadding.top + Info.horizontalUnit * 2,
            ),
            ResponsiveText(
              "Servicio recibido",
              fontSize: 35,
            ),
            SizedBox(
              height: Info.verticalUnit * 5,
            ),
            Card(
              child: Container(
                height: Info.verticalUnit * 45,
                child: Center(
                  child: ResponsiveText('Mapa'),
                ),
              ),
            ),
            SizedBox(
              height: Info.verticalUnit * 4,
            ),
            InfoLine(
              title: "Tipo de Servicio",
              value: 'Grua',
            ),
            SizedBox(
              height: Info.verticalUnit * 2,
            ),
            InfoLine(
              title: "Nombre conductor",
              value: 'Pablo Garcia',
            ),
            SizedBox(
              height: Info.verticalUnit * 2,
            ),
            InfoLine(
              title: "Corralon Destino",
              value: 'Corralon 25',
            ),
            SizedBox(
              height: Info.verticalUnit * 8,
            ),
            ElevatedButton(
              onPressed: () {
                AutoRouter.of(context).push(ServiceAcceptedPageRoute());
              },
              child: ResponsiveText(
                "Aceptar Servicio",
                textType: TextType.Headline5,
              ),
            ),
          ]),
        ),
      ),
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
