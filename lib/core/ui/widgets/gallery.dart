import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masbar/core/constants/api_constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class Gallery extends StatefulWidget {
  static const routeName = 'gallery';

  final PageController pageController;

  final List<String> imagesUrl;
  final int index;

  Gallery({required this.imagesUrl, this.index = 0})
      : pageController = PageController(initialPage: index);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  @override
  Widget build(BuildContext context) {
    var _index = widget.index;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
        PhotoViewGallery.builder(
          pageController: widget.pageController,
          itemCount: widget.imagesUrl.length,

          builder: (_, index) {
            final image = widget.imagesUrl[index];
            dynamic imageProvider = NetworkImage(ApiConstants.STORAGE_URL+image);
            // if (!image.contains('https')&&!image.contains('http')) {
            //   imageProvider = FileImage(File(image));
            // }

            return PhotoViewGalleryPageOptions(
                imageProvider: imageProvider,
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4);
          },
          onPageChanged: (index) {
            setState(() {
              _index = index;
            });
          },
        ),
        Container(
          padding:const EdgeInsets.all(16),
          child: Text(
            'image ${_index + 1}/${widget.imagesUrl.length}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ]),
    );
  }

}
