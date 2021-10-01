import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';

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
  const ButtonBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () => null,
              child: ResponsiveText(
                "Escanear QR",
                textType: TextType.Headline5,
              ),
            ),
            ElevatedButton(
              onPressed: () => null,
              child: ResponsiveText(
                "Sacar Foto",
                textType: TextType.Headline5,
              ),
            ),
          ],
        ),
        // SizedBox(
        //   height: Info.verticalUnit * 8,
        // ),
      ],
    );
  }
}
