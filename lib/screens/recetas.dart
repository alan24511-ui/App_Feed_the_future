import 'package:flutter/material.dart';
import 'receta_detalle.dart';

class Recetas extends StatelessWidget {
  Recetas({super.key});

  final Map<String, List<Map<String, dynamic>>> categorias = {

    // ================= DESAYUNO =================
    "🍳 Desayuno": [

      {
        "nombre": "🥞 Hotcakes de avena con plátano",
        "desc": "Esponjosos y sin harina refinada",
        "ingredientes": [
          "1/2 taza de avena molida",
          "1 plátano maduro",
          "1 huevo",
          "1/4 taza de leche",
          "1 cucharadita de vainilla"
        ],
        "pasos":
        "Coloca todos los ingredientes en la licuadora\n"
            "Licúa hasta obtener una mezcla homogénea\n"
            "Calienta un sartén antiadherente a fuego medio\n"
            "Vierte pequeñas porciones de la mezcla\n"
            "Cocina hasta que aparezcan burbujas y voltea\n"
            "Cocina el otro lado hasta dorar\n"
            "Sirve caliente",
        "cal": 260
      },

      {
        "nombre": "🍳 Omelette de champiñones y queso",
        "desc": "Desayuno alto en proteína",
        "ingredientes": [
          "2 huevos",
          "1/2 taza de champiñones rebanados",
          "30g de queso panela",
          "1 cucharadita de aceite"
        ],
        "pasos":
        "Bate los huevos en un bowl\n"
            "Calienta el aceite en un sartén\n"
            "Agrega los champiñones y cocina 3 minutos\n"
            "Vierte los huevos\n"
            "Añade el queso encima\n"
            "Dobla el omelette y cocina 2 minutos más\n"
            "Sirve caliente",
        "cal": 280
      },

      {
        "nombre": "🥣 Avena cremosa con manzana y canela",
        "desc": "Desayuno reconfortante",
        "ingredientes": [
          "1/2 taza de avena",
          "1 taza de leche",
          "1 manzana en cubos",
          "1/2 cucharadita de canela",
          "1 cucharadita de miel"
        ],
        "pasos":
        "Coloca la avena y leche en una olla\n"
            "Cocina a fuego medio durante 5 minutos\n"
            "Agrega la manzana y canela\n"
            "Mezcla constantemente\n"
            "Añade miel al final\n"
            "Sirve caliente",
        "cal": 230
      },

      {
        "nombre": "🥪 Sándwich integral con huevo y aguacate",
        "desc": "Completo y balanceado",
        "ingredientes": [
          "2 rebanadas de pan integral",
          "1 huevo",
          "1/4 de aguacate",
          "Sal y pimienta"
        ],
        "pasos":
        "Tuesta ligeramente el pan\n"
            "Cocina el huevo al gusto\n"
            "Machaca el aguacate con sal y pimienta\n"
            "Unta el aguacate en el pan\n"
            "Agrega el huevo\n"
            "Cierra el sándwich y sirve",
        "cal": 300
      },

      {
        "nombre": "🥤 Smoothie de frutos rojos",
        "desc": "Refrescante y antioxidante",
        "ingredientes": [
          "1 taza de frutos rojos",
          "1 taza de leche",
          "1 cucharadita de miel"
        ],
        "pasos":
        "Coloca todos los ingredientes en la licuadora\n"
            "Licúa durante 1 minuto\n"
            "Sirve frío",
        "cal": 190
      },

      {
        "nombre": "🍞 Tostadas con aguacate y huevo pochado",
        "desc": "Desayuno gourmet saludable",
        "ingredientes": [
          "2 tostadas integrales",
          "1/2 aguacate",
          "2 huevos",
          "Sal"
        ],
        "pasos":
        "Machaca el aguacate\n"
            "Hierve agua y cocina los huevos 3 minutos\n"
            "Unta el aguacate en el pan\n"
            "Coloca el huevo encima\n"
            "Agrega sal y sirve",
        "cal": 320
      },

      {
        "nombre": "🥐 Yogur griego con granola y miel",
        "desc": "Desayuno rápido",
        "ingredientes": [
          "1 taza de yogur griego",
          "1/4 taza de granola",
          "1 cucharadita de miel"
        ],
        "pasos":
        "Coloca el yogur en un bowl\n"
            "Agrega la granola\n"
            "Añade miel encima\n"
            "Sirve",
        "cal": 210
      },

      {
        "nombre": "🍌 Licuado de avena y plátano",
        "desc": "Energía prolongada",
        "ingredientes": [
          "1 plátano",
          "2 cucharadas de avena",
          "1 taza de leche"
        ],
        "pasos":
        "Coloca todo en la licuadora\n"
            "Licúa hasta que quede suave\n"
            "Sirve frío",
        "cal": 220
      },

      {
        "nombre": "🍓 Tostadas con queso y fresas",
        "desc": "Dulce y saludable",
        "ingredientes": [
          "2 tostadas integrales",
          "Queso crema ligero",
          "Fresas"
        ],
        "pasos":
        "Unta el queso en las tostadas\n"
            "Corta las fresas\n"
            "Colócalas encima\n"
            "Sirve",
        "cal": 200
      },

      {
        "nombre": "🥚 Huevos con espinaca",
        "desc": "Proteína con fibra",
        "ingredientes": [
          "2 huevos",
          "Espinaca",
          "Aceite"
        ],
        "pasos":
        "Saltea la espinaca\n"
            "Agrega los huevos\n"
            "Revuelve\n"
            "Sirve",
        "cal": 210
      },
    ],

    // ================= COMIDA =================
    "🍽️ Comida": [
      {
        "nombre": "🌮 Tacos de pollo asado",
        "desc": "Jugosos y llenos de sabor",
        "ingredientes": [
          "Tortillas",
          "Pechuga de pollo",
          "Cebolla",
          "Cilantro",
          "Salsa"
        ],
        "pasos":
        "Asa el pollo en sartén\n"
            "Córtalo en tiras\n"
            "Calienta tortillas\n"
            "Arma los tacos con cebolla y cilantro\n"
            "Agrega salsa\n"
            "Sirve caliente",
        "cal": 320
      },

      {
        "nombre": "🍗 Pollo a la plancha con verduras",
        "desc": "Comida completa",
        "ingredientes": [
          "Pechuga de pollo",
          "Brócoli",
          "Zanahoria",
          "Aceite"
        ],
        "pasos":
        "Cocina el pollo en sartén\n"
            "Saltea las verduras\n"
            "Sirve junto",
        "cal": 350
      },

      {
        "nombre": "🍝 Pasta integral con pollo",
        "desc": "Balance perfecto",
        "ingredientes": [
          "Pasta integral",
          "Pollo",
          "Salsa de tomate"
        ],
        "pasos":
        "Cuece la pasta\n"
            "Cocina el pollo\n"
            "Mezcla con salsa\n"
            "Sirve",
        "cal": 400
      },

      {
        "nombre": "🍔 Hamburguesa casera saludable",
        "desc": "Versión ligera",
        "ingredientes": [
          "Pan integral",
          "Carne magra",
          "Lechuga",
          "Tomate"
        ],
        "pasos":
        "Cocina la carne\n"
            "Arma la hamburguesa\n"
            "Sirve",
        "cal": 420
      },

      {
        "nombre": "🥗 Ensalada de pollo",
        "desc": "Ligera pero completa",
        "ingredientes": [
          "Lechuga",
          "Pollo",
          "Aguacate"
        ],
        "pasos":
        "Corta ingredientes\n"
            "Mezcla todo\n"
            "Sirve",
        "cal": 280
      },

      {
        "nombre": "🍛 Arroz con pollo",
        "desc": "Clásico",
        "ingredientes": [
          "Arroz",
          "Pollo",
          "Verduras"
        ],
        "pasos":
        "Cocina el arroz\n"
            "Agrega pollo\n"
            "Mezcla\n"
            "Sirve",
        "cal": 360
      },

      {
        "nombre": "🌯 Burrito saludable",
        "desc": "Completo",
        "ingredientes": [
          "Tortilla",
          "Pollo",
          "Frijoles",
          "Arroz"
        ],
        "pasos":
        "Calienta tortilla\n"
            "Agrega ingredientes\n"
            "Enrolla\n"
            "Sirve",
        "cal": 400
      },

      {
        "nombre": "🥘 Fajitas de pollo",
        "desc": "Sabor intenso",
        "ingredientes": [
          "Pollo",
          "Pimientos",
          "Cebolla"
        ],
        "pasos":
        "Saltea todo\n"
            "Sirve caliente",
        "cal": 330
      },

      {
        "nombre": "🍲 Sopa de pollo",
        "desc": "Reconfortante",
        "ingredientes": [
          "Pollo",
          "Verduras",
          "Agua"
        ],
        "pasos":
        "Hierve todo\n"
            "Cocina 20 min\n"
            "Sirve",
        "cal": 250
      },

      {
        "nombre": "🥩 Carne asada con ensalada",
        "desc": "Clásico saludable",
        "ingredientes": [
          "Carne magra",
          "Ensalada"
        ],
        "pasos":
        "Asa carne\n"
            "Sirve con ensalada",
        "cal": 420
      },
    ],

    // ================= ALMUERZO =================
    "🍲 Almuerzo": [
      {
        "nombre": "🥗 Ensalada de atún",
        "desc": "Rápida y nutritiva",
        "ingredientes": [
          "Atún",
          "Lechuga",
          "Tomate"
        ],
        "pasos":
        "Mezcla todo\n"
            "Sirve",
        "cal": 220
      },

      {
        "nombre": "🥪 Wrap de pollo",
        "desc": "Ligero",
        "ingredientes": [
          "Tortilla",
          "Pollo",
          "Lechuga"
        ],
        "pasos":
        "Arma wrap\n"
            "Sirve",
        "cal": 250
      },

      {
        "nombre": "🍜 Sopa ligera de verduras",
        "desc": "Baja en calorías",
        "ingredientes": [
          "Verduras",
          "Agua"
        ],
        "pasos":
        "Hierve verduras\n"
            "Sirve",
        "cal": 120
      },

      {
        "nombre": "🥗 Ensalada de quinoa",
        "desc": "Muy nutritiva",
        "ingredientes": [
          "Quinoa",
          "Verduras"
        ],
        "pasos":
        "Cocina quinoa\n"
            "Mezcla\n"
            "Sirve",
        "cal": 260
      },

      {
        "nombre": "🍞 Sándwich de atún",
        "desc": "Práctico",
        "ingredientes": [
          "Pan",
          "Atún"
        ],
        "pasos":
        "Arma\n"
            "Sirve",
        "cal": 270
      },

      {
        "nombre": "🥗 Ensalada César ligera",
        "desc": "Clásica versión fit",
        "ingredientes": [
          "Lechuga",
          "Pollo",
          "Aderezo ligero"
        ],
        "pasos":
        "Mezcla todo\n"
            "Sirve",
        "cal": 300
      },

      {
        "nombre": "🍲 Caldo de verduras",
        "desc": "Muy ligero",
        "ingredientes": [
          "Verduras",
          "Agua"
        ],
        "pasos":
        "Hierve\n"
            "Sirve",
        "cal": 130
      },

      {
        "nombre": "🥪 Sándwich vegetariano",
        "desc": "Sin carne",
        "ingredientes": [
          "Pan",
          "Verduras"
        ],
        "pasos":
        "Arma\n"
            "Sirve",
        "cal": 230
      },

      {
        "nombre": "🥗 Bowl saludable",
        "desc": "Completo",
        "ingredientes": [
          "Arroz",
          "Pollo",
          "Verduras"
        ],
        "pasos":
        "Mezcla\n"
            "Sirve",
        "cal": 320
      },

      {
        "nombre": "🍳 Huevos cocidos con ensalada",
        "desc": "Simple",
        "ingredientes": [
          "Huevos",
          "Ensalada"
        ],
        "pasos":
        "Cuece huevos\n"
            "Sirve",
        "cal": 200
      },
    ],

    // ================= SNACKS =================
    "🥑 Snacks": [
      {
        "nombre": "🍏 Ensalada de manzana con crema",
        "desc": "Dulce y cremosa",
        "ingredientes": [
          "Manzana",
          "Lechera",
          "Nuez"
        ],
        "pasos":
        "Corta la manzana\n"
            "Mezcla con lechera\n"
            "Agrega nuez\n"
            "Sirve",
        "cal": 280
      },

      {
        "nombre": "🍫 Plátano con chocolate",
        "desc": "Snack dulce",
        "ingredientes": [
          "Plátano",
          "Chocolate"
        ],
        "pasos":
        "Derrite chocolate\n"
            "Baña el plátano\n"
            "Sirve",
        "cal": 250
      },

      {
        "nombre": "🥜 Mix de nueces",
        "desc": "Energía rápida",
        "ingredientes": [
          "Nueces",
          "Almendras"
        ],
        "pasos":
        "Mezcla\n"
            "Consume",
        "cal": 300
      },

      {
        "nombre": "🍓 Fresas con yogur",
        "desc": "Fresco",
        "ingredientes": [
          "Fresas",
          "Yogur"
        ],
        "pasos":
        "Mezcla\n"
            "Sirve",
        "cal": 180
      },

      {
        "nombre": "🍿 Palomitas caseras",
        "desc": "Ligero",
        "ingredientes": [
          "Maíz palomero"
        ],
        "pasos":
        "Haz palomitas\n"
            "Sirve",
        "cal": 150
      },

      {
        "nombre": "🍪 Galletas de avena",
        "desc": "Caseras",
        "ingredientes": [
          "Avena",
          "Plátano"
        ],
        "pasos":
        "Mezcla\n"
            "Hornea\n"
            "Sirve",
        "cal": 200
      },

      {
        "nombre": "🥤 Smoothie de mango",
        "desc": "Refrescante",
        "ingredientes": [
          "Mango",
          "Leche"
        ],
        "pasos":
        "Licúa\n"
            "Sirve",
        "cal": 220
      },

      {
        "nombre": "🍯 Yogur con miel",
        "desc": "Simple",
        "ingredientes": [
          "Yogur",
          "Miel"
        ],
        "pasos":
        "Mezcla\n"
            "Sirve",
        "cal": 170
      },

      {
        "nombre": "🍫 Barra energética",
        "desc": "Para energía",
        "ingredientes": [
          "Avena",
          "Miel"
        ],
        "pasos":
        "Mezcla\n"
            "Refrigera\n"
            "Sirve",
        "cal": 240
      },

      {
        "nombre": "🥑 Guacamole con tostadas",
        "desc": "Mexicano",
        "ingredientes": [
          "Aguacate",
          "Tostadas"
        ],
        "pasos":
        "Machaca aguacate\n"
            "Sirve con tostadas",
        "cal": 260
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recetas")),

      body: ListView(
        children: categorias.entries.map((categoria) {

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  categoria.key,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),

              ...categoria.value.map((r) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                  child: ListTile(
                    title: Text(r["nombre"]),
                    subtitle: Text(r["desc"]),
                    trailing: const Icon(Icons.arrow_forward_ios),

                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RecetaDetalle(receta: r),
                        ),
                      );
                    },
                  ),
                );
              })
            ],
          );
        }).toList(),
      ),
    );
  }
}
