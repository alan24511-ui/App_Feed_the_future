import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> guardarUsuario({
    required String nombre,
    required double imc,
  }) async {

    final user = _auth.currentUser;

    if (user == null) return;

    await db.collection('usuarios').doc(user.uid).set({
      'nombre': nombre,
      'imc': imc,
      'correo': user.email,
    });
  }

  Future<Map<String, dynamic>?> obtenerUsuario() async {
    final user = _auth.currentUser;

    if (user == null) return null;

    final doc = await db.collection('usuarios').doc(user.uid).get();

    return doc.data();
  }
}