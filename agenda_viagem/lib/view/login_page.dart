import 'package:agenda_viagem/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:agenda_viagem/components/my_button.dart';
import 'package:agenda_viagem/components/my_textfield.dart';
import 'package:agenda_viagem/view/register_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void signUserIn(BuildContext context) async {
    // Mostra o indicador de progresso
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    // Tenta fazer o login usando o AuthService
    final user = await authService.signInWithEmailPassword(
      userNameController.text,
      passwordController.text,
      context,
    );

    // Se o login for bem-sucedido, fecha o indicador de progresso e vai para a HomePage (ou outra tela)
    if (user != null) {
      Navigator.pop(context); // Fecha o indicador de progresso
      // Redirecionar para a página inicial ou home
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.pop(
          context); // Fecha o indicador de progresso caso o login falhe
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 235, 235),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),
            const Icon(Icons.lock, size: 100),
            const SizedBox(height: 50),
            Text(
              'Seja Bem Vindo!',
              style: TextStyle(
                color: Color.fromARGB(255, 28, 28, 28),
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: userNameController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 15),
            MyTextField(
              controller: passwordController,
              hintText: "Senha",
              obscureText: true,
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Esqueceu a senha?',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            MyButton(
              onTap: () => signUserIn(context), // Passa o context para a função
              text: "Entrar",
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Não tem cadastro?",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(width: 4.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text(
                    "Registre-se agora",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
