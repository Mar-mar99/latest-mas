// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/detail_request_item.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/gallery.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/ui/widgets/profile/mini_avatar.dart';
import '../../../../../../core/ui/widgets/small_button.dart';
import '../../../data/data_source/user_activity_data_source.dart';
import '../../../data/repositories/user_activity_repo_impl.dart';
import '../../../domain/use_cases/get_request_details_use_case.dart';
import '../bloc/get_request_details_bloc.dart';
import 'company_invoice_screen.dart';

class RequestCompanyDetailsScreen extends StatelessWidget {
  static const routeName = 'request_company_details_screen';
  final int id;
  const RequestCompanyDetailsScreen({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getBloc(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<GetRequestDetailsBloc, GetRequestDetailsState>(
            builder: (context, state) {
              if (state is LoadingGetRequestDetails) {
                return _buildLoading(context);
              } else if (state is GetRequestDetailsOfflineState) {
                return _buildNoInternet(context);
              } else if (state is GetRequestDetailsErrorState) {
                return _buildError(state, context);
              } else if (state is DoneGetRequestDetails) {
                return _buildInfo(context, state);
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildInfo(BuildContext context, DoneGetRequestDetails state) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.detailsServiceLabel),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if ((state.data.status!) == 'COMPLETED')
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                        border: Border.all(width: 0.2, color: Colors.grey)),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              MiniAvatar(
                                url: state.data.user!.picture ?? '',
                                name: state.data.user!.firstName ?? '',
                                disableProfileView: true,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              _buildUser(state),
                              const Spacer(),
                              if (state.data.rating != null &&
                                  state.data.rating!.providerRating != 0)
                                _buildProviderRating(state)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                if ((state.data.status!) == 'COMPLETED')
                  const SizedBox(
                    height: 8,
                  ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      border: Border.all(width: 0.2, color: Colors.grey)),
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.only(
                          top: 12, left: 20, right: 20, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          if ((state.data.status!) == 'COMPLETED')
                            _buildTotal(context, state),
                          if ((state.data.status!) == 'COMPLETED') ...[
                            const SizedBox(
                              height: 12,
                            ),
                            const Divider(),
                          ],
                          const SizedBox(
                            height: 10,
                          ),
                          _buildStatus(context, state),
                          _buildServiceType(context, state),
                          if ((state.data.status!) == 'COMPLETED')
                            _buildPaymentMode(context, state),
                          if ((state.data.status!) == 'COMPLETED')
                            _buildStartAt(context, state),
                          if ((state.data.status!) != 'COMPLETED')
                            _buildCancelBtn(context, state),
                          if ((state.data.status!) != 'COMPLETED')
                            _buildCancelReason(context, state),
                          if ((state.data.afterComment ?? '').isNotEmpty)
                            _buildProviderComment(context, state),
                          _buildAddress(context, state),
                          const SizedBox(
                            height: 10,
                          ),
                          if (state.data.imagesBefore!.isNotEmpty)
                            _buildImageBefore(context, state),
                          const SizedBox(
                            height: 10,
                          ),
                          if (state.data.imagesAfter!.isNotEmpty)
                            _buildImageAfter(context, state),
                          const SizedBox(
                            height: 150,
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
        bottomSheet: (state.data.status!) != 'COMPLETED'
            ? Container(
                height: 0,
              )
            : _buildInvoiceBtn(context,state));
  }

  Column _buildUser(DoneGetRequestDetails state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          '${state.data.user!.firstName ?? ''} ${state.data.user!.lastName ?? ''}',
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          children: [
            AppText(
              state.data.user!.rating ?? '',
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 15,
            )
          ],
        )
      ],
    );
  }

  Row _buildProviderRating(DoneGetRequestDetails state) {
    return Row(
      children: [
        AppText(
          '${state.data.rating?.providerRating ?? ''}',
          bold: true,
        ),
        const Icon(
          Icons.star,
          color: Colors.amber,
          size: 15,
        )
      ],
    );
  }

  Row _buildTotal(BuildContext context, DoneGetRequestDetails state) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          AppLocalizations.of(context)?.priceLabel ?? "",
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        const Spacer(),
        AppText(
          '${state.data.payment?.total ?? ''}${AppLocalizations.of(context)?.uadLabel ?? ""}',
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }

  DetailRequestItem _buildStatus(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.startLabel ?? "",
      subTitle: state.data.status ?? '',
    );
  }

  DetailRequestItem _buildServiceType(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.typeOfService ?? "",
      subTitle: state.data.serviceType?.name ?? '',
    );
  }

  DetailRequestItem _buildPaymentMode(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.paymentMethod ?? "",
      subTitle: state.data.paymentMode ?? '',
    );
  }

  DetailRequestItem _buildStartAt(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.serviceDate ?? "",
      subTitle: state.data.startedAt ?? '',
    );
  }

  DetailRequestItem _buildCancelBtn(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelLabel ?? "",
      subTitle: state.data.cancelledBy ?? '',
    );
  }

  DetailRequestItem _buildCancelReason(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title: AppLocalizations.of(context)?.cancelReason ?? "",
      subTitle: state.data.cancelReason ?? '',
    );
  }

  DetailRequestItem _buildProviderComment(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
      title:
          AppLocalizations.of(context)?.commentProvider ?? "Comment Provider",
      subTitle: state.data.afterComment ?? '',
    );
  }

  DetailRequestItem _buildAddress(
      BuildContext context, DoneGetRequestDetails state) {
    return DetailRequestItem(
        title: AppLocalizations.of(context)?.serviceLocation ?? "",
        subTitle: state.data.sAddress ?? '',
        isLast: true);
  }

  SmallButton _buildImageBefore(
      BuildContext context, DoneGetRequestDetails state) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(context, Gallery.routeName, arguments: {
          'images': state.data.imagesBefore,
        });
      },
      title: AppLocalizations.of(context)?.viewImageBefore ?? "",
    );
  }

  SmallButton _buildImageAfter(
      BuildContext context, DoneGetRequestDetails state) {
    return SmallButton(
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        Navigator.pushNamed(context, Gallery.routeName, arguments: {
          'images': state.data.imagesAfter,
        });
      },
      title: AppLocalizations.of(context)?.viewImageAfter ?? "",
    );
  }

  Widget _buildInvoiceBtn(BuildContext context, DoneGetRequestDetails state) {
    return Container(
      height: 80,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppButton(
          onTap: () {
             Navigator.pushNamed(context, CompanyInvoiceScreen.routeName,arguments: {'data':state.data});

          },
          title: AppLocalizations.of(context)?.viewInvoiceLabel ?? "",
        ),
      ),
    );
  }

  Widget _buildError(GetRequestDetailsErrorState state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailsServiceLabel),
      ),
      body: NetworkErrorWidget(
          message: state.message,
          onPressed: () {
            BlocProvider.of<GetRequestDetailsBloc>(context)
                .add(GetDetailsEvent(id: id.toString()));
          }),
    );
  }

  Widget _buildNoInternet(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detailsServiceLabel),
      ),
      body: NoConnectionWidget(onPressed: () {
        BlocProvider.of<GetRequestDetailsBloc>(context)
            .add(GetDetailsEvent(id: id.toString()));
      }),
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.detailsServiceLabel),
        ),
        body: LoadingWidget());
  }

  GetRequestDetailsBloc _getBloc() {
    return GetRequestDetailsBloc(
        getRequestDetailsUseCase: GetRequestDetailsUseCase(
      userActivityRepo: UserActivityRepoImpl(
        userActivityDataSource: UserActivityDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ))
      ..add(GetDetailsEvent(id: id.toString()));
  }
}
