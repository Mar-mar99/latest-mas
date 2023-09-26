import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';

import '../../../../../../core/ui/widgets/app_drop_down.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../services_settings/domain/entities/company_provider_entity.dart';
import '../../../../summary_and_earnings/presentation/summary/widgets/date_range_picker.dart';
import '../bloc/past_history_bloc.dart';
import '../widgets/past_service_history_card.dart';

class PastServiceHistoryScreen extends StatefulWidget {
  const PastServiceHistoryScreen({super.key});

  @override
  State<PastServiceHistoryScreen> createState() =>
      _PastServiceHistoryScreenState();
}

class _PastServiceHistoryScreenState extends State<PastServiceHistoryScreen> {
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
      context.read<PastHistoryBloc>().add(LoadMorePastRequestsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: BlocBuilder<PastHistoryBloc, PastHistoryState>(
          builder: (context, state) {
        switch (state.status) {
          case PastRequestsStatus.loadingFirstTime:
            return LoadingWidget();
          case PastRequestsStatus.loading:
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
          case PastRequestsStatus.success:
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
          case PastRequestsStatus.offline:
            return NoConnectionWidget(onPressed: () {
              context.read<PastHistoryBloc>().add(
                    LoadFirstTimePastRequestsEvent(),
                  );
            });

          case PastRequestsStatus.error:
            return NetworkErrorWidget(
                message: state.errorMessage,
                onPressed: () {
                  context.read<PastHistoryBloc>().add(
                        LoadFirstTimePastRequestsEvent(),
                      );
                });
        }
      }),
    );
  }

  Widget _buildList(PastHistoryState state) {
    if (state.data.isEmpty) {
      return SliverToBoxAdapter(
          child: Text(AppLocalizations.of(context)!.noPastServicesYet));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return index >= state.data.length
              ? const LoadingWidget()
              : PastServiceHistoryCard(
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

  Widget _buildProvidersDropDown(BuildContext context, PastHistoryState state) {
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
            context.read<PastHistoryBloc>().add(
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
                          context.read<PastHistoryBloc>().add(
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
