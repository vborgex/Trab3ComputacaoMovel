import 'package:agenda_viagem/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:agenda_viagem/components/my_button.dart';
import 'package:agenda_viagem/components/my_textfield.dart';
import 'package:agenda_viagem/view/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final AuthService authService = AuthService();

  void showAlert(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  void registerUser() async {
    // Mostra o indicador de progresso
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Tenta registrar o usuário usando o AuthService
    final user = await authService.registerUser(
      usernameController.text,
      passwordController.text,
      confirmPasswordController.text,
      context,
    );

    // Se o registro for bem-sucedido, fecha o indicador de progresso e vai para a LoginPage
    if (user != null) {
      Navigator.pop(context); // Fecha o indicador de progresso
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Navigator.pop(
          context); // Fecha o indicador de progresso caso o registro falhe
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 50.0),
                Text("Crie seu cadastro",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 25,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    controller: usernameController,
                    hintText: "Email",
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: "Senha",
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                MyTextField(
                    controller: confirmPasswordController,
                    hintText: "Confirme a senha",
                    obscureText: false),
                const SizedBox(
                  height: 15,
                ),
                MyButton(onTap: registerUser, text: "Registrar"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
