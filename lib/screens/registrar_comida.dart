import 'package:flutter/material.dart';
import '../services/database_service.dart';
import '../models/comida_model.dart';
import '../l10n/app_localizations.dart';

class RegistrarComida extends StatefulWidget {
  const RegistrarComida({super.key});

  @override
  State<RegistrarComida> createState() => _RegistrarComidaState();
}

class _RegistrarComidaState extends State<RegistrarComida> {

  // ---------------- COMIDAS ----------------

  final List<Map<String, dynamic>> comidas = [

    {
      "nombre": "tacos_pastor",
      "desc": "clasico_mexicano",
      "emoji": "🌮",
      "cal": 180,
      "carbs": 20,
      "prot": 10,
      "gras": 8
    },

    {
      "nombre": "burrito",
      "desc": "grande_completo",
      "emoji": "🌯",
      "cal": 300,
      "carbs": 35,
      "prot": 15,
      "gras": 12
    },

    {
      "nombre": "tamal",
      "desc": "tradicional_mexicano",
      "emoji": "🫔",
      "cal": 250,
      "carbs": 30,
      "prot": 8,
      "gras": 10
    },

    {
      "nombre": "pozole",
      "desc": "caldo_tipico",
      "emoji": "🍲",
      "cal": 220,
      "carbs": 18,
      "prot": 15,
      "gras": 9
    },

    {
      "nombre": "mole_pollo",
      "desc": "sabor_intenso",
      "emoji": "🍛",
      "cal": 350,
      "carbs": 25,
      "prot": 20,
      "gras": 18
    },

    {
      "nombre": "quesadilla",
      "desc": "con_queso",
      "emoji": "🫓",
      "cal": 200,
      "carbs": 22,
      "prot": 9,
      "gras": 10
    },

    {
      "nombre": "gordita",
      "desc": "rellena",
      "emoji": "🥙",
      "cal": 270,
      "carbs": 30,
      "prot": 10,
      "gras": 12
    },

    {
      "nombre": "huevos_rancheros",
      "desc": "desayuno_mexicano",
      "emoji": "🍳",
      "cal": 280,
      "carbs": 20,
      "prot": 14,
      "gras": 15
    },

    {
      "nombre": "menudo",
      "desc": "caldo_tradicional",
      "emoji": "🍲",
      "cal": 200,
      "carbs": 10,
      "prot": 18,
      "gras": 10
    },

    {
      "nombre": "chilaquiles",
      "desc": "con_salsa",
      "emoji": "🥘",
      "cal": 300,
      "carbs": 35,
      "prot": 12,
      "gras": 14
    },

    {
      "nombre": "pechuga_pollo",
      "desc": "alta_proteina",
      "emoji": "🍗",
      "cal": 165,
      "carbs": 0,
      "prot": 31,
      "gras": 3.6
    },

    {
      "nombre": "carne_asada",
      "desc": "rica_proteina",
      "emoji": "🥩",
      "cal": 250,
      "carbs": 0,
      "prot": 26,
      "gras": 15
    },

    {
      "nombre": "costillas_bbq",
      "desc": "jugosas",
      "emoji": "🍖",
      "cal": 320,
      "carbs": 10,
      "prot": 20,
      "gras": 25
    },

    {
      "nombre": "hamburguesa",
      "desc": "comida_rapida",
      "emoji": "🍔",
      "cal": 295,
      "carbs": 30,
      "prot": 17,
      "gras": 12
    },

    {
      "nombre": "pizza",
      "desc": "clasica",
      "emoji": "🍕",
      "cal": 266,
      "carbs": 33,
      "prot": 11,
      "gras": 10
    },

    {
      "nombre": "arroz",
      "desc": "fuente_energia",
      "emoji": "🍚",
      "cal": 130,
      "carbs": 28,
      "prot": 2.7,
      "gras": 0.3
    },

    {
      "nombre": "pasta",
      "desc": "energia",
      "emoji": "🍝",
      "cal": 158,
      "carbs": 31,
      "prot": 6,
      "gras": 1
    },

    {
      "nombre": "papas_fritas",
      "desc": "crujientes",
      "emoji": "🥔",
      "cal": 312,
      "carbs": 41,
      "prot": 3,
      "gras": 15
    },

    {
      "nombre": "ensalada",
      "desc": "ligera",
      "emoji": "🥗",
      "cal": 80,
      "carbs": 10,
      "prot": 3,
      "gras": 2
    },

    {
      "nombre": "aguacate",
      "desc": "grasas_saludables",
      "emoji": "🥑",
      "cal": 160,
      "carbs": 9,
      "prot": 2,
      "gras": 15
    },

    {
      "nombre": "manzana",
      "desc": "fibra",
      "emoji": "🍎",
      "cal": 52,
      "carbs": 14,
      "prot": 0.3,
      "gras": 0.2
    },

    {
      "nombre": "sandwich",
      "desc": "rapido",
      "emoji": "🥪",
      "cal": 250,
      "carbs": 30,
      "prot": 12,
      "gras": 8
    },

    {
      "nombre": "hotdog",
      "desc": "clasico",
      "emoji": "🌭",
      "cal": 290,
      "carbs": 28,
      "prot": 10,
      "gras": 18
    },

    {
      "nombre": "nuggets",
      "desc": "pollo_empanizado",
      "emoji": "🍗",
      "cal": 280,
      "carbs": 18,
      "prot": 15,
      "gras": 18
    },

    {
      "nombre": "sushi",
      "desc": "comida_japonesa",
      "emoji": "🍣",
      "cal": 200,
      "carbs": 30,
      "prot": 10,
      "gras": 5
    },

    {
      "nombre": "dumplings",
      "desc": "rellenos",
      "emoji": "🥟",
      "cal": 230,
      "carbs": 25,
      "prot": 10,
      "gras": 9
    },

    {
      "nombre": "ramen",
      "desc": "sopa_asiatica",
      "emoji": "🍜",
      "cal": 350,
      "carbs": 45,
      "prot": 15,
      "gras": 12
    },

    {
      "nombre": "dona",
      "desc": "dulce",
      "emoji": "🍩",
      "cal": 260,
      "carbs": 30,
      "prot": 4,
      "gras": 14
    },

    {
      "nombre": "chocolate",
      "desc": "postre",
      "emoji": "🍫",
      "cal": 210,
      "carbs": 25,
      "prot": 2,
      "gras": 12
    },

    {
      "nombre": "pastel",
      "desc": "dulce",
      "emoji": "🍰",
      "cal": 320,
      "carbs": 40,
      "prot": 5,
      "gras": 15
    },
  ];

