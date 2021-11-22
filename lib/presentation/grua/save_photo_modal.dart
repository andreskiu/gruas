import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/infrastructure/grua/models/evidence.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:flutter_base/presentation/core/styles/light_theme.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SaveFotoModal extends StatefulWidget {
  SaveFotoModal({
    Key? key,
    required this.photo,
  }) : super(key: key);

  final XFile photo;

  @override
  State<SaveFotoModal> createState() => _SaveFotoModalState();
}

class _SaveFotoModalState extends State<SaveFotoModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _state = GetIt.I.get<GruaServiceState>();
  bool _isLoading = false;

  late EvidenceType _selectedEvidenceType;
  final _types = [
    EvidenceType(
      id: "1",
      name: "Atasco en tráfico",
      description: '',
    ),
    EvidenceType(
      id: "2",
      name: "Vehículo Subido",
      description: '',
    ),
    EvidenceType(
      id: "3",
      name: "Vehículo entregado",
      description: '',
    ),
  ];
  @override
  void initState() {
    super.initState();
    _selectedEvidenceType = _types.first;
    _state.evidenceUploaded = false;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GruaServiceState>.value(
      value: _state,
      builder: (context, snapshot) {
        return Form(
          key: _formKey,
          child: Container(
            height: Info.verticalUnit * 50,
            padding: EdgeInsets.symmetric(horizontal: Info.horizontalUnit * 10),
            child: Consumer<GruaServiceState>(
              builder: (context, state, child) {
                return state.evidenceUploaded
                    ? Column(
                        children: [
                          ResponsiveText("Foto Subida con exito,"),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          ElevatedButton(
                            child: Text("Aceptar"),
                            onPressed: () {
                              AutoRouter.of(context).pop(true);
                            },
                          )
                        ],
                      )
                    : ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Center(child: ResponsiveText("Subir Foto")),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          Container(
                            height: Info.verticalUnit * 20,
                            width: Info.verticalUnit * 15,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    widget.photo.path,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          ResponsiveFormFieldButton<EvidenceType>(
                            value: _selectedEvidenceType,
                            onSaved: (type) {
                              if (type != null) {
                                _selectedEvidenceType = type;
                              }
                            },
                            items: _types
                                .map(
                                  (ev) => DropdownMenuItem(
                                    value: ev,
                                    child: ResponsiveText(ev.name),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          _isLoading
                              ? Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                              : ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            final _evidence = Evidence(
                                              photo: widget.photo,
                                              type: _selectedEvidenceType,
                                            );
                                            final _successOrFailure =
                                                await _state.uploadEvidence(
                                              _evidence,
                                            );
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            // if (_successOrFailure) {
                                            //   print(
                                            //       "Make the use case to save the foto");
                                            //   AutoRouter.of(context).pop(true);
                                            // } else {
                                            //   // TODO: SHOW SOME ERROR
                                            // }
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                  child: ResponsiveText(
                                    "Subir foto",
                                    textType: TextType.Headline5,
                                  ),
                                ),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          state.error != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                    bottom: Info.verticalUnit * 2,
                                  ),
                                  child: ResponsiveText(
                                    state.error!.message,
                                    color: Theme.of(context).errorColor,
                                  ),
                                )
                              : SizedBox.shrink(),
                        ],
                      );
              },
            ),
          ),
        );
      },
    );
  }
}
