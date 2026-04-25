import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comida_model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔥 referencia del usuario
  static String get _uid => _auth.currentUser!.uid;

  static CollectionReference get _ref =>
      _db.collection('usuarios').doc(_uid).collection('comidas');

  // 🔹 AGREGAR COMIDA
  static Future<void> agregarComida(ComidaModel comida) async {
    await _ref.add(comida.toMap());
  }

  // 🔹 OBTENER COMIDAS (STREAM REALTIME)
  static Stream<List<ComidaModel>> obtenerComidasStream() {
    return _ref.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ComidaModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // 🔥 CALORÍAS HOY
  static Future<double> caloriasHoy() async {
    final snapshot = await _ref.get();
    final hoy = DateTime.now();

    double total = 0;

    for (var doc in snapshot.docs) {
      final c = ComidaModel.fromMap(doc.data() as Map<String, dynamic>);

      if (c.fecha.day == hoy.day &&
          c.fecha.month == hoy.month &&
          c.fecha.year == hoy.year) {
        total += c.calorias;
      }
    }

    return total;
  }

  // 🔥 CALORÍAS POR TIPO
  static Future<Map<String, double>> caloriasPorTipoHoy() async {
    final snapshot = await _ref.get();
    final hoy = DateTime.now();

    Map<String, double> data = {
      "Desayuno": 0,
      "Comida": 0,
      "Cena": 0,
    };

    for (var doc in snapshot.docs) {
      final c = ComidaModel.fromMap(doc.data() as Map<String, dynamic>);

      if (c.fecha.day == hoy.day &&
          c.fecha.month == hoy.month &&
          c.fecha.year == hoy.year) {
        data[c.tipo] = (data[c.tipo] ?? 0) + c.calorias;
      }
    }

    return data;
  }

  // 🔥 METAS
  static double metaCalorias = 2000;

  static void setMeta(double meta) => metaCalorias = meta;
  static double getMeta() => metaCalorias;
}