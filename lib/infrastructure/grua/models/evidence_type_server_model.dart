import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_base/domain/grua/models/evidence_types.dart';

part 'evidence_type_server_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EvidenceTypeSWrapper {
  @JsonKey(name: 'data_list')
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
  final String? name;
  final String? description;
  EvidenceTypeServerModel({
    required this.id,
    required this.name,
    required this.description,
  });

  EvidenceType toEntity() {
    return EvidenceType(
      id: id,
      name: name ?? 'Opcion desconocida',
      description: description ?? "Opcion",
    );
  }

  EvidenceTypeServerModel copyWith({
    int? id,
    String? name,
    String? description,
  }) {
    return EvidenceTypeServerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  factory EvidenceTypeServerModel.fromEntity(EvidenceType evidence) {
    return EvidenceTypeServerModel(
      id: evidence.id,
      name: evidence.name,
      description: evidence.description,
    );
  }

  factory EvidenceTypeServerModel.fromJson(Map<String, dynamic> json) =>
      _$EvidenceTypeServerModelFromJson(json);

  Map<String, dynamic> toJson() => _$EvidenceTypeServerModelToJson(this);
}
