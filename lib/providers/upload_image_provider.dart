import 'package:flutter_riverpod/flutter_riverpod.dart';

final uploadImageProvider = StateNotifierProvider<UploadImageProvider, String>(
  (ref) => UploadImageProvider(),
);

class UploadImageProvider extends StateNotifier<String> {
  UploadImageProvider() : super('asset/user.png');

  void setUploadImageProvider(String uploadedImage) {
    state = uploadedImage;
  }

  void clearUploadImageProvider() {
    state = 'asset/user.png';
  }
}
