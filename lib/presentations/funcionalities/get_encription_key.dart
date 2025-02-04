import 'package:firebase_remote_config/firebase_remote_config.dart';

Future<String> getEncryptionKey() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.fetchAndActivate();
  return remoteConfig.getString('encryption_key');
}