  final List<Map<String, dynamic>> acompanantes = [
    {"nombre": "aguacate", "emoji": "🥑", "cal": 160},
    {"nombre": "ensalada_extra", "emoji": "🥗", "cal": 33},
    {"nombre": "pan", "emoji": "🍞", "cal": 69},
    {"nombre": "queso", "emoji": "🧀", "cal": 120},
    {"nombre": "papas", "emoji": "🍟", "cal": 220},
  ];

  final List<Map<String, dynamic>> bebidas = [
    {"nombre": "agua", "emoji": "💧", "cal": 0},
    {"nombre": "refresco", "emoji": "🥤", "cal": 150},
    {"nombre": "cafe", "emoji": "☕", "cal": 5},
    {"nombre": "leche", "emoji": "🥛", "cal": 120},
    {"nombre": "jugo", "emoji": "🧃", "cal": 110},
  ];

  Map<String, dynamic>? comidaSeleccionada;

  int gramos = 100;
  int porciones = 1;
  String tipoComida = "comida";

  String? bebidaSeleccionada;
  List<String> acompanantesSeleccionados = [];

  final List<String> tipos = [
    "desayuno",
    "comida",
    "cena"
  ];

  final TextEditingController notas = TextEditingController();

  String traducirTexto(AppLocalizations t, String key) {
    switch (key) {

      case "tacos_pastor":
        return t.tacosPastor;

      case "clasico_mexicano":
        return t.clasicoMexicano;

      case "burrito":
        return t.burrito;

      case "grande_completo":
        return t.grandeCompleto;

      case "tamal":
        return t.tamal;

      case "tradicional_mexicano":
        return t.tradicionalMexicano;

      case "pozole":
        return t.pozole;

      case "caldo_tipico":
        return t.caldoTipico;

      case "mole_pollo":
        return t.molePollo;

      case "sabor_intenso":
        return t.saborIntenso;

      case "quesadilla":
        return t.quesadilla;

      case "con_queso":
        return t.conQueso;

      case "gordita":
        return t.gordita;

      case "rellena":
        return t.rellena;

      case "huevos_rancheros":
        return t.huevosRancheros;

      case "desayuno_mexicano":
        return t.desayunoMexicano;

      case "menudo":
        return t.menudo;

      case "caldo_tradicional":
        return t.caldoTradicional;

      case "chilaquiles":
        return t.chilaquiles;

      case "con_salsa":
        return t.conSalsa;

      case "pechuga_pollo":
        return t.pechugaPollo;

      case "alta_proteina":
        return t.altaProteina;

      case "carne_asada":
        return t.carneAsada;

      case "rica_proteina":
        return t.ricaProteina;

      case "costillas_bbq":
        return t.costillasBbq;

      case "jugosas":
        return t.jugosas;

      case "hamburguesa":
        return t.hamburguesa;

      case "comida_rapida":
        return t.comidaRapida;

      case "pizza":
        return t.pizza;

      case "clasica":
        return t.clasica;

      case "arroz":
        return t.arroz;

      case "fuente_energia":
        return t.fuenteEnergia;

      case "pasta":
        return t.pasta;

      case "energia":
        return t.energia;

      case "papas_fritas":
        return t.papasFritas;

      case "crujientes":
        return t.crujientes;

      case "ensalada":
        return t.ensalada;

      case "ligera":
        return t.ligera;

      case "aguacate":
        return t.aguacate;

      case "grasas_saludables":
        return t.grasasSaludables;

      case "manzana":
        return t.manzana;

      case "fibra":
        return t.fibra;

      case "sandwich":
        return t.sandwich;

      case "rapido":
        return t.rapido;

      case "hotdog":
        return t.hotdog;

      case "clasico":
        return t.clasico;

      case "nuggets":
        return t.nuggets;

      case "pollo_empanizado":
        return t.polloEmpanizado;

      case "sushi":
        return t.sushi;

      case "comida_japonesa":
        return t.comidaJaponesa;

      case "dumplings":
        return t.dumplings;

      case "rellenos":
        return t.rellenos;

      case "ramen":
        return t.ramen;

      case "sopa_asiatica":
        return t.sopaAsiatica;

      case "dona":
        return t.dona;

      case "dulce":
        return t.dulce;

      case "chocolate":
        return t.chocolate;

      case "postre":
        return t.postre;

      case "pastel":
        return t.pastel;

      case "ensalada_extra":
        return t.ensaladaExtra;

      case "pan":
        return t.pan;

      case "queso":
        return t.queso;

      case "papas":
        return t.papas;

      case "agua":
        return t.agua;

      case "refresco":
        return t.refresco;

      case "cafe":
        return t.cafe;

      case "leche":
        return t.leche;

      case "jugo":
        return t.jugo;

      case "desayuno":
        return t.desayuno;

      case "comida":
        return t.comida;

      case "cena":
        return t.cena;

      default:
        return key;
    }
  }

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
      var bebida = bebidas.firstWhere((b) => b["nombre"] == bebidaSeleccionada);
      extra += bebida["cal"];
    }

    return base + extra;
  }

  double calcularProteinas() {
    if (comidaSeleccionada == null) return 0;

    return (comidaSeleccionada!["prot"] ?? 0) *
        (gramos / 100) *
        porciones;
  }

  double calcularCarbs() {
    if (comidaSeleccionada == null) return 0;

    return (comidaSeleccionada!["carbs"] ?? 0) *
        (gramos / 100) *
        porciones;
  }

  double calcularGrasas() {
    if (comidaSeleccionada == null) return 0;

    return (comidaSeleccionada!["gras"] ?? 0) *
        (gramos / 100) *
        porciones;
  }

  // ---------------- UI ----------------

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
      backgroundColor: Colors.transparent,
      builder: (_) => detalleComida(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : Colors.grey[100],

      appBar: AppBar(
        title: Text(t.registrarComida),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: comidas.length,
        itemBuilder: (_, i) {

          var comida = comidas[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    isDark ? 0.25 : 0.05,
                  ),
                  blurRadius: 10,
                )
              ],
            ),

            child: Card(
              elevation: 0,
              color: isDark
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: ListTile(
                contentPadding: const EdgeInsets.all(14),

                title: Text(
                  "${comida["emoji"]} ${traducirTexto(t, comida["nombre"])}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    traducirTexto(t, comida["desc"]),
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ),

                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isDark
                      ? Colors.white70
                      : Colors.black54,
                ),

                onTap: () => abrirDetalle(comida),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget detalleComida() {

    final t = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StatefulBuilder(
      builder: (context, setModalState) {

        double total = calcularCalorias();

        return Container(
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E1E1E)
                : Colors.white,

            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),

          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),

            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Center(
                      child: Container(
                        width: 60,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "${comidaSeleccionada!["emoji"]} ${traducirTexto(t, comidaSeleccionada!["nombre"])}",

                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      traducirTexto(t, comidaSeleccionada!["desc"]),

                      style: TextStyle(
                        color: isDark
                            ? Colors.white70
                            : Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 25),

                    DropdownButtonFormField<String>(
                      dropdownColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.white,

                      value: tipoComida,

                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),

                      decoration: InputDecoration(
                        labelText: t.tipoComida,

                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : Colors.black54,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      items: tipos.map((tipo) {

                        return DropdownMenuItem(
                          value: tipo,
                          child: Text(traducirTexto(t, tipo)),
                        );

                      }).toList(),

                      onChanged: (v) =>
                          setModalState(() => tipoComida = v!),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      "${t.cantidadGramos}: $gramos g",

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

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

                          icon: const Icon(
                            Icons.remove_circle,
                            size: 34,
                            color: Colors.red,
                          ),
                        ),

                        Text(
                          "$porciones",

                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),

                        IconButton(
                          onPressed: () =>
                              setModalState(() => porciones++),

                          icon: const Icon(
                            Icons.add_circle,
                            size: 34,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Text(
                      t.acompanantes,

                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: acompanantes.map((a) {

                        bool selected =
                        acompanantesSeleccionados.contains(a["nombre"]);

                        return FilterChip(
                          backgroundColor: isDark
                              ? const Color(0xFF2A2A2A)
                              : Colors.grey.shade200,

                          selectedColor: Colors.blue.withOpacity(0.25),

                          labelStyle: TextStyle(
                            color: isDark
                                ? Colors.white
                                : Colors.black,
                          ),

                          label: Text(
                            "${a["emoji"]} ${traducirTexto(t, a["nombre"])}",
                          ),

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

                    const SizedBox(height: 25),

                    DropdownButtonFormField<String>(
                      dropdownColor: isDark
                          ? const Color(0xFF2A2A2A)
                          : Colors.white,

                      value: bebidaSeleccionada,

                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),

                      decoration: InputDecoration(
                        labelText: t.bebida,

                        labelStyle: TextStyle(
                          color: isDark
                              ? Colors.white70
                              : Colors.black54,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      items: bebidas.map((b) {

                        return DropdownMenuItem<String>(
                          value: b["nombre"],

                          child: Text(
                            "${b["emoji"]} ${traducirTexto(t, b["nombre"])}",
                          ),
                        );

                      }).toList(),

                      onChanged: (v) =>
                          setModalState(() => bebidaSeleccionada = v),
                    ),

                    const SizedBox(height: 25),

                    Card(
                      elevation: 0,

                      color: isDark
                          ? Colors.blue.withOpacity(0.15)
                          : Colors.blue.withOpacity(0.08),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(18),

                        child: Column(
                          children: [

                            Text(
                              "🔥 ${total.toStringAsFixed(1)} kcal",

                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              "💪 ${calcularProteinas().toStringAsFixed(1)} g ${t.proteina}",

                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                            Text(
                              "🍞 ${calcularCarbs().toStringAsFixed(1)} g ${t.carbs}",

                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),

                            Text(
                              "🥑 ${calcularGrasas().toStringAsFixed(1)} g ${t.grasas}",

                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),

                        onPressed: () {

                          DatabaseService.agregarComida(
                            nombre: traducirTexto(
                              t,
                              comidaSeleccionada!["nombre"],
                            ),

                            calorias: calcularCalorias(),

                            proteinas: calcularProteinas(),

                            carbohidratos: calcularCarbs(),

                            grasas: calcularGrasas(),

                            tipo: traducirTexto(t, tipoComida),

                            fecha: DateTime.now(),
                          );

                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(t.comidaGuardada),
                            ),
                          );
                        },

                        child: Text(
                          t.guardarComida,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}