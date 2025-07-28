import 'package:flutter/material.dart';
import 'package:habbits/pages/login_page.dart';
import 'package:habbits/pages/register_page.dart';
import 'package:habbits/pages/home_page.dart';
import 'package:habbits/pages/my_habits_page.dart';

Map<String, WidgetBuilder> getAppRoutes() {
  return {
    '/login': (context) => const LoginPage(),
    '/register': (context) => const RegisterPage(),
    '/home': (context) => const HomePage(),
    '/my_habits': (context) => const MyHabitsPage(),
  };
}
