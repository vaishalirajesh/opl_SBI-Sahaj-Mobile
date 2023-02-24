import 'dart:convert';
import 'dart:typed_data';
import 'package:basic_utils/basic_utils.dart';
import 'package:intl/intl.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:webcrypto/webcrypto.dart';

import 'encdec/encrypt.dart';

const SECRET_KEY_PUBLIC =
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkOsL6rwmY3c7YE+0bW0DjMG/o6+HejNt7lGwCIZseD3gowlcoMt6+0n9rvAMxW5tM3anCQK8wOf93jhcyBolR+cYIoiaN6/kjAd0e8sgkod8jqBzWArfVNYB/VKPukIqKi/wz1kEbLHMdmjpwC64mLmScI4IuZgWz0RjopOT6QH1zX1j3sCvz9sF0NMVrLA4hEA84KA5hMSvAiy0CtAF7ku2kQqrKVQQVUqmQuEptWgC5j1Fea9O/9lrN6s0pnRauQqQ3i7GHIu6/ljIVsY0Jpm3RjCzX2HQDyK+m9kWuKqGHudfom1vK86HqeKgJwFcq9rR9/s2/JVWP1clr95aiQIDAQAB";
const SECRET_KEY_PRIVATE =
    "MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDHz1yy/tbdueYwjTkn9UO7TEeybOJOIgg1fosB4N3XnF8BJpyxy5SbmDOO85mtf/s3XzklnV7kAYItsm78Fke+8kZ9N202iraoCRmFuhx94iCnd7fEdVsqwjmufW+NfoXT27vEJxSKA4oIpWPdIdIKyg2eE59NnEIRsRuNAaniXV7d5k4J64q4Y/Hk7T35FfHz4vz8gxB5xBH1OwFPfnvd0SpkM/VJxwU5FvDmf6d+WT3nNgomD2Lc6TSi44A0/oKIDfpxn/mm6CB6DNwaK61tTGzPjz3WveaweR5vaPIEMOsUW2aVJwOX7s4WyV9e32+Va2KNSeubjtQjy1JxCK2VAgMBAAECggEBAL0C2HLuhP0r/KeTAC1fYtoLt4r+WzmEEfXgpch6GgD7CBgDmZjKtuJVIPiqUYaBmXfw2RNPAdN35dgqgbhvryDe+HU8+E/u+giMyxroSkl+nlss8aajSUFyh7QbLmpP9HLL2pwcR96iqHGzWnt1ocbZCfauIzT8irdHrYM+vqDE++B/Q8w/Lnb6UJN9gTbmSyZ4UTsOxvbmbqKtpgHddx4sV+B0vu7JcdZPdQxiYSPHTthb0jsOhi9yHLfAfEyzGYYtSosarrtbtqFOtTgdyirmDMqXw5k3pMjFK3cvBTUjcSNszq4xPNNegJFfTrfbHDbl+9esI5n6oXE0CAaAAmUCgYEA8KG2FvmAnoU0K1i8sh75Gd+8ZO+zP3hecJZ3Qh0hMrf7ABUDHyRmlYArIPEVQucJXlvaQzbcMfPHjpbX3SDW/7ol9cSynTatYGMT9oCdVxIMd5OIaqs5CvArzGE9Oxa8WiricBbHnGrebE1TaZibVVQZAo3muoKu7TZwjQJMxusCgYEA1JI5G8iO/E/kCFAMmfTMdR6UYOR/K3ogJ9voczCEQS8J/iNqu5RgacbuTQVxq7w4+SsgAZeu5taW4GIWlGK8CPhrPP6I74OKaxH1MuxEZEDHmtCzwO9OxZ/UMm9yxnL+AKlTwcDeQL/xtIcOlcyRcf3jb8Cne2rALsMlePmkPX8CgYEA2v6RNX+EqsAXpotvz7uYgQ+56TKtM0pcyKJnjufr2rjN2llFKgZ6xfyLQ8Ok0epqAFIf5aP76goux3pIoprMkJfdDDsjQykLyPjipiiPCTsH1ZuTP2Ds3SOO+MZWb3xVlsoIonJY3+Xy3yXQj/2vAI005bo3De75PDGbZPl+3lkCgYAuBpMS7vP2sZ2gJyTzWMvEOCDMce0PDtxThQvplQGt02+IdUaw4smVXZtPVfRsyM5VNP8zGRKnrKLyZoqZCl/IWXFuvXYM1iBsWnEK25lbU6NkY/fnuGkH5Tleyj7BtThGEGOwOgBlaKn++pcv3CFJ2z0Zf09EK7L87Qf6D6N+JQKBgD/LkbMfJ/QsYRkYE4sQlSv4pZakJtvnLAwgNAdBb0kuvZNPhH60V5gYShZZnuvId4MG/EiCS4WrrsdeutnyNvKC2e27PwcyHfCXcIudQWPaHf++dBEIMgoqHN22qS/DV+iGZM95TKHuDWFFa8T4AZiIqzf5B+sR6F+4a4U6hNPc";

RSAPublicKey getpublicKey(String b64) {
  final pem =
      '-----BEGIN RSA PUBLIC KEY-----\n$b64\n-----END RSA PUBLIC KEY-----';
  return CryptoUtils.rsaPublicKeyFromPem(pem);
}

