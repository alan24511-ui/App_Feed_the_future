import '../models/comida_model.dart';

class DatabaseService {
  static final List<ComidaModel> _comidas = [];

  static void agregarComida(ComidaModel comida) {
    _comidas.add(comida);
  }

  static List<ComidaModel> obtenerComidas() {
    return _comidas;
  }

  static double caloriasHoy() {
    DateTime hoy = DateTime.now();

    return _comidas
        .where((c) =>
    c.fecha.day == hoy.day &&
        c.fecha.month == hoy.month &&
        c.fecha.year == hoy.year)
        .fold(0, (sum, c) => sum + c.calorias);
  }

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
}