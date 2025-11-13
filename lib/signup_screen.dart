import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utilities/dependencies.dart';
import 'widgets/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() async {
    final authController = Get.find<AuthController>();
    final result = await authController.createAccount(
      _name.text,
      _email.text,
      _pass.text,
    );

    if (result == 'sucess') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta criada com sucesso!')),
      );
      Get.offNamed('/login'); // redireciona para login
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
                  LinedTextField(label: 'Nome', controller: _name),
                  const SizedBox(height: 16),
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
                          label: 'Criar conta',
                          onTap: _submit,
                        ),
                      ),
                    ],
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
