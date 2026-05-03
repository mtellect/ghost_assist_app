import 'app.dart';
import 'core/enums/api_environment_enum.dart';

void main() {
  const appFlavor = String.fromEnvironment('FLAVOR'); 

  final environment = getEnvironmentFromKey(appFlavor);
  runApplication(environment: environment);
}
