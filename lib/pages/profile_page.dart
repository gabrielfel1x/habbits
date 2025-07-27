import 'package:flutter/material.dart';
import 'package:habbits/core/colors.dart';
import 'package:provider/provider.dart';
import 'package:habbits/providers/auth_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habbits/components/app_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    final name = user?.name ?? 'Nome do Usuário';
    final email = user?.email ?? 'email@exemplo.com';

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const AppHeader(
              title: 'Perfil',
              subtitle: 'Verifique suas informações',
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(height: 48),
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () async {
                            await Provider.of<AuthProvider>(
                              context,
                              listen: false,
                            ).logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'DESLOGAR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
