class DatabaseService {
  static List<Map<String, dynamic>> historial = [];

  static void guardar(Map<String, dynamic> comida) {
    historial.add(comida);
  }

  static List<Map<String, dynamic>> obtener() {
    return historial;
  }
}