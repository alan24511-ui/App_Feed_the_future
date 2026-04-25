import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MetaScreen extends StatefulWidget {
  const MetaScreen({super.key});

  @override
  State<MetaScreen> createState() => _MetaScreenState();
}

class _MetaScreenState extends State<MetaScreen> {

  final controller = TextEditingController();

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    cargarMeta();
  }

  Future<void> cargarMeta() async {
    final doc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    if (doc.exists) {
      controller.text =
          (doc.data()?['meta'] ?? 2000).toString();
    }
  }

  Future<void> guardarMeta() async {
    double meta = double.tryParse(controller.text) ?? 2000;

    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .set({
      'meta': meta,
    }, SetOptions(merge: true));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Meta diaria")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Calorías objetivo",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: guardarMeta,
              child: const Text("Guardar"),
            )
          ],
        ),
      ),
    );
  }
}