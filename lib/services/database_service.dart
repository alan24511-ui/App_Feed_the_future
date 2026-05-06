import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get _uid => _auth.currentUser?.uid;

  static CollectionReference<Map<String, dynamic>> get _comidasRef {
    if (_uid == null) throw Exception("Usuario no autenticado");

    return _db
        .collection('usuarios')
        .doc(_uid)
        .collection('comidas');
  }

  static CollectionReference<Map<String, dynamic>> get _historialRef {
    if (_uid == null) throw Exception("Usuario no autenticado");

    return _db
        .collection('usuarios')
        .doc(_uid)
        .collection('historial');
  }

  // =================================
  // 🔥 AGREGAR COMIDA (FALTABA)
  // =================
  static Future<void> agregarComida({
    required String nombre,
    required double calorias,
    required double proteinas,
    required double carbohidratos,
    required double grasas,
    required String tipo,
    required DateTime fecha,
  }) async {
    await _comidasRef.add({
      "nombre": nombre,
      "calorias": calorias,
      "proteinas": proteinas,
      "carbohidratos": carbohidratos,
      "grasas": grasas,
      "tipo": tipo,
      "fecha": fecha,
    });
  }

  // =================
  // 🔥 CALORÍAS HOY
  // =================
  static Stream<double> caloriasHoyStream() {
    return _comidasRef.snapshots().map((snapshot) {
      final hoy = DateTime.now();
      double total = 0.0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final fecha = (data["fecha"] as Timestamp).toDate();

        final mismoDia =
            fecha.year == hoy.year &&
                fecha.month == hoy.month &&
                fecha.day == hoy.day;

        if (mismoDia) {
          total += (data["calorias"] ?? 0).toDouble();
        }
      }

      return total;
    });
  }

  // =================
  // 🔥 CALORÍAS POR TIPO
  // =================
  static Stream<Map<String, double>> caloriasPorTipoStream() {
    return _comidasRef.snapshots().map((snapshot) {
      final hoy = DateTime.now();

      Map<String, double> data = {
        "Desayuno": 0.0,
        "Comida": 0.0,
        "Cena": 0.0,
      };

      for (var doc in snapshot.docs) {
        final item = doc.data();
        final fecha = (item["fecha"] as Timestamp).toDate();

        final mismoDia =
            fecha.year == hoy.year &&
                fecha.month == hoy.month &&
                fecha.day == hoy.day;

        if (mismoDia) {
          final tipo = (item["tipo"] ?? "Comida").toString();
          final calorias = (item["calorias"] ?? 0).toDouble();

          data[tipo] = (data[tipo] ?? 0) + calorias;
        }
      }

      return data;
    });
  }

  // =================
  // 🔥 SEMANA
  // =================
  static Stream<Map<String, double>> caloriasSemanaStream() {
    return _comidasRef.snapshots().map((snapshot) {

      Map<String, double> data = {
        "Lun": 0.0,
        "Mar": 0.0,
        "Mié": 0.0,
        "Jue": 0.0,
        "Vie": 0.0,
        "Sáb": 0.0,
        "Dom": 0.0,
      };

      final now = DateTime.now();

      // 🔥 lunes de esta semana
      final inicioSemana = now.subtract(Duration(days: now.weekday - 1));

      // 🔥 domingo
      final finSemana = inicioSemana.add(const Duration(days: 6));

      for (var doc in snapshot.docs) {
        final item = doc.data();
        final fecha = (item["fecha"] as Timestamp).toDate();

        final estaSemana =
            fecha.isAfter(inicioSemana.subtract(const Duration(days: 1))) &&
                fecha.isBefore(finSemana.add(const Duration(days: 1)));

        if (!estaSemana) continue;

        final dia = _dia(fecha.weekday);
        final calorias = (item["calorias"] ?? 0).toDouble();

        data[dia] = (data[dia] ?? 0) + calorias;
      }

      return data;
    });
  }
  static Stream<Map<String, Map<String, double>>> macrosSemanaStream() {
    return _comidasRef.snapshots().map((snapshot) {

      Map<String, Map<String, double>> data = {
        "Lun": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Mar": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Mié": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Jue": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Vie": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Sáb": {"cal": 0, "p": 0, "c": 0, "g": 0},
        "Dom": {"cal": 0, "p": 0, "c": 0, "g": 0},
      };

      final now = DateTime.now();
      final inicioSemana = now.subtract(Duration(days: now.weekday - 1));
      final finSemana = inicioSemana.add(const Duration(days: 6));

      for (var doc in snapshot.docs) {
        final item = doc.data();
        final fecha = (item["fecha"] as Timestamp).toDate();

        final estaSemana =
            fecha.isAfter(inicioSemana.subtract(const Duration(days: 1))) &&
                fecha.isBefore(finSemana.add(const Duration(days: 1)));

        if (!estaSemana) continue;

        final dia = _dia(fecha.weekday);

        data[dia]!["cal"] =
            (data[dia]!["cal"] ?? 0) + (item["calorias"] ?? 0).toDouble();

        data[dia]!["p"] =
            (data[dia]!["p"] ?? 0) + (item["proteinas"] ?? 0).toDouble();

        data[dia]!["c"] =
            (data[dia]!["c"] ?? 0) + (item["carbohidratos"] ?? 0).toDouble();

        data[dia]!["g"] =
            (data[dia]!["g"] ?? 0) + (item["grasas"] ?? 0).toDouble();
      }

      return data;
    });
  }
  static String _dia(int d) {
    switch (d) {
      case 1: return "Lun";
      case 2: return "Mar";
      case 3: return "Mié";
      case 4: return "Jue";
      case 5: return "Vie";
      case 6: return "Sáb";
      case 7: return "Dom";
      default: return "";
    }
  }

  // =================
  // 🔥 MACROS HOY
  // =================
  static Stream<Map<String, double>> macrosHoyStream() {
    return _comidasRef.snapshots().map((snapshot) {
      final hoy = DateTime.now();

      double prote = 0;
      double carbs = 0;
      double grasas = 0;

      for (var doc in snapshot.docs) {
        final item = doc.data();
        final fecha = (item["fecha"] as Timestamp).toDate();

        final mismoDia =
            fecha.year == hoy.year &&
                fecha.month == hoy.month &&
                fecha.day == hoy.day;

        if (mismoDia) {
          prote += (item["proteinas"] ?? 0).toDouble();
          carbs += (item["carbohidratos"] ?? 0).toDouble();
          grasas += (item["grasas"] ?? 0).toDouble();
        }
      }

      return {
        "prote": prote,
        "carbs": carbs,
        "grasas": grasas,
      };
    });
  }

  // =================
  // 🔥 HISTORIAL STREAM (FALTABA)
  // =================
  static Stream<List<Map<String, dynamic>>> historialStream() {
    return _historialRef
        .orderBy("fecha", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data();
      }).toList();
    });
  }

  // =================
  // 🔥 HISTORIAL POR DÍA (FALTABA)
  // =================
  static Stream<List<Map<String, dynamic>>> historialPorDia(DateTime dia) {
    return _comidasRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data())
          .where((data) {
        final fecha = (data["fecha"] as Timestamp).toDate();

        return fecha.year == dia.year &&
            fecha.month == dia.month &&
            fecha.day == dia.day;
      })
          .toList();
    });
  }

  // =================
  // 🔥 GUARDAR DÍA ANTERIOR (CORREGIDO)
  // =================
  static Future<void> guardarDiaAnterior() async {
    if (_uid == null) return;

    final snapshot = await _comidasRef.get();

    final hoy = DateTime.now();
    final id = "${hoy.year}-${hoy.month}-${hoy.day}";

    double total = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      total += (data["calorias"] ?? 0).toDouble();
    }

    await _historialRef.doc(id).set({
      "calorias": total,
      "fecha": Timestamp.now(),
    });
  }
}