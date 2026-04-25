class UserModel {
  String correo;
  String nombre;
  String apellido;
  int edad;
  String sexo;
  double peso;
  double altura;
  double imc;
  double meta;

  UserModel({
    required this.correo,
    required this.nombre,
    required this.apellido,
    required this.edad,
    required this.sexo,
    required this.peso,
    required this.altura,
    required this.imc,
    required this.meta,
  });

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'nombre': nombre,
      'apellido': apellido,
      'edad': edad,
      'sexo': sexo,
      'peso': peso,
      'altura': altura,
      'imc': imc,
      'meta': meta,
    };
  }

  // 🔥 crear desde Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      correo: map['correo'] ?? '',
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      edad: map['edad'] ?? 0,
      sexo: map['sexo'] ?? '',
      peso: (map['peso'] ?? 0).toDouble(),
      altura: (map['altura'] ?? 0).toDouble(),
      imc: (map['imc'] ?? 0).toDouble(),
      meta: (map['meta'] ?? 2000).toDouble(),
    );
  }
}