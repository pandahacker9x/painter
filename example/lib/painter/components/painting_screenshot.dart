
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Container that holds the size of a finished drawing and the drawed data as [Picture].
class PaintingScreenshot {
  /// The drawings data as [Picture].
  final Picture picture;

  /// The width of the drawing.
  final int width;

  /// The height of the drawing.
  final int height;

  /// Creates an immutable instance with the given drawing information.
  const PaintingScreenshot(this.picture, this.width, this.height);

  /// Converts the [picture] to an [Image].
  Future<Image> toImage() => picture.toImage(width, height);

  /// Converts the [picture] to a PNG and returns the bytes of the PNG.
  ///
  /// This might throw a [FlutterError], if flutter is not able to convert
  /// the intermediate [Image] to a PNG.
  Future<Uint8List> toPNG() async {
    Image image = await toImage();
    ByteData? data = await image.toByteData(format: ImageByteFormat.png);
    if (data != null) {
      return data.buffer.asUint8List();
    } else {
      throw new FlutterError('Flutter failed to convert an Image to bytes!');
    }
  }
}
