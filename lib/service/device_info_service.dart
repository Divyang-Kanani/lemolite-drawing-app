import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIDService {
  // Singleton instance
  static final DeviceIDService _instance = DeviceIDService._internal();

  // Private constructor
  DeviceIDService._internal();

  // Factory constructor to return the same instance
  factory DeviceIDService() => _instance;

  // Final variable to store the device ID once fetched
  String? _deviceID;

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceID() async {
    if (_deviceID != null) {
      return _deviceID!;
    }

    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      _deviceID = androidInfo.id; // Unique Android ID
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      _deviceID = iosInfo.identifierForVendor; // Unique iOS ID
    } else {
      _deviceID = "Unknown Device";
    }

    return _deviceID!;
  }
}
