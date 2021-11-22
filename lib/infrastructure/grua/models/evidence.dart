import 'package:image_picker/image_picker.dart';

class Evidence {
  final XFile photo;
  final EvidenceType type;
  Evidence({
    required this.photo,
    required this.type,
  });

  Evidence copyWith({
    XFile? photo,
    EvidenceType? type,
  }) {
    return Evidence(
      photo: photo ?? this.photo,
      type: type ?? this.type,
    );
  }
}

class EvidenceType {
  final String id;
  final String name;
  final String description;
  EvidenceType({
    required this.id,
    required this.name,
    required this.description,
  });

  EvidenceType copyWith({
    String? id,
    String? name,
    String? description,
  }) {
    return EvidenceType(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }
}
