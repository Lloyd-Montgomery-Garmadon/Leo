import 'package:flutter_test/flutter_test.dart';
import 'package:leo/leo.dart';
import 'package:leo/leo_platform_interface.dart';
import 'package:leo/leo_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockLeoPlatform
    with MockPlatformInterfaceMixin
    implements LeoPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final LeoPlatform initialPlatform = LeoPlatform.instance;

  test('$MethodChannelLeo is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLeo>());
  });

  test('getPlatformVersion', () async {
    Leo leoPlugin = Leo();
    MockLeoPlatform fakePlatform = MockLeoPlatform();
    LeoPlatform.instance = fakePlatform;

    expect(await leoPlugin.getPlatformVersion(), '42');
  });
}
