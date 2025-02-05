import 'dart:io';

import 'package:flutter/material.dart';

import 'package:campo_minado_app/core/models/auth_form_data.dart';
import 'package:campo_minado_app/components/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Future<void> Function(AuthFormData) onSubmit;

  const AuthForm({
    required this.onSubmit,
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formData = AuthFormData();

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // FocusNodes
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  // Show password
  bool _isPasswordObscure = true;

  void _showErrorDialog(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _handleImagePick(File image) {
    _formData.image = image;
  }

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_formData.image == null && _formData.isSignup) {
      _showErrorDialog('Imagem não selecionada.');
    }

    await widget.onSubmit(_formData);

    if (_formData.isSignup) {
      // Resetando o formulário
      _formKey.currentState?.reset();

      // Limpando os controladores de email e senha
      _emailController.clear();
      _passwordController.clear();

      _formData.name = '';
      _formData.image = null;

      setState(() => _formData.toggleMode());
    }
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                _formData.isLogin ? 'Entrar' : 'Cadastrar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (_formData.isSignup)
                Container(
                  margin: const EdgeInsets.all(15),
                  child: UserImagePicker(
                    onImagePick: _handleImagePick,
                  ),
                ),
              if (_formData.isSignup)
                TextFormField(
                  key: ValueKey('name'),
                  initialValue: _formData.name,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    prefixIcon: Icon(
                      Icons.person,
                      size: 20,
                      color: Color(0xffffeba7),
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: (value) => _formData.name = value,
                  validator: (textField) {
                    final name = textField ?? '';

                    if (name.trim().isEmpty) {
                      return 'Nome de Usuário não pode ser vazio.';
                    }

                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                ),
              TextFormField(
                key: ValueKey('email'),
                focusNode: _emailFocusNode,
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    size: 20,
                    color: Color(0xffffeba7),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onChanged: (value) => _formData.email = value,
                validator: (textField) {
                  final email = textField ?? '';

                  if (email.trim().isEmpty) {
                    return 'Nome de Usuário não pode ser vazio.';
                  }

                  if (!email.contains('@')) {
                    return 'Email inválido.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              TextFormField(
                key: ValueKey('password'),
                focusNode: _passwordFocusNode,
                controller: _passwordController,
                obscureText: _isPasswordObscure,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: Icon(
                    Icons.lock,
                    size: 20,
                    color: Color(0xffffeba7),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => setState(
                        () => _isPasswordObscure = !_isPasswordObscure),
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.remove_red_eye_outlined
                          : Icons.remove_red_eye,
                      color: Color(0xffffeba7),
                    ),
                  ),
                ),
                onChanged: (value) => _formData.password = value,
                textInputAction: TextInputAction.done,
                validator: (textField) {
                  final password = textField ?? '';

                  if (password.trim().length < 6) {
                    return 'A senha deve conter no mínimo 6 caractéres.';
                  }

                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).unfocus();
                  _submit();
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _submit,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffffeba7), // Cor de fundo
                    borderRadius:
                        BorderRadius.circular(4), // Bordas arredondadas
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
      ),
    );
  }
}
