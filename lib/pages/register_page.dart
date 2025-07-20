import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habbits/components/app_logo.dart';
import 'package:habbits/components/auth_links.dart';
import 'package:habbits/components/custom_button.dart';
import 'package:habbits/components/custom_text_field_light.dart';
import 'package:habbits/components/app_notification.dart';
import 'package:habbits/core/colors.dart';
import 'package:habbits/core/validators.dart';
import 'package:habbits/providers/auth_provider.dart';
import 'package:habbits/main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isLoading = false;

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Widget? _notification;

  void showNotification(String message, {bool isError = false}) {
    setState(() {
      _notification = AppNotification(
        message: message,
        isError: isError,
        onClose: () => setState(() => _notification = null),
      );
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => isLoading = true);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(name, email, password);
      setState(() => isLoading = false);
      if (!success) {
        showNotification(
          authProvider.error ?? 'Erro ao cadastrar usuário',
          isError: true,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AuthWrapper()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.primaryColor,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const AppLogo(textColor: AppColors.white, iconSize: 28),
                    const SizedBox(height: 42),
                    const Text(
                      'Gerencie sua jornada diariamente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bora criar sua conta? é rapidinho!',
                      style: TextStyle(fontSize: 14, color: AppColors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    CustomTextFieldLight(
                      hintText: 'John Doe',
                      validator: (value) =>
                          Validators.validateRequired(value, 'seu nome'),
                      onSaved: (value) => name = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldLight(
                      hintText: 'johndoe@gmail.com',
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      onSaved: (value) => email = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldLight(
                      hintText: 'Senha',
                      obscureText: true,
                      controller: passwordController,
                      validator: Validators.validatePassword,
                      onSaved: (value) => password = value!,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFieldLight(
                      hintText: 'Confirme sua senha',
                      obscureText: true,
                      controller: confirmPasswordController,
                      validator: (value) =>
                          Validators.validateConfirmPasswordController(
                            value,
                            passwordController,
                          ),
                      onSaved: (value) => confirmPassword = value!,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Continuar',
                      onPressed: _submitForm,
                      backgroundColor: AppColors.white,
                      textColor: AppColors.black,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 20),
                    AuthLinks(
                      questionText: 'Já possui uma conta? ',
                      linkText: 'Faça login',
                      questionColor: AppColors.white,
                      linkColor: AppColors.black,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_notification != null)
          Positioned(top: 40, left: 0, right: 0, child: _notification!),
      ],
    );
  }
}
