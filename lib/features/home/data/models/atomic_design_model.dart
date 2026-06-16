enum AtomicLevel { foundation, atom, molecule, organism, template, page }

class AtomicComponent {
  final String id;
  final String name;
  final String description;
  final AtomicLevel level;
  final String? codeSnippet;
  final String? imageUrl;
  final Map<String, dynamic>? properties;
  final DateTime lastUpdated;

  const AtomicComponent({
    required this.id,
    required this.name,
    required this.description,
    required this.level,
    this.codeSnippet,
    this.imageUrl,
    this.properties,
    required this.lastUpdated,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'level': level.name,
    'codeSnippet': codeSnippet,
    'imageUrl': imageUrl,
    'properties': properties,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory AtomicComponent.fromJson(Map<String, dynamic> json) =>
      AtomicComponent(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        level: AtomicLevel.values.firstWhere((e) => e.name == json['level']),
        codeSnippet: json['codeSnippet'] as String?,
        imageUrl: json['imageUrl'] as String?,
        properties: json['properties'] as Map<String, dynamic>?,
        lastUpdated: DateTime.parse(json['lastUpdated']),
      );

  AtomicComponent copyWith({
    String? name,
    String? description,
    AtomicLevel? level,
    String? codeSnippet,
    String? imageUrl,
    Map<String, dynamic>? properties,
    DateTime? lastUpdated,
  }) {
    return AtomicComponent(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      level: level ?? this.level,
      codeSnippet: codeSnippet ?? this.codeSnippet,
      imageUrl: imageUrl ?? this.imageUrl,
      properties: properties ?? this.properties,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

class AtomicDesignModel {
  final List<AtomicComponent> foundations;
  final List<AtomicComponent> atoms;
  final List<AtomicComponent> molecules;
  final List<AtomicComponent> organisms;
  final List<AtomicComponent> templates;
  final List<AtomicComponent> pages;

  const AtomicDesignModel({
    this.foundations = const [],
    this.atoms = const [],
    this.molecules = const [],
    this.organisms = const [],
    this.templates = const [],
    this.pages = const [],
  });

  Map<String, dynamic> toJson() => {
    'foundations': foundations.map((e) => e.toJson()).toList(),
    'atoms': atoms.map((e) => e.toJson()).toList(),
    'molecules': molecules.map((e) => e.toJson()).toList(),
    'organisms': organisms.map((e) => e.toJson()).toList(),
    'templates': templates.map((e) => e.toJson()).toList(),
    'pages': pages.map((e) => e.toJson()).toList(),
  };

  factory AtomicDesignModel.fromJson(Map<String, dynamic> json) =>
      AtomicDesignModel(
        foundations: (json['foundations'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
        atoms: (json['atoms'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
        molecules: (json['molecules'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
        organisms: (json['organisms'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
        templates: (json['templates'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
        pages: (json['pages'] as List? ?? [])
            .map((e) => AtomicComponent.fromJson(e))
            .toList(),
      );
}
