import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:masbar/features/company/manage_providers/domain/entities/provider_info_entity.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../domain/entities/provider_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../bloc/enable_disable_bloc.dart';

class ActiveProviderCard extends StatefulWidget {
  final ProviderEntity provider;
  ActiveProviderCard({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  State<ActiveProviderCard> createState() => _ActiveProviderCardState();
}

class _ActiveProviderCardState extends State<ActiveProviderCard> {
  late bool isActive;
  @override
  void initState() {
    super.initState();
    if (widget.provider.active == 'Yes') {
      isActive = true;
    } else {
      isActive = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),

      margin: const EdgeInsets.all(8),
      child: IntrinsicHeight(
        child: Row(

          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            widget.provider.image != null &&
                    widget.provider.image!.isNotEmpty
                ? Expanded(
                  flex: 1,
                  child: _buildImage())
                : Expanded(
                     flex: 1,
                  child: _buildEmptyImage()),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildName(),
                    _buildPhone(),
                    _buildActive(),
                    _buildEmail(),
                    const SizedBox(height: 8),
                    _buildBtn()
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  BlocBuilder<EnableDisableBloc, EnableDisableState> _buildBtn() {
    return BlocBuilder<EnableDisableBloc, EnableDisableState>(
      builder: (context, state) {
        var isLoading = false;
        if (state is LoadingEnableDisableState) {
          isLoading = true;
        }
        return Container(
          height: 50,
          child: AppButton(
            isLoading: isLoading,
            title: isActive
                ? AppLocalizations.of(context)!.disableLabel
                : AppLocalizations.of(context)!.enableLabel,
            onTap: () async {
              if (isActive) {
                BlocProvider.of<EnableDisableBloc>(context)
                    .add(DisableEvent(id: widget.provider.id!));
              } else {
                BlocProvider.of<EnableDisableBloc>(context)
                    .add(EnableEvent(id: widget.provider.id!));
              }
            },
          ),
        );
      },
    );
  }

  AppText _buildEmail() {
    return AppText(
      widget.provider.email ?? '',
      fontSize: 15,
      color: Colors.black,
    );
  }

  AppText _buildActive() {
    return AppText(
      isActive ? 'Active' : 'Inactive',
      bold: true,
      color: isActive ? Colors.green : Colors.grey,
    );
  }

  AppText _buildPhone() {
    return AppText(
      '${widget.provider.phoneCode ?? ''}${widget.provider.mobile}',
      bold: true,
      color: Colors.black,
    );
  }

  AppText _buildName() {
    return AppText(
      '${widget.provider.firstName} ${widget.provider.lastName}',
      bold: true,
      color: Colors.black,
    );
  }

  ClipRRect _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(5)),
      child: CachedNetworkImage(
        imageUrl: widget.provider.image ?? '',
        // height: 120,
        // width: 120,
        fit: BoxFit.cover,
        progressIndicatorBuilder: (context, url, downloadProgress) {
          return SizedBox(
            // height: 120,
            // width: 120,
            child: Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress ?? 0,
              ),
            ),
          );
        },
        errorWidget: (context, url, error) {
          return _buildEmptyImage();
        },
      ),
    );
  }

  Container _buildEmptyImage() {
    return Container(
      color: Colors.grey.withOpacity(0.1),
      // height: 120,
      // width: 120,
      child: const Icon(
        EvaIcons.imageOutline,
        size: 40,
      ),
    );
  }
}
