import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pix_wall/services/auth_service.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController userPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            context.go('/login');
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
      margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30.0),
            Material(
              elevation: 3.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 50.0),
                    _buildUsernameField(),
                    const SizedBox(height: 20.0),
                    _buildEmailField(),
                    const SizedBox(height: 30.0),
                    _buildPasswordField(),
                    const SizedBox(height: 40.0),
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
          return 'Please enter a username.';
        }
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: emailController,
      hint: 'Email',
      validator: (value) {
        final emailRegex =
            RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
        if (value == null || value.isEmpty) {
          return 'Please enter an email address.';
        } else if (!emailRegex.hasMatch(value)) {
          return 'Please enter a valid email address.';
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
        final passwordRegex = RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
        if (value == null || value.isEmpty) {
          return 'Please enter a password.';
        } else if (!passwordRegex.hasMatch(value)) {
          return 'Password must be at least 8 characters long, include one uppercase letter, one lowercase letter, one number, and one special character.';
        }
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0, top: 5.0),
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
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
            hintStyle:
                const TextStyle(color: Color.fromARGB(255, 160, 160, 147)),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: registerUser,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Center(
          child: Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Verificar si el username está disponible
        bool isAvailable = await authService.isUsernameAvailable(
          usernameController.text.trim(),
        );

        if (!isAvailable) {
          _showErrorSnackBar('Username already exists. Please choose another.');
          return;
        }

        // Intentar registrar al usuario
        bool isSuccess = await authService.registerUser(
          usernameController.text.trim(),
          userPasswordController.text.trim(),
          emailController.text.trim(),
        );

        if (isSuccess) {
          context.go('/login');
        } else {
          _showErrorSnackBar('Registration failed.');
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
          style: const TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}
