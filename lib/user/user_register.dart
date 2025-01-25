import 'package:flutter/material.dart';
import 'package:pix_wall/bottom_nav.dart';
import 'package:pix_wall/services/auth_service.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: const Color.fromARGB(255, 14, 14, 14),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Register',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'BeVietnamPro',
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(238, 255, 255, 255),
      body: Container(
        child: Stack(
          children: [
            _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 30.0),
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(height: 50.0),
                    _buildUsernameField(),
                    SizedBox(height: 20.0),
                    _buildEmailField(),
                    SizedBox(height: 30.0),
                    _buildPasswordField(),
                    SizedBox(height: 40.0),
                    _buildRegisterButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      controller: usernameController,
      hint: 'Username',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Username';
        }
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      controller: userPasswordController,
      hint: 'Password',
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Password';
        }
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: emailController,
      hint: 'Email',
      validator: (value) {
        if (value == null || value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
      },
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      bool obscureText = false,
      String? Function(String?)? validator}) {
    return Container(
      padding: EdgeInsets.only(left: 20.0, bottom: 5.0, top: 5.0),
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(255, 160, 160, 147)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(color: Color.fromARGB(255, 160, 160, 147)),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: registerUser,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(12.0)),
        child: Center(
          child: Text(
            'Register',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        bool isSuccess = await authService.registerUser(
            usernameController.text.trim(),
            userPasswordController.text.trim(),
            emailController.text.trim());
        if (isSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BottomNav()), // Asegúrate de tener esta página
          );
        } else {
          _showErrorSnackBar('Registration failed');
        }
      } catch (e) {
        _showErrorSnackBar('An error occurred: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          message,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
