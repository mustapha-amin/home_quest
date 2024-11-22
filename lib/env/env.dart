// lib/env/env.dart
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
    @EnviedField(varName: 'SUPABASE_KEY', obfuscate: true)
    static final String supabaseKey = _Env.supabaseKey;
}