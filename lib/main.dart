import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://wdtqaaclbkoolmrjbijj.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndkdHFhYWNsYmtvb2xtcmpiaWpqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzIwODM2MDIsImV4cCI6MjA4NzY1OTYwMn0.1XLq3QZ1prxBHsNZc4GbcdIaQcvGkAnW8DJqTr8pFF4',
  );

  runApp(const ProviderScope(child: App()));
}
