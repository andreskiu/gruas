import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base/application/grua/grua_service_state.dart';
import 'package:flutter_base/domain/core/utils/image_helper.dart';
import 'package:flutter_base/domain/grua/models/evidence.dart';
import 'package:flutter_base/domain/grua/models/evidence_types.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_calculations.dart';
import 'package:flutter_base/presentation/core/responsivity/responsive_text.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as im;

class SaveFotoModal extends StatefulWidget {
  SaveFotoModal({
    Key? key,
    this.photo,
  }) : super(key: key);

  final im.Image? photo;

  @override
  State<SaveFotoModal> createState() => _SaveFotoModalState();
}

class _SaveFotoModalState extends State<SaveFotoModal> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _state = GetIt.I.get<GruaServiceState>();
  late Future<List<EvidenceType>> _evidenceTypeQuery;
  bool _isLoading = false;

  late EvidenceType _selectedEvidenceType;
  im.Image? _photo;
  Future<Uint8List?>? _imageEncode;

  @override
  void initState() {
    super.initState();

    _state.evidenceUploaded = false;
    _evidenceTypeQuery = _state.getEvidenceTypes();
    _prepareImage().then(
      (photo) => _imageEncode = _encodeImage(photo),
    );
  }

  Future<im.Image?> _prepareImage() async {
    if (widget.photo == null) {
      return null;
    }
    _photo = await ImageHelper.putLocationWatermark(widget.photo!);
    return _photo;
  }

  Future<Uint8List?> _encodeImage(im.Image? image) async {
    if (image == null) {
      return null;
    }
    return ImageHelper.encodeJpg(image);
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
                          widget.photo == null
                              ? Text("No se tomo ninguna foto")
                              : FutureBuilder<Uint8List?>(
                                  future: _imageEncode,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData ||
                                        snapshot.data == null) {
                                      return Column(
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          Text("Preparando imagen"),
                                        ],
                                      );
                                    }
                                    return Container(
                                      height: Info.verticalUnit * 25,
                                      width: Info.verticalUnit * 15,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: Image.memory(snapshot.data!)
                                              .image,
                                        ),
                                      ),
                                    );
                                  }),
                          SizedBox(
                            height: Info.verticalUnit * 2,
                          ),
                          FutureBuilder<List<EvidenceType>>(
                              future: _evidenceTypeQuery,
                              builder: (context, snapshot) {
                                if (snapshot.data == null) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.data!.isNotEmpty) {
                                  _selectedEvidenceType = snapshot.data!.first;
                                }
                                return ResponsiveFormFieldButton<EvidenceType>(
                                  value: _selectedEvidenceType,
                                  onSaved: (type) {
                                    if (type != null) {
                                      _selectedEvidenceType = type;
                                    }
                                  },
                                  items: snapshot.data!
                                      .map(
                                        (ev) => DropdownMenuItem(
                                          value: ev,
                                          child: ResponsiveText(ev.name),
                                        ),
                                      )
                                      .toList(),
                                );
                              }),
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
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            if (_photo == null) {
                                              return;
                                            }
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            final _evidence = Evidence(
                                              photo: _photo!,
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
                                  padding: EdgeInsets.only(
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
