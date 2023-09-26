import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../service_history/screen/company_service_history.dart';
import '../bloc/get_user_activity_bloc.dart';
import '../widgets/user_activity_card.dart';

class UserActivityScreen extends StatefulWidget {
  static const routeName = 'user_activity_screen';
  const UserActivityScreen({super.key});

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {
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
      context.read<GetUserActivityBloc>().add(GetProvidersActivityEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.userActivity,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: BlocBuilder<GetUserActivityBloc, GetUserActivityState>(
              builder: (context, state) {
            switch (state.status) {
              case GetUserActivityStatus.loading:
                return const LoadingWidget();
              case GetUserActivityStatus.success:
                if (state.data.isEmpty) {
                  return Center(
                    child:
                        Text(AppLocalizations.of(context)!.empty_user_activity),
                  );
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                        controller: _scrollController,
                        itemCount: state.hasReachedMax||state.total==state.data.length
                            ? state.data.length
                            : state.data.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          return index >= state.data.length
                              ? const LoadingWidget()
                              : UserActivityCard(
                                  userActivity: state.data[index],
                                );
                        },
                      ),
                    ),
                  ],
                );
              case GetUserActivityStatus.error:
                return NetworkErrorWidget(
                  message: state.errorMessage,
                  onPressed: () {
                    context
                        .read<GetUserActivityBloc>()
                        .add(GetProvidersActivityEvent(refresh: true));
                  },
                );
              case GetUserActivityStatus.offline:
                return NoConnectionWidget(
                  onPressed: () {
                    context
                        .read<GetUserActivityBloc>()
                        .add(GetProvidersActivityEvent(refresh: true));
                  },
                );
            }
          }),
        ),
        bottomSheet: _buildBtn(context),
      );
    });
  }

  Padding _buildBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AppButton(
        onTap: () async {
          Navigator.pushNamed(
                                context, CompanyServiceHistory.routeName);
        },
        title: AppLocalizations.of(context)?.historyLabel ?? "",
      ),
    );
  }
}