RSAPrivateKey getPrivateKey(String b64) {
  final pem =
      '-----BEGIN RSA PRIVATE KEY-----\n$b64\n-----END RSA PRIVATE KEY-----';
  return CryptoUtils.rsaPrivateKeyFromPem(pem);
}

String decryptByPrivatekey(String? content) {
  var publicKey_ = getpublicKey(SECRET_KEY_PUBLIC);
  var privateKey_ = getPrivateKey(SECRET_KEY_PRIVATE);

  Encrypter encrypter =
      Encrypter(RSA(publicKey: publicKey_, privateKey: privateKey_));
  String decrypted = encrypter.decrypt(Encrypted.fromBase64(content!));


  return decrypted;
}

String encryptbypublicekey(String content) {
  var publicKey_ = getpublicKey(SECRET_KEY_PUBLIC);
  var privateKey_ = getPrivateKey(SECRET_KEY_PRIVATE);

  Encrypter encrypter =
      Encrypter(RSA(publicKey: publicKey_, privateKey: privateKey_));

  var decrypted = encrypter.encrypt(content).base64;

  return decrypted;
}

Future<String> getCurrentTimeStemp() async {
  DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm:ss");
  return dateFormat.format(DateTime.now());
}

Future<String> encryptAES(String message, String key, String iv) async {
  var aesGcmSecretKey = await AesGcmSecretKey.importRawKey(utf8.encode(key));
  var content = utf8.encode(message);
  var t = iv.substring(0, 16);
  var iv_ = utf8.encode(t);
  Uint8List encryptedBytes = await aesGcmSecretKey.encryptBytes(content, iv_);
  var base64 = base64Encode(encryptedBytes);

  return base64;
}

Future<String> decryptAES(String? message, String? key, String? iv) async {
  var aesGcmSecretKey = await AesGcmSecretKey.importRawKey(utf8.encode(key!));
  var content = base64Decode(message!);
  var t = iv?.substring(0, 16);
  var iv_ = utf8.encode(t!);
  Uint8List encryptedBytes = await aesGcmSecretKey.decryptBytes(content, iv_);

  String decryptdString = String.fromCharCodes(encryptedBytes);

  return decryptdString;
}

// var public = CryptoUtils.rsaPublicKeyFromPem(pem);

//var encryptedRSAkey = encryptbypublicekey(str2);



//var decrryptKEy = decryptByPrivatekey(secID);

//var decryptedkey= utf8.decode(base64Decode(decrryptKEy));

// var decrryptKEy_2 = utf8.encode(decrryptKEy_);

//var response= utf8.decode(base64.decode(payload));




// Uint8List ivCiphertextMac = base64.decode(payload); // from the Java code
// Uint8List iv = base64.decode("30-09-2022 04:49:13".substring(0,16));
// Uint8List ciphertext  = ivCiphertextMac.sublist(12, ivCiphertextMac.length - 16);
// Uint8List mac = ivCiphertextMac.sublist(ivCiphertextMac.length - 16);
//
// Uint8List passphrase = base64.decode(decrryptKEy_);
// SecretKey secretKey = new SecretKey(passphrase);
//
// SecretBox secretBox = SecretBox(ciphertext, nonce: iv, mac: new MaCTest.Mac(mac));
//
// List<int> decrypted = await AesGcm.with256bits().decrypt(secretBox, secretKey: secretKey);
// String dec = utf8.decode(decrypted);
//


// final decrypter = Encrypter(AES(Key.fromBase64(decrryptKEy_)));

// final decrypted = decrypter.decrypt(Encrypted.fromBase64(payload), iv: IV.fromUtf8("30-09-2022 04:49:13".substring(0,16)));


// final iv = IV.fromSecureRandom(16);
// final encrypter = Encrypter(AES(Key.fromBase64(str2)));

//final encrypted = encrypter.encrypt(plainText, iv: iv);



//  final decrypted = encrypter.decrypt(encrypted, iv: iv);

// var aesEncryptedReq=()

// encrypter = Encrypter(RSA(publicKey: publicKey, privateKey: privKey, encoding: RSAEncoding.PKCS1));
//  encrypted = encrypter.encrypt(plainText);
//  decrypted = encrypter.decrypt(encrypted) ;






// String encryprtAES(String plainText, String key_, String iv_) {
//   final key = Key.fromUtf8(key_);
//   final iv = IV.fromUtf8(iv_.substring(0, 16));
//
//   final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
//
//   final encrypted = encrypter.encrypt(plainText, iv: iv);
//

//
//   return encrypted.base64;
// }
//
// String decrypteAES(String? payload, String? iv_, String? timeStemp) {
//   final key = Key.fromUtf8(iv_!);
//   final iv = IV.fromUtf8(timeStemp!.substring(0, 16));
//   final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
//   final decrypted = encrypter.decrypt(Encrypted.fromBase64(payload!), iv: iv);
//
//   return decrypted;
// }



//var timestemp=getCurrentTimeStemp();

//encryprtAES("test",uuid,timestemp);

// decrypteAES(payload, decryptedkey, "12-10-2022 05:38:57");
