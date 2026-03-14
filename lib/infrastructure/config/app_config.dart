import '../../core/enums/environment.dart';

final class AppConfig {
  const AppConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    required this.environment,
  });

  final String supabaseUrl;
  final String supabaseAnonKey;
  final Environment environment;
}
