import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseClientWrapper {
  static SupabaseClient get instance => Supabase.instance.client;
}
