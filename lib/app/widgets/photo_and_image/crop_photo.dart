import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui' ;
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:path_provider/path_provider.dart';

class CropPhoto extends StatefulWidget {
  final void Function(File) callback;
  final File photo;
  const CropPhoto({Key? key, required this.photo, required this.callback, }) : super(key: key);

  @override
  State<CropPhoto> createState() => _CropPhotoState();
}

class _CropPhotoState extends State<CropPhoto> {
  final controller = CropController(
    aspectRatio: 0.7,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),

  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Crop photo', style: TextStyle(color: Colors.black),),
      backgroundColor: Colors.white,
    ),
    body: Center(
      child: CropImage(
        controller: controller,
        image: Image.file(widget.photo),
        paddingSize: 25.0,
        alwaysMove: true,
        minimumImageSize: 500,
        maximumImageSize: 500,

      ),
    ),
    bottomNavigationBar: _buildButtons(),
  );

  Future<File> saveUiImageToFile(ui.Image image) async {
    final ByteData? data = await image.toByteData(format: ImageByteFormat.png);
    if (data == null) {
      Log.printELog('Failed to convert ui.Image to ByteData');
      return File('path');
    }
    final bytes = data.buffer.asUint8List();
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/cropped_image.png';

    // Step 4: Write the bytes to a file
    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  Widget _buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          controller.rotation = CropRotation.up;
          controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
          controller.aspectRatio = 1.0;
        },
      ),
      IconButton(
        icon: const Icon(Icons.aspect_ratio),
        onPressed: _aspectRatios,
      ),
      IconButton(
        icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
        onPressed: _rotateLeft,
      ),
      IconButton(
        icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
        onPressed: _rotateRight,
      ),
      TextButton(
        onPressed: _finished,
        child: const Text('Done'),
      ),
    ],
  );

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            // special case: no aspect ratio
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );
    if (value != null) {
      controller.aspectRatio = value == -1 ? null : value;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {

    ui.Image image = await controller.croppedBitmap();
    Image photo = await controller.croppedImage();
    File photoPath = await saveUiImageToFile(image);

    if (mounted) {
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            contentPadding: const EdgeInsets.all(6.0),
            titlePadding: const EdgeInsets.all(8.0),
            title: const Text('Cropped image'),
            children: [
              Text('relative: ${controller.crop}'),
              Text('pixels: ${controller.cropSize}'),
              const SizedBox(height: 5),
              photo,
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  widget.callback(File(photoPath.path));
                  Navigator.pop(context);
                  },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}