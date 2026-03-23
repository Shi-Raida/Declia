import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

import 'image_picker_service.dart';

class DefaultImagePickerService implements ImagePickerService {
  const DefaultImagePickerService();

  @override
  Future<Uint8List?> pickGalleryImage({
    double maxWidth = 300,
    double maxHeight = 300,
    int imageQuality = 70,
  }) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    return picked?.readAsBytes();
  }
}
