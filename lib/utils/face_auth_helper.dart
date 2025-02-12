import 'package:local_auth/local_auth.dart';

class FaceAuthHelper {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// ✅ Check if Face ID is available
  static Future<bool> isFaceIdAvailable() async {
    List<BiometricType> availableBiometrics = await _auth.getAvailableBiometrics();
    return availableBiometrics.contains(BiometricType.face);
  }

  /// ✅ Perform Face Authentication
  static Future<bool> authenticateWithFace() async {
    try {
      bool authenticated = await _auth.authenticate(
        localizedReason: "Scan your face to proceed",
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return authenticated;
    } catch (e) {
      return false;
    }
  }
}
