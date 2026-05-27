class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String documentId;
  final String? photoUrl;
  final DateTime enrollmentDate;
  final bool isActive;
  final String classId; // 👈 Agregado: ID de la clase a la que pertenece
  
  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.documentId,
    this.photoUrl,
    required this.enrollmentDate,
    this.isActive = true,
    required this.classId, // 👈 Nuevo campo requerido
  });
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'documentId': documentId,
      'photoUrl': photoUrl,
      'enrollmentDate': enrollmentDate.toIso8601String(),
      'isActive': isActive,
      'classId': classId, // 👈 Incluir en JSON
    };
  }
  
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      documentId: json['documentId'] as String,
      photoUrl: json['photoUrl'] as String?,
      enrollmentDate: DateTime.parse(json['enrollmentDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
      classId: json['classId'] as String, // 👈 Leer desde JSON
    );
  }
  
  Student copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? documentId,
    String? photoUrl,
    DateTime? enrollmentDate,
    bool? isActive,
    String? classId,
  }) {
    return Student(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      documentId: documentId ?? this.documentId,
      photoUrl: photoUrl ?? this.photoUrl,
      enrollmentDate: enrollmentDate ?? this.enrollmentDate,
      isActive: isActive ?? this.isActive,
      classId: classId ?? this.classId,
    );
  }
}