import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'leo_platform_interface.dart';

/// An implementation of [LeoPlatform] that uses method channels.
class MethodChannelLeo extends LeoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('leo');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
