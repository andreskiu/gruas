import 'package:image/image.dart';

import 'evidence_types.dart';

class Evidence {
  final Image photo;
  final EvidenceType type;
  Evidence({
    required this.photo,
    required this.type,
  });

  Evidence copyWith({
    Image? photo,
    EvidenceType? type,
  }) {
    return Evidence(
      photo: photo ?? this.photo,
      type: type ?? this.type,
    );
  }
}
