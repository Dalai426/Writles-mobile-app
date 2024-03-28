import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String decryptOTP(String encryptedMessage) {

    String secret = dotenv.get("ENCRYPTION_KEY", fallback: "");
    final key = encrypt.Key.fromBase64(secret);
    final b64key = encrypt.Key.fromBase64(base64Url.encode(key.bytes));
    final fernet = encrypt.Fernet(b64key);
    final encrypter = encrypt.Encrypter(fernet);
    final decrypted= encrypter.decrypt64(encryptedMessage);
    return decrypted;
}
