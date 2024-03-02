import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whatsapp_stickers_plus/whatsapp_stickers_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Sticker Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StickerConverter(),
    );
  }
}

class StickerConverter extends StatefulWidget {
  @override
  _StickerConverterState createState() => _StickerConverterState();
}

class _StickerConverterState extends State<StickerConverter> {
  File _imageFile;

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _convertToSticker() async {
    if (_imageFile == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final stickerPath = '${directory.path}/whatsapp_sticker.png';

    // Convert image to sticker
    await WhatsappStickersPlus.convertToSticker(
      imagePath: _imageFile.path,
      stickerPath: stickerPath,
      stickerSize: StickerSize.Large,
    );

    print('Sticker saved successfully at: $stickerPath');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Sticker Converter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile != null
                ? Image.file(_imageFile, height: 200)
                : Text('No image selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _convertToSticker,
              child: Text('Convert to Sticker'),
            ),
          ],
        ),
      ),
    );
  }
}
