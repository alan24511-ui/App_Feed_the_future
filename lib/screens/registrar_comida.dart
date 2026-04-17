import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/comida_model.dart';

class RegistrarComida extends StatefulWidget {
  const RegistrarComida({super.key});

  @override
  State<RegistrarComida> createState() => _RegistrarComidaState();
}

class _RegistrarComidaState extends State<RegistrarComida> {

  // ---------------- LISTA DE COMIDAS ----------------
  final List<Map<String, dynamic>> comidas = [
    {"nombre": "🌮 Tacos al pastor", "desc": "Clásico mexicano", "cal": 180, "carbs": 20, "prot": 10, "gras": 8},
    {"nombre": "🌯 Burrito", "desc": "Grande y completo", "cal": 300, "carbs": 35, "prot": 15, "gras": 12},
    {"nombre": "🫔 Tamal", "desc": "Tradicional mexicano", "cal": 250, "carbs": 30, "prot": 8, "gras": 10},
    {"nombre": "🍲 Pozole", "desc": "Caldo típico", "cal": 220, "carbs": 18, "prot": 15, "gras": 9},
    {"nombre": "🍛 Mole con pollo", "desc": "Sabor intenso", "cal": 350, "carbs": 25, "prot": 20, "gras": 18},
    {"nombre": "🫓 Quesadilla", "desc": "Con queso", "cal": 200, "carbs": 22, "prot": 9, "gras": 10},
    {"nombre": "🥙 Gordita", "desc": "Rellena", "cal": 270, "carbs": 30, "prot": 10, "gras": 12},
    {"nombre": "🍳 Huevos rancheros", "desc": "Desayuno mexicano", "cal": 280, "carbs": 20, "prot": 14, "gras": 15},
    {"nombre": "🍲 Menudo", "desc": "Caldo tradicional", "cal": 200, "carbs": 10, "prot": 18, "gras": 10},
    {"nombre": "🥘 Chilaquiles", "desc": "Con salsa", "cal": 300, "carbs": 35, "prot": 12, "gras": 14},

    {"nombre": "🍗 Pechuga de pollo", "desc": "Alta proteína", "cal": 165, "carbs": 0, "prot": 31, "gras": 3.6},
    {"nombre": "🥩 Carne asada", "desc": "Rica en proteína", "cal": 250, "carbs": 0, "prot": 26, "gras": 15},
    {"nombre": "🍖 Costillas BBQ", "desc": "Jugosas", "cal": 320, "carbs": 10, "prot": 20, "gras": 25},
    {"nombre": "🍔 Hamburguesa", "desc": "Comida rápida", "cal": 295, "carbs": 30, "prot": 17, "gras": 12},
    {"nombre": "🍕 Pizza", "desc": "Clásica", "cal": 266, "carbs": 33, "prot": 11, "gras": 10},

    {"nombre": "🍚 Arroz", "desc": "Fuente de energía", "cal": 130, "carbs": 28, "prot": 2.7, "gras": 0.3},
    {"nombre": "🍝 Pasta", "desc": "Energía", "cal": 158, "carbs": 31, "prot": 6, "gras": 1},
    {"nombre": "🥔 Papas fritas", "desc": "Crujientes", "cal": 312, "carbs": 41, "prot": 3, "gras": 15},

    {"nombre": "🥗 Ensalada", "desc": "Ligera", "cal": 80, "carbs": 10, "prot": 3, "gras": 2},
    {"nombre": "🥑 Aguacate", "desc": "Grasas saludables", "cal": 160, "carbs": 9, "prot": 2, "gras": 15},
    {"nombre": "🍎 Manzana", "desc": "Fibra", "cal": 52, "carbs": 14, "prot": 0.3, "gras": 0.2},

    {"nombre": "🥪 Sandwich", "desc": "Rápido", "cal": 250, "carbs": 30, "prot": 12, "gras": 8},
    {"nombre": "🌭 Hot Dog", "desc": "Clásico", "cal": 290, "carbs": 28, "prot": 10, "gras": 18},
    {"nombre": "🍗 Nuggets", "desc": "Pollo empanizado", "cal": 280, "carbs": 18, "prot": 15, "gras": 18},

    {"nombre": "🍣 Sushi", "desc": "Comida japonesa", "cal": 200, "carbs": 30, "prot": 10, "gras": 5},
    {"nombre": "🥟 Dumplings", "desc": "Rellenos", "cal": 230, "carbs": 25, "prot": 10, "gras": 9},
    {"nombre": "🍜 Ramen", "desc": "Sopa asiática", "cal": 350, "carbs": 45, "prot": 15, "gras": 12},

    {"nombre": "🍩 Dona", "desc": "Dulce", "cal": 260, "carbs": 30, "prot": 4, "gras": 14},
    {"nombre": "🍫 Chocolate", "desc": "Postre", "cal": 210, "carbs": 25, "prot": 2, "gras": 12},
    {"nombre": "🍰 Pastel", "desc": "Dulce", "cal": 320, "carbs": 40, "prot": 5, "gras": 15},
  ];

