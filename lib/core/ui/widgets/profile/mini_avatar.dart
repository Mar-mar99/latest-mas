import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/helpers/helpers.dart';
import '../app_text.dart';
import 'avatar_gradients.dart';

class MiniAvatar extends StatelessWidget {
  final String? name;
  final String? url;
  final bool disableProfileView;
  MiniAvatar({Key? key, this.name, this.url, this.disableProfileView = false})
      : super(key: key);

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
          width: 40.0,
          height: 40.0,
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
    return InkWell(
      onTap: disableProfileView ? null : () {},
      child: Container(
          decoration: BoxDecoration(
              gradient: _buildGradient(),
              boxShadow: _buildShadow(context),
              borderRadius: const BorderRadius.all(Radius.circular(40.0)),
              border: Border.all(
                  color: Theme.of(context).colorScheme.background, width: 2.0)),
          width: 40.0,
          height: 40.0,
          child: _getAvatar()),
    );
  }

  List<BoxShadow> _buildShadow(BuildContext context) {
    return [
      BoxShadow(
          color:
              Theme.of(context).colorScheme.background.computeLuminance() > 0.5
                  ? const Color.fromRGBO(0, 0, 0, 0.11)
                  : const Color.fromRGBO(150, 150, 150, 0.1),
          offset: const Offset(0.0, 5.0),
          blurRadius: 12.0)
    ];
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
