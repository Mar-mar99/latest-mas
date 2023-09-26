import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masbar/core/ui/widgets/profile/avatar_gradients.dart';

import '../../../utils/helpers/helpers.dart';
import '../app_text.dart';

class LargeAvatar extends StatelessWidget {
  LargeAvatar(
      {Key? key,
      this.name,
      this.url,
      this.uid,
      this.disableProfileView = false,
      this.disableShadow = false})
      : super(key: key);

  final String? name;
  final String? uid;
  final String? url;
  final bool disableProfileView;
  final bool disableShadow;

  Widget _getAvatar() {
    if (url != null && url!.isNotEmpty && Uri.parse(url!).isAbsolute) {
      return _buildImage();
    } else if (name == null || name!.isEmpty) {
      return _buildEmpty();
    } else {
      return _buildNameFirstLetter();
    }
  }

  Center _buildNameFirstLetter() {
    return Center(
      child: AppText(
        name![0].toUpperCase(),
        color: Colors.white,
        fontSize: 25,
      ),
    );
  }

  Center _buildEmpty() {
    return const Center(
      child: AppText(
        "",
        color: Colors.white,
      ),
    );
  }

  Center _buildImage() {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(120.0)),
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          width: 120,
          height: 120.0,
          imageUrl:Helpers.getImage(url!.trim()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disableProfileView ? null : () {},
      child: Container(
          decoration: BoxDecoration(
            gradient: _buildGradient(),
            boxShadow: _buildShadow(),
            borderRadius: const BorderRadius.all(Radius.circular(120.0)),
            border: Border.all(
              color: Theme.of(context).colorScheme.background,
              width: 7.0,
            ),
          ),
          width: 120.0,
          height: 120.0,
          child: _getAvatar()),
    );
  }

  List<BoxShadow> _buildShadow() {
    return disableShadow
              ? []
              : [
                  const BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      offset: Offset(0.0, 5.0),
                      blurRadius: 16.0)
                ];
  }

  LinearGradient _buildGradient() {
    return LinearGradient(
              begin: const Alignment(-1, -1),
              end: const Alignment(1, 1),
              colors: AvatarGradients.getGradients(name ?? ""));
  }
}
