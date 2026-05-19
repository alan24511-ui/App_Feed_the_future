class RecomendacionService {

  static List<Map<String, dynamic>> generarSugerencias({

    required double caloriasHoy,
    required double metaCalorias,

    required double proteHoy,
    required double proteMeta,

    required double carbsHoy,
    required double carbsMeta,

    required double grasasHoy,
    required double grasasMeta,

    required String metaUsuario,
  }) {

    List<Map<String, dynamic>> sugerencias = [];

    // ---------------- CALORÍAS ----------------

    if (caloriasHoy < metaCalorias * 0.5) {

      sugerencias.add({
        "emoji": "⚡",
        "titulo": "Muy pocas calorías",
        "descripcion":
        "Tu consumo de hoy es bajo. Considera una comida más completa.",
      });
    }

    if (caloriasHoy > metaCalorias) {

      sugerencias.add({
        "emoji": "🔥",
        "titulo": "Meta excedida",
        "descripcion":
        "Ya superaste tu meta calórica diaria.",
      });
    }

    // ---------------- PROTEÍNA ----------------

    if (proteHoy < proteMeta * 0.7) {

      sugerencias.add({
        "emoji": "💪",
        "titulo": "Proteína baja",
        "descripcion":
        "Prueba pollo, huevos, yogurt griego o atún.",
      });
    }

    // ---------------- CARBS ----------------

    if (carbsHoy < carbsMeta * 0.5) {

      sugerencias.add({
        "emoji": "🍞",
        "titulo": "Falta energía",
        "descripcion":
        "Puedes agregar arroz, avena o pasta.",
      });
    }

    // ---------------- GRASAS ----------------

    if (grasasHoy > grasasMeta) {

      sugerencias.add({
        "emoji": "🥑",
        "titulo": "Grasas elevadas",
        "descripcion":
        "Evita frituras o comida rápida el resto del día.",
      });
    }

    // ---------------- OBJETIVOS ----------------

    switch (metaUsuario) {

      case "perder_peso":

        sugerencias.add({
          "emoji": "🥗",
          "titulo": "Consejo para perder peso",
          "descripcion":
          "Prioriza proteína magra y verduras.",
        });

        break;

      case "ganar_masa":

        sugerencias.add({
          "emoji": "🏋️",
          "titulo": "Consejo para ganar masa",
          "descripcion":
          "Aumenta proteína y carbohidratos complejos.",
        });

        break;

      default:

        sugerencias.add({
          "emoji": "⚖️",
          "titulo": "Balance nutricional",
          "descripcion":
          "Mantén una alimentación equilibrada.",
        });
    }

    return sugerencias;
  }
}