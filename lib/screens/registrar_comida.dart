import 'package:flutter/material.dart';

class RegistrarComida extends StatefulWidget {
  const RegistrarComida({super.key});

  @override
  State<RegistrarComida> createState() => _RegistrarComidaState();
}

class _RegistrarComidaState extends State<RegistrarComida> {

  // ---------------- LISTA DE COMIDAS ----------------
  final List<Map<String, dynamic>> comidas = [
    {"nombre": "🍎 Manzana", "desc": "Fibra y vitaminas", "cal": 52, "carbs": 14, "prot": 0.3, "gras": 0.2},
    {"nombre": "🍗 Pechuga de pollo", "desc": "Alta proteína", "cal": 165, "carbs": 0, "prot": 31, "gras": 3.6},
    {"nombre": "🍚 Arroz", "desc": "Fuente de energía", "cal": 130, "carbs": 28, "prot": 2.7, "gras": 0.3},
    {"nombre": "🍕 Pizza", "desc": "Comida rápida", "cal": 266, "carbs": 33, "prot": 11, "gras": 10},
    {"nombre": "🍔 Hamburguesa", "desc": "Alta en calorías", "cal": 295, "carbs": 30, "prot": 17, "gras": 12},
    {"nombre": "🥗 Ensalada", "desc": "Ligera y saludable", "cal": 80, "carbs": 10, "prot": 3, "gras": 2},
    {"nombre": "🍝 Pasta", "desc": "Energía para el día", "cal": 158, "carbs": 31, "prot": 6, "gras": 1},
    {"nombre": "🌮 Taco", "desc": "Popular en México", "cal": 120, "carbs": 15, "prot": 8, "gras": 5},
    {"nombre": "🥪 Sandwich", "desc": "Comida rápida", "cal": 250, "carbs": 30, "prot": 12, "gras": 8},
    {"nombre": "🍳 Huevo", "desc": "Proteína natural", "cal": 155, "carbs": 1.1, "prot": 13, "gras": 11},
  ];

  // ---------------- ACOMPAÑANTES ----------------
  final List<Map<String, dynamic>> acompanantes = [
    {"nombre": "🥑 Aguacate", "cal": 160},
    {"nombre": "🥗 Ensalada extra", "cal": 33},
    {"nombre": "🍞 Pan", "cal": 69},
    {"nombre": "🧀 Queso", "cal": 120},
    {"nombre": "🍟 Papas", "cal": 220},
  ];

  // ---------------- BEBIDAS ----------------
  final List<Map<String, dynamic>> bebidas = [
    {"nombre": "💧 Agua", "cal": 0},
    {"nombre": "🥤 Refresco", "cal": 150},
    {"nombre": "☕ Café", "cal": 5},
    {"nombre": "🥛 Leche", "cal": 120},
    {"nombre": "🧃 Jugo", "cal": 110},
  ];

  // ---------------- ESTADOS ----------------
  Map<String, dynamic>? comidaSeleccionada;

  int gramos = 100;
  int porciones = 1;
  String tipoComida = "Comida";
  String? bebidaSeleccionada;
  List<String> acompanantesSeleccionados = [];

  final List<String> tipos = ["Desayuno", "Comida", "Cena"];

  final TextEditingController notas = TextEditingController();

  // ---------------- CALCULOS ----------------
  double calcularCalorias() {
    if (comidaSeleccionada == null) return 0;

    double base = comidaSeleccionada!["cal"] * (gramos / 100) * porciones;

    double extra = 0;

    for (var a in acompanantesSeleccionados) {
      var data = acompanantes.firstWhere((e) => e["nombre"] == a);
      extra += data["cal"];
    }

    if (bebidaSeleccionada != null) {
      var bebida =
      bebidas.firstWhere((b) => b["nombre"] == bebidaSeleccionada);
      extra += bebida["cal"];
    }

    return base + extra;
  }

  // ---------------- NAVEGAR A DETALLE ----------------
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
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (_) => detalleComida(),
    );
  }

  // ---------------- UI PRINCIPAL ----------------
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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

  // ---------------- DETALLE COMPLETO ----------------
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
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    comidaSeleccionada!["nombre"],
                    style: const TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  // TIPO COMIDA
                  DropdownButton<String>(
                    value: tipoComida,
                    items: tipos
                        .map((t) =>
                        DropdownMenuItem(value: t, child: Text(t)))
                        .toList(),
                    onChanged: (v) =>
                        setModalState(() => tipoComida = v!),
                  ),

                  const SizedBox(height: 20),

                  // GRAMOS
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

                  // PORCIONES
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
                    onChanged: (v) => setState(() => bebidaSeleccionada = v),
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
                              style:
                              TextStyle(fontWeight: FontWeight.bold)),
                          Text("${total.toStringAsFixed(1)} kcal",
                              style:
                              const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Comida registrada")),
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