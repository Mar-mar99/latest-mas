import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/ui/widgets/app_text.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../../../core/ui/widgets/app_drop_down.dart';

import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../summary_and_earnings/presentation/summary/widgets/date_range_picker.dart';

import '../bloc/upcoming_history_bloc.dart';
import '../widgets/upcoming_service_history_card.dart';

class UpcomingServiceHistoryScreen extends StatefulWidget {
  const UpcomingServiceHistoryScreen({super.key});

  @override
  State<UpcomingServiceHistoryScreen> createState() =>
      _UpcomingServiceHistoryScreenState();
}

class _UpcomingServiceHistoryScreenState
    extends State<UpcomingServiceHistoryScreen> {
  CompanyProviderEntity? selected;
  String? providerId;
  DateTime end = DateTime.now();
  DateTime from = DateTime.now();

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<UpcomingHistoryBloc>().add(LoadMoreUpcomingRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<UpcomingHistoryBloc, UpcomingHistoryState>(
          builder: (context, state) {
        switch (state.status) {
          case UpcomingRequestsStatus.loadingFirstTime:
            return LoadingWidget();
          case UpcomingRequestsStatus.loading:
            return Column(
              children: [
                _buildProvidersDropDown(context, state),
                const SizedBox(
                  height: 10,
                ),
                _buildDatePicker(context),
                const SizedBox(
                  height: 20,
                ),
                const LoadingWidget(),
              ],
            );
          case UpcomingRequestsStatus.success:
            return CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                      child: _buildProvidersDropDown(context, state)),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 10,
                    ),
                  ),
                  SliverToBoxAdapter(child: _buildDatePicker(context)),
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 20,
                    ),
                  ),
                  _buildList(state),
                ]);
          case UpcomingRequestsStatus.offline:
            return NoConnectionWidget(onPressed: () {
              context.read<UpcomingHistoryBloc>().add(
                    LoadFirstTimeUpcomingRequestsEvent(),
                  );
            });

          case UpcomingRequestsStatus.error:
            return NetworkErrorWidget(
                message: state.errorMessage,
                onPressed: () {
                  context.read<UpcomingHistoryBloc>().add(
                        LoadFirstTimeUpcomingRequestsEvent(),
                      );
                });
        }
      }),
    );
  }

  Widget _buildList(UpcomingHistoryState state) {
    if (state.data.isEmpty) {
      return SliverToBoxAdapter(
          child: Text(AppLocalizations.of(context)!.noUpcomingServiceYet));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return index >= state.data.length
              ? const LoadingWidget()
              : UpcomingServiceHistoryCard(
                  data: state.data[index],
                );
        },
        childCount:
            state.hasReachedMax ? state.data.length : state.data.length + 1,
      ),
    );
  }

  DropdownMenuItem<CompanyProviderEntity> _buildProviderDropMenuItem(
      BuildContext context, CompanyProviderEntity e) {
    return DropdownMenuItem<CompanyProviderEntity>(
      value: e,
      child: Text(
        e.name,
      ),
    );
  }

  Widget _buildProvidersDropDown(
      BuildContext context, UpcomingHistoryState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          AppLocalizations.of(context)?.expertLabel ?? "",
          bold: true,
        ),
        const SizedBox(
          height: 10,
        ),
        AppDropDown<CompanyProviderEntity>(
          hintText: 'ALL',
          items: state.providers
              .map((e) => _buildProviderDropMenuItem(context, e))
              .toList(),
          initSelectedValue: selected,
          onChanged: (value) {
            setState(() {
              providerId = value.id.toString();
              selected = value;
            });
            context.read<UpcomingHistoryBloc>().add(
                  DateOrProviderChangedEvent(
                    from: from,
                    to: end,
                    providerId: value.id.toString(),
                  ),
                );
          },
        )
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText(
          AppLocalizations.of(context)?.dateLabel ?? "",
          bold: true,
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => DateRangePicker(
                        selectedFrom: from,
                        selectedTo: end,
                        select: (DateTime f, DateTime t) {
                          setState(() {
                            from = f;
                            end = t;
                          });
                          context.read<UpcomingHistoryBloc>().add(
                                DateOrProviderChangedEvent(
                                  from: from,
                                  to: end,
                                  providerId: providerId,
                                ),
                              );
                        },
                      )),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.grey.withOpacity(.3),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(5),
            ),
            child: AppText(
                '${from.year}-${from.month}-${from.day} ${AppLocalizations.of(context)?.toLabel ?? ""} ${end.year}-${end.month}-${end.day}'),
          ),
        ),
      ],
    );
  }
}
