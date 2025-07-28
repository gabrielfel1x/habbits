import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habbits/core/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habbits/pages/login_page.dart';
import 'package:habbits/providers/auth_provider.dart';
import 'package:habbits/routes/app_routes.dart';
import 'package:habbits/components/app_bottom_navigation_bar.dart';
import 'package:habbits/pages/home_page.dart';
import 'package:habbits/pages/my_habits_page.dart';
import 'package:habbits/pages/create_habit_page.dart';
import 'package:habbits/pages/graphics_page.dart';
import 'package:habbits/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: MaterialApp(
        title: 'Habbits',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
          textTheme: GoogleFonts.interTextTheme(),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        home: const AuthWrapper(),
        routes: getAppRoutes(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isLoggedIn) {
          return const MainNavigationScreen();
        }

        return const LoginPage();
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void goToCreateHabit() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomePage(),
      MyHabitsPage(onAddHabit: goToCreateHabit),
      CreateHabitPage(),
      GraphicsPage(),
      ProfilePage(),
    ];
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
