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

  // ================= GUARDAR =================
  Map<String, dynamic> toMap() {
    return {
      "nombre": nombre,
      "calorias": calorias.toDouble(),
      "proteinas": proteinas.toDouble(),
      "carbohidratos": carbohidratos.toDouble(),
      "grasas": grasas.toDouble(),
      "tipo": tipo,
      "fecha": fecha,
    };
  }

  // ================= LEER (FIX REAL) =================
  factory ComidaModel.fromMap(Map<String, dynamic> map) {
    return ComidaModel(
      nombre: map["nombre"] ?? "",

      calorias: (map["calorias"] as num? ?? 0).toDouble(),
      proteinas: (map["proteinas"] as num? ?? 0).toDouble(),
      carbohidratos: (map["carbohidratos"] as num? ?? 0).toDouble(),
      grasas: (map["grasas"] as num? ?? 0).toDouble(),

      tipo: map["tipo"] ?? "Desconocido",

      fecha: (map["fecha"] is Timestamp)
          ? (map["fecha"] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}