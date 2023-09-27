import 'package:easy_maintenance/generated/l10n.dart';
import 'package:easy_maintenance/views/addVehicle.dart';
import 'package:easy_maintenance/views/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  // S'assurer que tout est initialiser :
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Maintenance',
      theme: _buildCustomTheme(),
      home: Home(),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
    );
  }

  ThemeData _buildCustomTheme() {
    final base = ThemeData.light();
    const easyPrimaryColor = Color(0xFFFACF39);
    final colorScheme = ColorScheme.fromSeed(
        seedColor: easyPrimaryColor, primary: easyPrimaryColor);
    return base.copyWith(
        colorScheme: colorScheme,
        floatingActionButtonTheme: base.floatingActionButtonTheme
            .copyWith(backgroundColor: easyPrimaryColor),
        iconTheme: base.iconTheme.copyWith(color: easyPrimaryColor),
        hintColor: Colors.white,
        indicatorColor: Colors.white,
        listTileTheme: const ListTileThemeData(
            tileColor: Color(0xFF5a6877), textColor: Colors.white),
        scaffoldBackgroundColor: const Color(0xFF2e353d),
        textTheme: const TextTheme().apply(
          bodyColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF5a6877),
        ),
        bottomAppBarTheme: const BottomAppBarTheme(color: Color(0xFF2e353d)));
  }
}
