class EvidenceType {
  final int id;
  final String name;
  final String description;
  EvidenceType({
    required this.id,
    required this.name,
    required this.description,
  });

  EvidenceType copyWith({
    int? id,
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
