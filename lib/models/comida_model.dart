class ComidaModel {
  final String nombre;
  final double calorias;
  final String tipo;
  final DateTime fecha;

  ComidaModel({
    required this.nombre,
    required this.calorias,
    required this.tipo,
    required this.fecha,
  });

  // 🔥 convertir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'calorias': calorias,
      'tipo': tipo,
      'fecha': fecha.toIso8601String(),
    };
  }

  // 🔥 convertir desde Firestore
  factory ComidaModel.fromMap(Map<String, dynamic> map) {
    return ComidaModel(
      nombre: map['nombre'],
      calorias: map['calorias'],
      tipo: map['tipo'],
      fecha: DateTime.parse(map['fecha']),
    );
  }
}