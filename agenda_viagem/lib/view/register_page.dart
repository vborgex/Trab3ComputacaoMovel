import 'package:firebase_auth/firebase_auth.dart';
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

  // Método para exibir mensagens de alerta
  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(message),
      ),
    );
  }

  // Método para registrar o usuário
  void registerUser() async {
    // Exibir indicador de carregamento
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Verificar se as senhas coincidem
      if (passwordController.text.trim() ==
          confirmPasswordController.text.trim()) {
        // Registrar o usuário no Firebase
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Fechar indicador de carregamento
        Navigator.pop(context);

        // Redirecionar para a página de login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        Navigator.pop(context); // Fechar indicador de carregamento
        showAlert("As senhas não coincidem!");
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Fechar indicador de carregamento

      // Exibir mensagem de erro apropriada
      if (e.code == 'email-already-in-use') {
        showAlert("Este email já está sendo utilizado!");
      } else if (e.code == 'invalid-email') {
        showAlert("O email fornecido é inválido!");
      } else if (e.code == 'weak-password') {
        showAlert("A senha é muito fraca! Use ao menos 6 caracteres.");
      } else {
        showAlert("Erro: ${e.message}");
      }
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
                Text(
                  "Crie seu cadastro",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 25.0),

                // Campo de texto para email
                MyTextField(
                  controller: usernameController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 15.0),

                // Campo de texto para senha
                MyTextField(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),

                // Campo de texto para confirmação de senha
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirme a senha",
                  obscureText: true,
                ),
                const SizedBox(height: 15.0),

                // Botão de registro
                MyButton(
                  onTap: registerUser,
                  text: "Registrar",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
