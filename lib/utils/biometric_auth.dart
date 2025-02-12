import 'package:local_auth/local_auth.dart';

class BiometricAuth {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// ✅ Check if Face Unlock or Fingerprint is available
  static Future<bool> isBiometricAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  /// ✅ Authenticate with Face Unlock or Fingerprint
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: "Authenticate to access Secure Data App",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true, // ✅ Shows system error messages
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
