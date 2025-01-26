import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static const _roleKey = 'user_role';
  static const _isLoggedInKey = 'is_logged_in';

  // Login del administrador
  Future<bool> loginAdmin(String username, String password) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("Admin").get();
      for (var result in snapshot.docs) {
        if (result.data()['id'] == username &&
            result.data()['password'] == password) {
          // Guardar la sesión en localStorage
          await _saveSession('admin');
          return true;
        }
      }
      return false;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }

  // Login del usuario
  Future<bool> loginUser(String username, String password) async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection("Users").get();
      for (var result in snapshot.docs) {
        if (result.data()['id'] == username &&
            result.data()['password'] == password) {
          // Guardar la sesión en localStorage
          await _saveSession('user');
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

  // Cerrar sesión
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Verificar si el usuario está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Obtener el rol del usuario
  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Guardar la sesión en el almacenamiento local
  Future<void> _saveSession(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
    await prefs.setBool(_isLoggedInKey, true);
  }
}
