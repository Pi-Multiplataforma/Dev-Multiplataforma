import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/dependencies.dart';
import 'widgets/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _login() async {
    final authController = Get.find<AuthController>();
    final result = await authController.signIn(
      _email.text,
      _pass.text,
    );

    if (result == 'sucess') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
      Get.offNamed('/conversa_ia'); // redireciona para conversa IA
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $result')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 182, 255, 255),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 28),
                  const AuthLogo(),
                  const SizedBox(height: 28),
                  LinedTextField(label: 'Email', controller: _email),
                  const SizedBox(height: 16),
                  LinedTextField(label: 'Senha', controller: _pass, isPassword: true),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: PillButton(
                          label: 'Voltar',
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: PillButton(
                          label: 'Entrar',
                          onTap: _login,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Get.toNamed('/signup'),
                    child: const Text('Não tem conta? Criar conta'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
