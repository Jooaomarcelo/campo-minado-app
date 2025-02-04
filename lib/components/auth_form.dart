import 'package:campo_minado_app/core/models/auth_form_data.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(42, 43, 56, 1),
      margin: const EdgeInsets.symmetric(
        horizontal: 40,
        vertical: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              _formData.isLogin ? 'Entrar' : 'Cadastrar',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (_formData.isSignup)
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  prefixIcon: Icon(
                    Icons.person,
                    size: 20,
                    color: Color(0xffffeba7),
                  ),
                ),
                onChanged: (value) => _formData.name = value,
              ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'E-mail',
                prefixIcon: Icon(
                  Icons.alternate_email,
                  size: 20,
                  color: Color(0xffffeba7),
                ),
              ),
              onChanged: (value) => _formData.email = value,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Senha',
                prefixIcon: Icon(
                  Icons.lock,
                  size: 20,
                  color: Color(0xffffeba7),
                ),
              ),
              onChanged: (value) => _formData.password = value,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffffeba7), // Cor de fundo
                  borderRadius: BorderRadius.circular(4), // Bordas arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(255, 235, 167, 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  _formData.isLogin ? 'ENTRAR' : 'CADASTRAR',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(78, 85, 107, 1),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _formData.toggleMode()),
              child: Text(
                _formData.isLogin ? 'Novo usuário?' : 'Já possui uma conta?',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
