import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/features/company/manage_providers/domain/entities/provider_entity.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'package:masbar/features/company/manage_providers/domain/entities/provider_info_entity.dart';
import 'package:masbar/features/company/manage_providers/presentation/bloc/delete_invitation_bloc.dart';
import 'package:masbar/features/company/manage_providers/presentation/bloc/resend_invitation_bloc.dart';

import '../../../../../core/ui/widgets/app_button.dart';
import '../../../../../core/ui/widgets/app_text.dart';
import '../../domain/entities/provider_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PendingProviderCard extends StatelessWidget {
  final ProviderEntity provider;
  PendingProviderCard({
    Key? key,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: .5,
          ),
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              provider.image != null && provider.image!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      child: CachedNetworkImage(
                        imageUrl:Helpers.getImage(provider.image) ,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) {
                          return SizedBox(
                            height: 120,
                            width: 120,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress ?? 0,
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            color: Colors.grey.withOpacity(0.1),
                            height: 120,
                            width: 120,
                            child: const Icon(
                              EvaIcons.imageOutline,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    )
                  : Container(
                      color: Colors.grey.withOpacity(0.1),
                      height: 120,
                      width: 120,
                      child: const Icon(
                        EvaIcons.imageOutline,
                        size: 40,
                      ),
                    ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppText(
                        '${provider.firstName} ${provider.lastName}',
                        bold: true,
                        color: Colors.black,
                      ),
                      AppText(
                        provider.expertMobile ?? '',
                        bold: true,
                        color: Colors.black,
                      ),
                      AppText(
                        provider.email ?? '',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ]),
              ),
            ],
          ),
          const SizedBox(height:16 ,),
          Row(
            children: [
              Expanded(
                child: BlocBuilder<ResendInvitationBloc, ResendInvitationState>(
                  builder: (context, state) {
                    var isLoading = false;
                    if (state is LoadingResendInvitationState) {
                      isLoading = true;
                    }
                    return AppButton(
                      isLoading: isLoading,
                      buttonColor: ButtonColor.transparentBorderPrimary,
                      title: AppLocalizations.of(context)?.resendLabel ?? "",
                      onTap: () async {
                        BlocProvider.of<ResendInvitationBloc>(context)
                            .add(ResendEvent(id: provider.id!));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: BlocBuilder<DeleteInvitationBloc, DeleteInvitationState>(
                  builder: (context, state) {
                    var isLoading = false;
                    if (state is LoadingDeleteInvitationState) {
                      isLoading = true;
                    }
                    return AppButton(
                      title: AppLocalizations.of(context)?.delete ?? "",
                      isLoading: isLoading,
                      onTap: () async {
                        BlocProvider.of<DeleteInvitationBloc>(context)
                            .add(DeleteEvent(id: provider.id!));
                      },
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
