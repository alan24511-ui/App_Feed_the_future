import 'package:flutter/material.dart';
import 'login.dart';

class IntroCardsScreen extends StatefulWidget {
  @override
  _IntroCardsScreenState createState() => _IntroCardsScreenState();
}

class _IntroCardsScreenState extends State<IntroCardsScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  final List<Map<String, dynamic>> cards = [
    {
      "icon": Icons.fastfood,
      "title": "Registra tu comida",
      "desc": "Lleva un control preciso de lo que consumes día a día."
    },
    {
      "icon": Icons.health_and_safety,
      "title": "Conoce tu IMC",
      "desc": "Calcula tu estado físico fácilmente."
    },
    {
      "icon": Icons.pets,
      "title": "Cuida tu mascota",
      "desc": "Motívate registrando tus alimentos."
    },
  ];

  void siguiente() {
    if (currentPage < cards.length - 1) {
      controller.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: cards.length,
                onPageChanged: (i) {
                  setState(() => currentPage = i);
                },

                itemBuilder: (_, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cards[i]["icon"],
                          size: 120, color: Colors.green),

                      SizedBox(height: 30),

                      Text(
                        cards[i]["title"],
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),

                      SizedBox(height: 10),

                      Text(
                        cards[i]["desc"],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  );
                },
              ),
            ),

            // INDICADOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(cards.length, (i) {
                return Container(
                  margin: EdgeInsets.all(4),
                  width: currentPage == i ? 12 : 8,
                  height: currentPage == i ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == i
                        ? Colors.green
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            SizedBox(height: 20),

            // BOTÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: siguiente,
                child: Text(
                  currentPage == cards.length - 1
                      ? "Comenzar"
                      : "Siguiente",
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}