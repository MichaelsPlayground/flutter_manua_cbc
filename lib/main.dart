import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';

import 'package:flutter/material.dart';
import 'package:pointycastle/export.dart' as pc;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter;

          print('\n*** AES CBC encryption manual way');
          String keyString = '12345678123456781234567812345678'; // 32 chars
          String ivString = '7654321076543210'; // 16 chars
          Uint8List key = createUint8ListFromString(keyString);
          Uint8List iv = createUint8ListFromString(ivString);
          print('key:       ' + bytesToHex(key));
          print('iv:        ' + bytesToHex(iv));

          //String ptString = 'abcdefghijklmnopABCDEFGHIJKLMNOP'; // 32 chars
          String ptString = 'abcdefghijklmnopABCDEFGHIJKLMNOP12345'; // 37 chars
          String pt1String = 'abcdefghijklmnop';
          String pt2String = 'ABCDEFGHIJKLMNOP';
          String pt3String = '12345';
          Uint8List pt = createUint8ListFromString(ptString);
          Uint8List pt1 = createUint8ListFromString(pt1String);
          Uint8List pt2 = createUint8ListFromString(pt2String);
          Uint8List pt3 = createUint8ListFromString(pt3String);

          //String ctCbcBase64 = aesCbcEncryptionToBase64(key, iv, pt);
          Uint8List ctCbc = aesCbcEncryptionToUint8List(key, iv, pt);
          //print('ciphertext Base64: ' + ciphertextBase64);
          //String decryptedtext = aesCbcDecryptionFromBase64(key, iv, ciphertextBase64);
          //print('decryptedtext: ' + decryptedtext);
          print('plaintext: ' + bytesToHex(pt));
          print('*** AES CBC with padding regular');
          print('ct CBC regular:       ' + bytesToHex(ctCbc));

          print('*** ECB part 1');
          print('pt1 hex:              ' + bytesToHex(pt1));
          print('iv round 1:           ' + bytesToHex(iv));
          Uint8List pt1XorIv = xor(pt1, iv);
          print('pt1XorIv round 1:     ' + bytesToHex(pt1XorIv));
          //String ctEcb1B64 = aesEcbEncryptionNoPaddingToBase64(key, pt1XorIv);
          Uint8List ctEcb1 = aesEcbEncryptionNoPaddingToUint8List(key, pt1XorIv);
          print('ctEcb1:               ' + bytesToHex(ctEcb1));

          print('*** ECB part 2');
          print('pt2 hex:              ' + bytesToHex(pt2));
          Uint8List pt2XorCtEcb1 = xor(pt2, ctEcb1);
          print('pt2XorCtEcb1 round 2: ' + bytesToHex(pt2XorCtEcb1));
          //String ctEcb2B64 = aesEcbEncryptionNoPaddingToBase64(key, pt2XorCtEcb1);
          Uint8List ctEcb2= aesEcbEncryptionNoPaddingToUint8List(key, pt2XorCtEcb1);
          print('ctEcb2:                                               ' + bytesToHex(ctEcb2));

          print('*** CBC part 3 (last part) with padding');
          print('pt3 hex:              ' + bytesToHex(pt3));
          print('iv = ctEcb2:          ' + bytesToHex(ctEcb2));
          //String ctCbc3B64 = aesCbcEncryptionToBase64(key, ctEcb2, pt3);
          Uint8List ctCbc3 = aesCbcEncryptionToUint8List(key, ctEcb2, pt3);
          print('ct CBC part 3 with padding:                           '
              '                                ' + bytesToHex(ctCbc3));

          print('\n*** ECB part 2 with padding not working correctly !');
          print('pt2 hex:              ' + bytesToHex(pt2));
          Uint8List pt2XorCtEcb2 = xor(pt2, ctEcb1);
          print('pt2XorCtEcb2 round 2: ' + bytesToHex(pt2XorCtEcb1));
          Uint8List ctEcb2Padding = aesEcbEncryptionToUint8List(key, ctEcb1, pt2XorCtEcb2);
          print('ct ECB part 2 with padding:                           ' + bytesToHex(ctEcb2Padding));

          print('\n*** DECRYPTION manually ***');
          print('ctEcb1:               ' + bytesToHex(ctEcb1));
          print('ctEcb2:               '
              '                                ' + bytesToHex(ctEcb2));
          print('ct CBC part 3 with padding:                           '
              '                                ' + bytesToHex(ctCbc3));
          // decrypt first part with key + iv
          print('plaintext:            ' + bytesToHex(pt));

          print('*** ECB part 1 decryption');
          Uint8List dtEcb1 = aesEcbDecryptionNoPaddingToUint8List(key, ctEcb1);
          print('dtEcb1:               ' + bytesToHex(dtEcb1));
          Uint8List dtEcb1XorIv = xor(dtEcb1, iv);
          print('dtEcb1XorIv:          ' + bytesToHex(dtEcb1XorIv));

          print('*** ECB part 2 decryption');
          Uint8List dtEcb2 = aesEcbDecryptionNoPaddingToUint8List(key, ctEcb2);
          print('dtEcb2:               ' + bytesToHex(dtEcb2));
          Uint8List dtEcb2XorCtEcb1 = xor(dtEcb2, ctEcb1);
          print('dtEcb2XorCtEcb1:      '
              '                                ' + bytesToHex(dtEcb2XorCtEcb1));

          print('*** CBC part 3 decryption');
          print('pt3 hex:              ' + bytesToHex(pt3));
          print('iv = ctEcb2:          ' + bytesToHex(ctEcb2));
          //String ctCbc3B64 = aesCbcEncryptionToBase64(key, ctEcb2, pt3);
          Uint8List dtCbc3 = aesCbcDecryptionToUint8List(key, ctEcb2, ctCbc3);
          print('dt CBC part 3 with padding:                           '
              '                                ' + bytesToHex(dtCbc3));
          print('\n*** WORKING = equal results ***');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Uint8List aesEcbEncryptionNoPaddingToUint8List(Uint8List key, Uint8List plaintextUint8) {
    // no padding
    pc.BlockCipher cipher = pc.ECBBlockCipher(pc.AESFastEngine());
    cipher.init(
      true,
      pc.KeyParameter(key),
    );
    Uint8List cipherText = cipher.process(plaintextUint8);
    return cipherText;
  }

  Uint8List aesEcbDecryptionNoPaddingToUint8List(Uint8List key, Uint8List ciphertextUint8) {
    // no padding
    pc.BlockCipher cipher = pc.ECBBlockCipher(pc.AESFastEngine());
    cipher.init(
      false,
      pc.KeyParameter(key),
    );
    Uint8List plainText = cipher.process(ciphertextUint8);
    return plainText;
  }

  Uint8List aesEcbEncryptionToUint8List(Uint8List key, Uint8List iv, Uint8List plaintextUint8) {
    final pc.ECBBlockCipher cipher = new pc.ECBBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    pc.PaddedBlockCipherParameters<pc.CipherParameters, pc.CipherParameters> paddingParams = new pc.PaddedBlockCipherParameters(pc.KeyParameter(key), null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(true, paddingParams);
    final ciphertext = paddingCipher.process(plaintextUint8);
    return ciphertext;
  }

  Uint8List aesCbcEncryptionToUint8List(Uint8List key, Uint8List iv, Uint8List plaintextUint8) {
    final pc.CBCBlockCipher cipher = new pc.CBCBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(true, paddingParams);
    final ciphertext = paddingCipher.process(plaintextUint8);
    return ciphertext;
  }

  Uint8List aesCbcDecryptionToUint8List(Uint8List key, Uint8List iv, Uint8List ciphertextUint8) {
    final pc.CBCBlockCipher cipher = new pc.CBCBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);
    final plaintext = paddingCipher.process(ciphertextUint8);
    return plaintext;
  }

  String aesEcbEncryptionNoPaddingToBase64(Uint8List key, Uint8List plaintextUint8) {
    // no padding
    pc.BlockCipher cipher = pc.ECBBlockCipher(pc.AESFastEngine());
    cipher.init(
      true,
      pc.KeyParameter(key),
    );
    Uint8List cipherText = cipher.process(plaintextUint8);
    return base64Encoding(cipherText);
  }

  String aesEcbEncryptionToBase64(Uint8List key, Uint8List iv, Uint8List plaintextUint8) {
    final pc.ECBBlockCipher cipher = new pc.ECBBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    //pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    //pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    pc.PaddedBlockCipherParameters<pc.CipherParameters, pc.CipherParameters> paddingParams = new pc.PaddedBlockCipherParameters(pc.KeyParameter(key), null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(true, paddingParams);
    final ciphertext = paddingCipher.process(plaintextUint8);
    final ciphertextBase64 = base64Encoding(ciphertext);
    return ciphertextBase64;
  }

  String aesCbcEncryptionToBase64(Uint8List key, Uint8List iv, Uint8List plaintextUint8) {
    //var plaintextUint8 = createUint8ListFromString(plaintext);
    final pc.CBCBlockCipher cipher = new pc.CBCBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(true, paddingParams);
    final ciphertext = paddingCipher.process(plaintextUint8);
    final ciphertextBase64 = base64Encoding(ciphertext);
    return ciphertextBase64;
  }

  String aesCbcDecryptionFromBase64(Uint8List key, Uint8List iv, String ciphertextBase64) {
    //var parts = data.split(':');
    //var iv = base64Decoding(parts[0]);
    //var ciphertext = base64Decoding(parts[1]);
    var ciphertext = base64Decoding(ciphertextBase64);
    pc.CBCBlockCipher cipher = new pc.CBCBlockCipher(new pc.AESFastEngine());
    pc.ParametersWithIV<pc.KeyParameter> cbcParams = new pc.ParametersWithIV<pc.KeyParameter>(new pc.KeyParameter(key), iv);
    pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null> paddingParams = new pc.PaddedBlockCipherParameters<pc.ParametersWithIV<pc.KeyParameter>, Null>(cbcParams, null);
    pc.PaddedBlockCipherImpl paddingCipher = new pc.PaddedBlockCipherImpl(new pc.PKCS7Padding(), cipher);
    paddingCipher.init(false, paddingParams);
    return new String.fromCharCodes(paddingCipher.process(ciphertext));
  }

  String bytesToHex(Uint8List data) {
    return hex.encode(data);
  }

  Uint8List createUint8ListFromString(String s) {
    var ret = new Uint8List(s.length);
    for (var i = 0; i < s.length; i++) {
      ret[i] = s.codeUnitAt(i);
    }
    return ret;
  }

  String base64Encoding(Uint8List input) {
    return base64.encode(input);
  }

  Uint8List base64Decoding(String input) {
    return base64.decode(input);
  }

  // https://github.com/tpscrpt/xor/blob/develop/lib/xor.dart
  Uint8List xor(Uint8List a, Uint8List b) {
    if (a.lengthInBytes == 0 || b.lengthInBytes == 0) {
      throw ArgumentError.value(
          "lengthInBytes of Uint8List arguments must be > 0");
    }
    bool aIsBigger = a.lengthInBytes > b.lengthInBytes;
    int length = aIsBigger ? a.lengthInBytes : b.lengthInBytes;
    Uint8List buffer = Uint8List(length);
    for (int i = 0; i < length; i++) {
      var aa, bb;
      try {
        aa = a.elementAt(i);
      } catch (e) {
        aa = 0;
      }
      try {
        bb = b.elementAt(i);
      } catch (e) {
        bb = 0;
      }
      buffer[i] = aa ^ bb;
    }
    return buffer;
  }

}
