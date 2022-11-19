import 'package:file_picker/file_picker.dart';

class ImageShow {
  ImageShow._();
  static final ImageShow imageShow = ImageShow._();

  PlatformFile? pickedFile;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
  }
}
