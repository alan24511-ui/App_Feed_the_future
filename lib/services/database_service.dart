import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/comida_model.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Evita crash si no hay usuario
  static String? get _uid => _auth.currentUser?.uid;

  static CollectionReference get _ref {
    if (_uid == null) {
      throw Exception("Usuario no autenticado");
    }
    return _db.collection('usuarios').doc(_uid).collection('comidas');
  }

  // ✅ GUARDAR (corrige fecha)
  static Future<void> agregarComida(ComidaModel comida) async {
    final data = comida.toMap();

    // 🔥 convertir DateTime -> Timestamp
    data["fecha"] = Timestamp.fromDate(comida.fecha);

    await _ref.add(data);
  }

  // ✅ CALORÍAS HOY
  static Stream<double> caloriasHoyStream() {
    return _ref.snapshots().map((snapshot) {
      final hoy = DateTime.now();
      double total = 0;

      for (var doc in snapshot.docs) {
        final c = ComidaModel.fromMap(doc.data() as Map<String, dynamic>);
        if (_mismoDia(c.fecha, hoy)) {
          total += c.calorias;
        }
      }
      return total;
    });
  }

  // ✅ POR TIPO
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
        if (_mismoDia(c.fecha, hoy)) {
          data[c.tipo] = (data[c.tipo] ?? 0) + c.calorias;
        }
      }
      return data;
    });
  }

  // ✅ MACROS
  static Stream<Map<String, double>> macrosHoyStream() {
    return _ref.snapshots().map((snapshot) {
      final hoy = DateTime.now();

      double prote = 0;
      double carbs = 0;
      double grasas = 0;

      for (var doc in snapshot.docs) {
        final c = ComidaModel.fromMap(doc.data() as Map<String, dynamic>);
        if (_mismoDia(c.fecha, hoy)) {
          prote += c.proteinas;
          carbs += c.carbohidratos;
          grasas += c.grasas;
        }
      }

      return {
        "prote": prote,
        "carbs": carbs,
        "grasas": grasas,
      };
    });
  }

  // ✅ SEMANA
  static Stream<Map<String, double>> caloriasSemanaStream() {
    return _ref.snapshots().map((snapshot) {
      final now = DateTime.now();

      Map<String, double> data = {
        "Lun": 0,
        "Mar": 0,
        "Mié": 0,
        "Jue": 0,
        "Vie": 0,
        "Sáb": 0,
        "Dom": 0,
      };

      for (var doc in snapshot.docs) {
        final c = ComidaModel.fromMap(doc.data() as Map<String, dynamic>);
        final diff = now.difference(c.fecha).inDays;

        if (diff >= 0 && diff < 7) {
          String dia = _dia(c.fecha.weekday);
          data[dia] = (data[dia] ?? 0) + c.calorias;
        }
      }

      return data;
    });
  }
  static Stream<List<double>> macrosHoyListStream() {
    return macrosHoyStream().map((data) {
      return [
        data["prote"] ?? 0,
        data["carbs"] ?? 0,
        data["grasas"] ?? 0,
      ];
    });
  }

  // ✅ UTILIDADES
  static bool _mismoDia(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  static String _dia(int d) {
    switch (d) {
      case 1:
        return "Lun";
      case 2:
        return "Mar";
      case 3:
        return "Mié";
      case 4:
        return "Jue";
      case 5:
        return "Vie";
      case 6:
        return "Sáb";
      case 7:
        return "Dom";
      default:
        return "";
    }
  }
}