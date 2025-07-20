import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habbits/components/app_logo.dart';
import 'package:habbits/components/auth_links.dart';
import 'package:habbits/components/custom_button.dart';
import 'package:habbits/components/custom_text_field.dart';
import 'package:habbits/components/app_notification.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/core/validators.dart';
import 'package:habbits/providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _performLogin();
    }
  }

  Future<void> _performLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    final success = await authProvider.login(email, password);
    
    if (success && mounted) {
      NotificationHelper.showNotification(
        context,
        message: "Login realizado com sucesso!",
        isError: false,
        duration: const Duration(seconds: 3),
      );
      // O AuthWrapper irá redirecionar automaticamente
    } else if (mounted) {
      NotificationHelper.showNotification(
        context,
        message: authProvider.error ?? "Erro no login",
        isError: true,
        duration: const Duration(seconds: 5),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return authProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          const AppLogo(),
                          const SizedBox(height: 42),
                          const Text(
                            'Persistência é tudo. Vamos nessa?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Acesse sua conta para iniciar sua jornada',
                            style: TextStyle(fontSize: 14, color: AppColors.gray),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 32),
                          CustomTextField(
                            hintText: 'johndoe@gmail.com',
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.validateEmail,
                            onSaved: (value) => email = value!,
                          ),
                          const SizedBox(height: 16),
                          CustomTextField(
                            hintText: '********',
                            obscureText: true,
                            validator: Validators.validatePassword,
                            onSaved: (value) => password = value!,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Continuar',
                            onPressed: _submitForm,
                            isLoading: authProvider.isLoading,
                          ),
                          const SizedBox(height: 20),
                          AuthLinks(
                            questionText: 'Ainda não possui uma conta?',
                            linkText: 'Registre-se agora',
                            onTap: () {
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}
