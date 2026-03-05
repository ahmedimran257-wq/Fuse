import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/services/notification_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Premium Error Boundary: Catch unhandled asynchronous errors
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('⚠️ [Global Error Caught]: $error');
    return true; // Prevent app crash
  };

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize Firebase (Required for Push)
  // Note: You MUST run 'flutterfire configure' in your terminal later to generate firebase_options.dart
  // For now, we wrap it in a try-catch so the app doesn't crash before you run the CLI.
  try {
    // If you haven't run flutterfire configure yet, this might fail or require options.
    // Once configured, you can just call Firebase.initializeApp() usually.
    await Firebase.initializeApp();
    await NotificationService().initialize();
  } catch (e) {
    debugPrint(
      'Firebase not configured yet. Run flutterfire configure. Error: $e',
    );
  }

  runApp(const ProviderScope(child: App()));
}
