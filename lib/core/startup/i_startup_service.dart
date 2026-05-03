import '../enums/api_environment_enum.dart';

abstract class IStartUpService {
  Future<void> registerNetwork();
  Future<void> registerServices({required ApiEnvironmentEnum environment});
  Future<void> registerControllers();
  Future<void> initializeApp({required ApiEnvironmentEnum environment});
}
