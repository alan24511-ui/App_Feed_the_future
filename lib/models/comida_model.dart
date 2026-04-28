import 'package:cloud_firestore/cloud_firestore.dart';

class ComidaModel {
  String nombre;
  double calorias;
  double proteinas;
  double carbohidratos;
  double grasas;
  String tipo;
  DateTime fecha;

  ComidaModel({
    required this.nombre,
    required this.calorias,
    required this.proteinas,
    required this.carbohidratos,
    required this.grasas,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "calorias": calorias,
      "proteinas": proteinas,
      "carbohidratos": carbohidratos,
      "grasas": grasas,
      "tipo": tipo,
      "fecha": fecha,
    };
  }

  factory ComidaModel.fromMap(Map<String, dynamic> map) {
    return ComidaModel(
      nombre: map["nombre"],
      calorias: (map["calorias"] ?? 0).toDouble(),
      proteinas: (map["proteinas"] ?? 0).toDouble(),
      carbohidratos: (map["carbohidratos"] ?? 0).toDouble(),
      grasas: (map["grasas"] ?? 0).toDouble(),
      tipo: map["tipo"],
      fecha: (map["fecha"] as Timestamp).toDate(),
    );
  }
}