
import 'leo_platform_interface.dart';

class Leo {
  Future<String?> getPlatformVersion() {
    return LeoPlatform.instance.getPlatformVersion();
  }
}
