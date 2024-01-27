import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constant.dart';
import '../providers/upload_image_provider.dart';

Widget fabWidget(BuildContext context, Widget destinationRoute, WidgetRef ref) {
  return FloatingActionButton(
    onPressed: () {
      ref.read(uploadImageProvider.notifier).clearUploadImageProvider();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => destinationRoute));
    },
    shape: const CircleBorder(),
    foregroundColor: whiteColor,
    backgroundColor: mainColor,
    child: const Icon(Icons.add),
  );
}
