import 'package:flutter/material.dart';

import '../constant.dart';
import 'image_widget.dart';

class ListTileContactWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final int? extraIntParam;
  final String? imageUrl;
  final Function? onTapCallback;
  final Function? onPressedCallback;

  const ListTileContactWidget({
    super.key,
    this.title,
    this.subtitle,
    this.extraIntParam,
    this.imageUrl,
    this.onTapCallback,
    this.onPressedCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(child: Text(title ?? '', overflow: TextOverflow.clip)),
          normalGap,
          extraIntParam == 1 ? const Icon(Icons.star, color: Colors.amber) : const SizedBox(width: 0),
        ],
      ),
      subtitle: Row(
        children: [
          Expanded(child: Text(subtitle ?? '', overflow: TextOverflow.clip)),
        ],
      ),
      leading: InkWell(
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.transparent,
          child: ClipOval(
            child: getImageWidget(imageUrl),
          ),
        ),
        onTap: () {
          onTapCallback?.call();
        },
      ),
      trailing: IconButton(
        onPressed: () {
          onPressedCallback?.call();
        },
        icon: const Icon(Icons.send),
        color: mainColor,
      ),
    );
  }
}
