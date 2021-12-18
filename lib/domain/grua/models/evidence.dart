import 'package:image_picker/image_picker.dart';

import 'evidence_types.dart';

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
