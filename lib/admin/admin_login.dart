import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pix_wall/services/auth_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            context.go('/login');
          },
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: const Color.fromARGB(255, 1, 29, 38),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Start With Admin',
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
            _buildLoginForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
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
                height: MediaQuery.of(context).size.height / 2.2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    SizedBox(height: 50.0),
                    _buildUsernameField(),
                    SizedBox(height: 30.0),
                    _buildPasswordField(),
                    SizedBox(height: 40.0),
                    _buildLoginButton(),
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

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: loginAdmin,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(12.0)),
        child: Center(
          child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void loginAdmin() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        bool isSuccess = await authService.loginAdmin(
            usernameController.text.trim(), userPasswordController.text.trim());
        if (isSuccess) {
          context.go('/admin/home');
        } else {
          _showErrorToast('Invalid username or password');
        }
      } catch (e) {
        _showErrorToast('An error occurred: $e');
      }
    }
  }

  void _showErrorToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.orangeAccent,
      textColor: Colors.white,
      fontSize: 18.0,
      gravity: ToastGravity.BOTTOM,
    );
  }
}
