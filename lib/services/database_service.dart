import '../models/comida_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final List<ComidaModel> _comidas = [];

  // 🔹 CRUD
  static void agregarComida(ComidaModel comida) {
    _comidas.add(comida);
  }

  static List<ComidaModel> obtenerComidas() {
    return _comidas;
  }

  // 🔹 CALORÍAS HOY
  static double caloriasHoy() {
    DateTime hoy = DateTime.now();

    return _comidas
        .where((c) =>
    c.fecha.day == hoy.day &&
        c.fecha.month == hoy.month &&
        c.fecha.year == hoy.year)
        .fold(0, (sum, c) => sum + c.calorias);
  }

  // 🔹 CALORÍAS POR TIPO
  static Map<String, double> caloriasPorTipoHoy() {
    DateTime hoy = DateTime.now();

    Map<String, double> data = {
      "Desayuno": 0,
      "Comida": 0,
      "Cena": 0,
    };

    for (var c in _comidas) {
      if (c.fecha.day == hoy.day &&
          c.fecha.month == hoy.month &&
          c.fecha.year == hoy.year) {
        data[c.tipo] = (data[c.tipo] ?? 0) + c.calorias;
      }
    }

    return data;
  }

  // 🔥 META CALÓRICA
  static double metaCalorias = 2000;

  static void setMeta(double meta) {
    metaCalorias = meta;
  }

  static double getMeta() {
    return metaCalorias;
  }
  static UserModel? usuarioActual;

  static void guardarUsuario(UserModel user) {
    usuarioActual = user;
  }
}