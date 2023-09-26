import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/features/provider/review/presentation/bloc/get_reviews_bloc.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';

import '../widgets/review_card.dart';

class ReviewScreen extends StatefulWidget {
  static const routeName = 'review_screen';
  const ReviewScreen({super.key});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // _scrollController
    //   ..removeListener(_onScroll)
    //   ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;

    if (currentScroll >= (maxScroll * 9)) {
      BlocProvider.of<GetReviewsBloc>(context).add(GetProviderReviewsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.reviewsLabel,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<GetReviewsBloc, GetReviewsState>(
            builder: (context, state) {
              switch (state.status) {
                case GetReviewStatus.loading:
                  return const LoadingWidget();
                case GetReviewStatus.success:
                case GetReviewStatus.loadingMore:
                  if (state.data.isEmpty) {
                    return Center(
                      child: Text(AppLocalizations.of(context)!.noReviewsYet),
                    );
                  }
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 4,
                          ),
                          controller: _scrollController,
                          itemCount: state.hasReachedMax ||
                                  state.total == state.data.length
                              ? state.data.length
                              : state.data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return index >= state.data.length
                                ? state.status == GetReviewStatus.success
                                    ? TextButton(
                                        onPressed: () {
                                          context
                                              .read<GetReviewsBloc>()
                                              .add(GetProviderReviewsEvent());
                                        },
                                        child: Text(
                                          'Load More',
                                          style: TextStyle(fontSize: 14),
                                        ))
                                    : const LoadingWidget()
                                : ReviewCard(
                                    review: state.data[index],
                                  );
                          },
                        ),
                      ),
                    ],
                  );
                case GetReviewStatus.error:
                  return NetworkErrorWidget(
                    message: state.errorMessage,
                    onPressed: () {
                      BlocProvider.of<GetReviewsBloc>(context)
                          .add(GetProviderReviewsEvent(
                        refresh: true,
                      ));
                    },
                  );
                case GetReviewStatus.offline:
                  return NoConnectionWidget(
                    onPressed: () {
                      BlocProvider.of<GetReviewsBloc>(context)
                          .add(GetProviderReviewsEvent(
                        refresh: true,
                      ));
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
