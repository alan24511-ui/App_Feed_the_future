import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comida_model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String get _uid => _auth.currentUser!.uid;

  static CollectionReference get _ref =>
      _db.collection('usuarios').doc(_uid).collection('comidas');

  // 🔹 AGREGAR COMIDA
  static Future<void> agregarComida(ComidaModel comida) async {
    await _ref.add(comida.toMap());
  }

  // 🔥 STREAM CALORÍAS HOY (REAL TIME)
  static Stream<double> caloriasHoyStream() {
    return _ref.snapshots().map((snapshot) {
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
    });
  }

  // 🔥 STREAM GRÁFICA POR TIPO
  static Stream<Map<String, double>> caloriasPorTipoStream() {
    return _ref.snapshots().map((snapshot) {
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
    });
  }
}