import '../../screens/auth/components/secure_storage.dart';

Future<String> getAccessToken() async {
  var tokens = await StorageService.readItemsFromToKeyChain();
  String accessToken = tokens['accessToken'] ?? '';
  return accessToken;
}