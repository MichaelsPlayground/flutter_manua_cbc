# flutter_manua_cbc

pointycastle: ^3.3.5

Das Projekt zeigt die manuelle Ver- und Entschlüsselung mittels AES CBC, allerdings

werden die einzelnen Zeile mit AES ECB ver- und entschlüsselt und nur der LETZTE Teil

mit AES CBC, damit wird die blockweise Bearbeitung ermöglicht
s
I/flutter ( 4703): *** AES CBC encryption manual way

I/flutter ( 4703): key:       3132333435363738313233343536373831323334353637383132333435363738

I/flutter ( 4703): iv:        37363534333231303736353433323130

I/flutter ( 4703): plaintext: 6162636465666768696a6b6c6d6e6f704142434445464748494a4b4c4d4e4f503132333435

I/flutter ( 4703): *** AES CBC with padding regular

I/flutter ( 4703): ct CBC regular:       3eeb54430730c50d938f980a6b61bad9ce5c17245926da0ed40a855d8f3eb3364adc4af9a6ae2601538d97eb379d01a7

I/flutter ( 4703): *** ECB part 1

I/flutter ( 4703): pt1 hex:              6162636465666768696a6b6c6d6e6f70

I/flutter ( 4703): iv round 1:           37363534333231303736353433323130

I/flutter ( 4703): pt1XorIv round 1:     56545650565456585e5c5e585e5c5e40

I/flutter ( 4703): ctEcb1:               3eeb54430730c50d938f980a6b61bad9

I/flutter ( 4703): *** ECB part 2

I/flutter ( 4703): pt2 hex:              4142434445464748494a4b4c4d4e4f50

I/flutter ( 4703): pt2XorCtEcb1 round 2: 7fa9170742768245dac5d346262ff589

I/flutter ( 4703): ctEcb2:                                               ce5c17245926da0ed40a855d8f3eb336

I/flutter ( 4703): *** CBC part 3 (last part) with padding

I/flutter ( 4703): pt3 hex:              3132333435

I/flutter ( 4703): iv = ctEcb2:          ce5c17245926da0ed40a855d8f3eb336

I/flutter ( 4703): ct CBC part 3 with padding:                                                           4adc4af9a6ae2601538d97eb379d01a7

I/flutter ( 4703): *** ECB part 2 with padding not working correctly !

I/flutter ( 4703): pt2 hex:              4142434445464748494a4b4c4d4e4f50

I/flutter ( 4703): pt2XorCtEcb2 round 2: 7fa9170742768245dac5d346262ff589

I/flutter ( 4703): ct ECB part 2 with padding:                           ce5c17245926da0ed40a855d8f3eb336eebbdaed7324ec4bc70d1c0343337233

I/flutter ( 4703): *** DECRYPTION manually ***

I/flutter ( 4703): ctEcb1:               3eeb54430730c50d938f980a6b61bad9

I/flutter ( 4703): ctEcb2:                                               ce5c17245926da0ed40a855d8f3eb336

I/flutter ( 4703): ct CBC part 3 with padding:                                                           4adc4af9a6ae2601538d97eb379d01a7

I/flutter ( 4703): plaintext:            6162636465666768696a6b6c6d6e6f704142434445464748494a4b4c4d4e4f503132333435

I/flutter ( 4703): *** ECB part 1 decryption

I/flutter ( 4703): dtEcb1:               56545650565456585e5c5e585e5c5e40

I/flutter ( 4703): dtEcb1XorIv:          6162636465666768696a6b6c6d6e6f70

I/flutter ( 4703): *** ECB part 2 decryption

I/flutter ( 4703): dtEcb2:               7fa9170742768245dac5d346262ff589

I/flutter ( 4703): dtEcb2XorCtEcb1:                                      4142434445464748494a4b4c4d4e4f50

I/flutter ( 4703): *** CBC part 3 decryption

I/flutter ( 4703): pt3 hex:              3132333435

I/flutter ( 4703): iv = ctEcb2:          ce5c17245926da0ed40a855d8f3eb336

I/flutter ( 4703): dt CBC part 3 with padding:                                                           3132333435

I/flutter ( 4703): *** WORKING = equal results ***


A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
