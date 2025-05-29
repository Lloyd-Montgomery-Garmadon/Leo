import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'leo_method_channel.dart';

abstract class LeoPlatform extends PlatformInterface {
  /// Constructs a LeoPlatform.
  LeoPlatform() : super(token: _token);

  static final Object _token = Object();

  static LeoPlatform _instance = MethodChannelLeo();

  /// The default instance of [LeoPlatform] to use.
  ///
  /// Defaults to [MethodChannelLeo].
  static LeoPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LeoPlatform] when
  /// they register themselves.
  static set instance(LeoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
