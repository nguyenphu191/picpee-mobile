import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

const String KEY_ENCRYPT = "703a27c1d227676yfe6fb1d9134a4411";

class EncryptionUtil {
  static List<int> _generateKey() {
    final keyBytes = utf8.encode(KEY_ENCRYPT);
    final sha256Key = sha256.convert(keyBytes).bytes;
    return sha256Key;
  }

  static encrypt.IV _generateIV() {
    final random = Random.secure();
    final ivBytes = List<int>.generate(16, (_) => random.nextInt(256));
    return encrypt.IV(Uint8List.fromList(ivBytes));
  }

  static String encryptString(String plainText) {
    try {
      final key = encrypt.Key(Uint8List.fromList(_generateKey()));
      final iv = _generateIV();

      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final encrypted = encrypter.encrypt(plainText, iv: iv);
      final combinedBytes = iv.bytes + encrypted.bytes;
      return base64Encode(combinedBytes);
    } catch (e) {
      print('(EncryptionUtil.encrypt error) req: $plainText | message: $e');
      return plainText;
    }
  }

  static String decryptString(String encryptedText) {
    try {
      final key = encrypt.Key(Uint8List.fromList(_generateKey()));
      final combined = base64Decode(encryptedText);

      final ivBytes = combined.sublist(0, 16);
      final cipherBytes = combined.sublist(16);

      final iv = encrypt.IV(Uint8List.fromList(ivBytes));
      final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'),
      );

      final decrypted = encrypter.decrypt(
        encrypt.Encrypted(Uint8List.fromList(cipherBytes)),
        iv: iv,
      );

      return decrypted;
    } catch (e) {
      print('(EncryptionUtil.decrypt error) req: $encryptedText | message: $e');
      return encryptedText;
    }
  }
}

void main() async {
  print(
    "=== 🔐 Nhập các cặp key:value (Enter để xuống dòng, Enter 2 lần để kết thúc) ===",
  );

  final Map<String, String> data = {};
  String? line;
  String lastLine = '';

  // Nhập dữ liệu từ terminal
  while (true) {
    stdout.write("> ");
    line = stdin.readLineSync();

    // Nếu người dùng nhấn Enter 2 lần liên tiếp
    if (line != null && line.trim().isEmpty && lastLine.trim().isEmpty) {
      break;
    }

    if (line != null && line.trim().isNotEmpty) {
      final parts = line.split(':');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join(':').trim();
        data[key] = value;
      } else {
        print("⚠️  Định dạng không hợp lệ! Hãy nhập dạng key:value");
      }
    }
    lastLine = line ?? '';
  }

  if (data.isEmpty) {
    print("❌ Không có dữ liệu để mã hóa.");
    return;
  }

  // Sắp xếp key để kết quả nhất quán
  final sortedMap = Map.fromEntries(
    data.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );

  // Convert Map thành JSON string
  final jsonString = jsonEncode(sortedMap);
  print("\n📝 Chuỗi JSON gốc: $jsonString");

  // Mã hóa
  final encryptedPayload = EncryptionUtil.encryptString(jsonString);
  print("\n🔒 Payload đã mã hóa:\n$encryptedPayload");

  // Giải mã
  final decryptedJsonString = EncryptionUtil.decryptString(encryptedPayload);
  print("\n🔓 Chuỗi JSON đã giải mã:\n$decryptedJsonString");

  final decryptedObject = jsonDecode(decryptedJsonString);
  print("\n📦 Object sau giải mã: $decryptedObject");
}