  final List<Map<String, dynamic>> acompanantes = [
    {"nombre": "🥑 Aguacate", "cal": 160},
    {"nombre": "🥗 Ensalada extra", "cal": 33},
    {"nombre": "🍞 Pan", "cal": 69},
    {"nombre": "🧀 Queso", "cal": 120},
    {"nombre": "🍟 Papas", "cal": 220},
  ];

  final List<Map<String, dynamic>> bebidas = [
    {"nombre": "💧 Agua", "cal": 0},
    {"nombre": "🥤 Refresco", "cal": 150},
    {"nombre": "☕ Café", "cal": 5},
    {"nombre": "🥛 Leche", "cal": 120},
    {"nombre": "🧃 Jugo", "cal": 110},
  ];

  Map<String, dynamic>? comidaSeleccionada;

  int gramos = 100;
  int porciones = 1;
  String tipoComida = "Comida";
  String? bebidaSeleccionada;
  List<String> acompanantesSeleccionados = [];

  final List<String> tipos = ["Desayuno", "Comida", "Cena"];

  final TextEditingController notas = TextEditingController();

  double calcularCalorias() {
    if (comidaSeleccionada == null) return 0;

    double base = comidaSeleccionada!["cal"] * (gramos / 100) * porciones;

    double extra = 0;

    for (var a in acompanantesSeleccionados) {
      var data = acompanantes.firstWhere((e) => e["nombre"] == a);
      extra += data["cal"];
    }

    if (bebidaSeleccionada != null) {
      var bebida = bebidas.firstWhere((b) => b["nombre"] == bebidaSeleccionada);
      extra += bebida["cal"];
    }

    return base + extra;
  }

  void abrirDetalle(Map<String, dynamic> comida) {
    setState(() {
      comidaSeleccionada = comida;
      gramos = 100;
      porciones = 1;
      bebidaSeleccionada = null;
      acompanantesSeleccionados.clear();
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => detalleComida(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar comida")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: comidas.length,
        itemBuilder: (_, i) {
          var comida = comidas[i];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              title: Text(comida["nombre"]),
              subtitle: Text(comida["desc"]),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => abrirDetalle(comida),
            ),
          );
        },
      ),
    );
  }

  Widget detalleComida() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        double total = calcularCalorias();

        return Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    comidaSeleccionada!["nombre"],
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  DropdownButton<String>(
                    value: tipoComida,
                    items: tipos
                        .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) =>
                        setModalState(() => tipoComida = v!),
                  ),

                  const SizedBox(height: 20),

                  const Text("Cantidad en gramos"),
                  Slider(
                    value: gramos.toDouble(),
                    min: 50,
                    max: 500,
                    divisions: 9,
                    label: "$gramos g",
                    onChanged: (v) =>
                        setModalState(() => gramos = v.toInt()),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: porciones > 1
                            ? () => setModalState(() => porciones--)
                            : null,
                        icon: const Icon(Icons.remove_circle),
                      ),
                      Text("$porciones",
                          style: const TextStyle(fontSize: 18)),
                      IconButton(
                        onPressed: () =>
                            setModalState(() => porciones++),
                        icon: const Icon(Icons.add_circle),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text("Acompañantes"),

                  Wrap(
                    spacing: 8,
                    children: acompanantes.map((a) {
                      bool selected =
                      acompanantesSeleccionados.contains(a["nombre"]);

                      return FilterChip(
                        label: Text(a["nombre"]),
                        selected: selected,
                        onSelected: (v) {
                          setModalState(() {
                            if (v) {
                              acompanantesSeleccionados.add(a["nombre"]);
                            } else {
                              acompanantesSeleccionados.remove(a["nombre"]);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  const Text("Bebida"),

                  DropdownButton<String>(
                    value: bebidaSeleccionada,
                    hint: const Text("Seleccionar bebida"),
                    items: bebidas.map((b) {
                      return DropdownMenuItem<String>(
                        value: b["nombre"] as String,
                        child: Text(b["nombre"] as String),
                      );
                    }).toList(),
                    onChanged: (v) =>
                        setModalState(() => bebidaSeleccionada = v),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: notas,
                    decoration: const InputDecoration(
                      labelText: "Notas",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Calorías totales",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${total.toStringAsFixed(1)} kcal",
                              style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        DatabaseService.agregarComida(
                          ComidaModel(
                            nombre: comidaSeleccionada!["nombre"],
                            calorias: total,
                            tipo: tipoComida,
                            fecha: DateTime.now(),
                          ),
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Comida guardada correctamente")),
                        );
                      },
                      child: const Text("Guardar comida"),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}