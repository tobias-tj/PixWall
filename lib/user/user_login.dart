import 'package:flutter/material.dart';
import 'package:pix_wall/admin/admin_login.dart';
import 'package:pix_wall/bottom_nav.dart';
import 'package:pix_wall/services/auth_service.dart';
import 'package:pix_wall/user/user_register.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'PixWall',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey, // Agregar el Form con la key
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("images/logoPixWall.png"),
                  SizedBox(height: 90),
                  _buildTextField(
                    controller: usernameController,
                    hint: 'Username',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showToast("Please enter your username.");
                        return 'Please Enter Username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  _buildTextField(
                    controller: userPasswordController,
                    hint: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _showToast("Please enter your password.");
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30.0),
                  _buildLoginButton(),
                  const SizedBox(height: 15.0),
                  _buildRegisterButton(),
                  const SizedBox(height: 10.0),
                  _buildAdminLoginText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 247, 247, 247),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      ),
    );
  }

  Widget _buildAdminLoginText() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminLogin()),
        );
      },
      child: Text(
        "Login as Admin",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserRegister()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            'Register New User',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: loginUser,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Validación
      try {
        bool isSuccess = await authService.loginUser(
          usernameController.text.trim(),
          userPasswordController.text.trim(),
        );
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BottomNav()),
          );
        } else {
          _showToast('Invalid username or password');
        }
      } catch (e) {
        _showToast('An error occurred: $e');
      }
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
