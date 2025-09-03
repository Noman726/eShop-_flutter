import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'theme_provider.dart'; // Fixed import path
import 'routes.dart';

void main()

{
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add this
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Add this

    final lightColorScheme = ColorScheme.light(
      primary: const Color(0xFF0A9396),
      onPrimary: Colors.white,
      secondary: const Color(0xFFEE9B00),
      onSecondary: Colors.white,
      surface: const Color(0xFFF7F7F7), // Changed from background
      onSurface: Colors.black87, // Changed from onBackground
      error: const Color(0xFFE63946),
      onError: Colors.white,
    );

    final darkColorScheme = ColorScheme.dark(
      primary: const Color(0xFF0A9396),
      onPrimary: Colors.white,
      secondary: const Color(0xFFEE9B00),
      onSecondary: Colors.black,
      surface: const Color(0xFF121212), // Changed from background
      onSurface: Colors.white, // Changed from onBackground
      error: const Color(0xFFE63946),
      onError: Colors.black,
    );

    return MaterialApp(
      title: 'ACE-thetic',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Use theme provider here
      theme: buildTheme(lightColorScheme, Brightness.light),
      darkTheme: buildTheme(darkColorScheme, Brightness.dark),
      initialRoute: '/items', // Changed from '/splash' to '/items' to skip login
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }

  ThemeData buildTheme(ColorScheme colorScheme, Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface, // Fixed deprecated background
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: Colors.black26,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface, // Fixed deprecated onBackground
        ),
        bodyMedium: TextStyle(fontSize: 16, color: colorScheme.onSurface), // Fixed deprecated onBackground
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary.withValues(alpha: 0.8); // Fixed deprecated withOpacity
            }
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primary.withValues(alpha: 0.7); // Fixed deprecated withOpacity
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          elevation: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.pressed) ? 2 : 4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          minimumSize: WidgetStateProperty.all(const Size.fromHeight(50)),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary,
        foregroundColor: colorScheme.onSecondary,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 5,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              BorderSide(color: colorScheme.secondary.withValues(alpha: 0.5)), // Fixed deprecated withOpacity
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
