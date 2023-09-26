// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/helpers/helpers.dart';
import '../app_text.dart';
import 'avatar_gradients.dart';

class FullAvatar extends StatelessWidget {
  final String? name;
  final String? url;
  const FullAvatar({
    Key? key,
    this.name,
    this.url,
  }) : super(key: key);

  Widget _getAvatar() {
    if (url != null && url!.isNotEmpty && Uri.parse(url!).isAbsolute) {
      return _buildImage();
    } else if (name == null || name!.isEmpty) {
      return _buidEmpty();
    } else {
      return _buildFirstLetter();
    }
  }

  Center _buildImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(60.0)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          // width: 100.0,
          // height: 100.0,
          imageUrl: Helpers.getImage(url!.trim()),
        ),
      ),
    );
  }

  Center _buildFirstLetter() {
    return Center(
        child: AppText(
      name![0].toUpperCase(),
      color: Colors.white,
    ));
  }

  Center _buidEmpty() {
    return const Center(
        child: AppText(
      '',
      color: Colors.white,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: _buildGradient(),

            borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            border: Border.all(
                color: Theme.of(context).colorScheme.background, width: 4.0)),
        // width: 100.0,
        // height: 100.0,
        child: _getAvatar());
  }



  LinearGradient _buildGradient() {
    return LinearGradient(
        begin: const Alignment(-1, -1),
        end: const Alignment(1, 1),
        colors: (url != null && url!.isNotEmpty && Uri.parse(url!).isAbsolute)
            ? [Colors.transparent, Colors.transparent]
            : AvatarGradients.getGradients(name ?? ""));
  }
}
