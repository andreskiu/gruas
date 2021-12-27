import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_base/domain/grua/models/evidence_types.dart';

part 'evidence_type_server_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EvidenceTypeSWrapper {
  // @JsonKey()
  final List<EvidenceTypeServerModel> listObject;
  EvidenceTypeSWrapper({
    required this.listObject,
  });

  factory EvidenceTypeSWrapper.fromJson(Map<String, dynamic> json) =>
      _$EvidenceTypeSWrapperFromJson(json);

  Map<String, dynamic> toJson() => _$EvidenceTypeSWrapperToJson(this);
}

@JsonSerializable()
class EvidenceTypeServerModel {
  final int id;
  final String? nombre;
  final String? descripcion;
  EvidenceTypeServerModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
  });

  EvidenceType toEntity() {
    return EvidenceType(
      id: id,
      name: nombre ?? 'Opcion desconocida',
      description: descripcion ?? "Opcion",
    );
  }

  EvidenceTypeServerModel copyWith({
    int? id,
    String? nombre,
    String? descripcion,
  }) {
    return EvidenceTypeServerModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  factory EvidenceTypeServerModel.fromEntity(EvidenceType evidence) {
    return EvidenceTypeServerModel(
      id: evidence.id,
      nombre: evidence.name,
      descripcion: evidence.description,
    );
  }

  factory EvidenceTypeServerModel.fromJson(Map<String, dynamic> json) =>
      _$EvidenceTypeServerModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvidenceTypeServerModelToJson(this);
}
