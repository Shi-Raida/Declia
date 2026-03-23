import 'dart:typed_data';

abstract interface class ImagePickerService {
  Future<Uint8List?> pickGalleryImage({
    double maxWidth,
    double maxHeight,
    int imageQuality,
  });
}
