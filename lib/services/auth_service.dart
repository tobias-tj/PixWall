import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  Future<bool> loginAdmin(String username, String password) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("Admin").get();
      for (var result in snapshot.docs) {
        if (result.data()['id'] == username &&
            result.data()['password'] == password) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Login de usuario no administrador
  Future<bool> loginUser(String username, String password) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("Users").get();
      for (var result in snapshot.docs) {
        if (result.data()['id'] == username &&
            result.data()['password'] == password) {
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Registrar un nuevo usuario
  Future<bool> registerUser(
      String username, String password, String email) async {
    try {
      await FirebaseFirestore.instance.collection("Users").add({
        'id': username,
        'password': password,
        'email': email,
        'role': 'user', // Se asigna el rol 'user' a los nuevos registros
      });
      return true;
    } catch (e) {
      throw Exception('Error during registration: $e');
    }
  }
}
