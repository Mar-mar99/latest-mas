// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:masbar/core/ui/widgets/error_widget.dart';
import 'package:masbar/core/ui/widgets/loading_widget.dart';
import 'package:masbar/core/utils/helpers/form_submission_state.dart';

import '../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../core/ui/widgets/app_button.dart';
import '../../../../../../core/ui/widgets/app_text.dart';
import '../../../../../../core/ui/widgets/app_textfield.dart';
import '../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../../../../core/utils/helpers/show_custom_bottom_sheet.dart';
import '../../../data/data_source/explore_services_data_source.dart';
import '../../../data/repositories/explore_services_repo_impl.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../domain/use_cases/search_services_use_case.dart';
import '../bloc/search_services_bloc.dart';
import '../widgets/filter_services.dart';
import '../widgets/service_item_card.dart';

class SearchServicesScreen extends StatelessWidget {
  static const routeName = 'search_services_screen';
    final CategoryEntity? categoryEntity;
  const SearchServicesScreen({
    Key? key,
     this.categoryEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _getSearchBloc(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.searchLabel,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      _buildSearchField(context),
                      const SizedBox(
                        height: 12,
                      ),
                      BlocBuilder<SearchServicesBloc, SearchServicesState>(
                          builder: (context, state) {
                        if (state.formSubmissionState is FormSubmittingState) {
                          return _buildLoading();
                        } else if (state.formSubmissionState
                            is FormNoInternetState) {
                          return _buildOffline(context);
                        } else if (state.formSubmissionState
                            is FormNetworkErrorState) {
                          return _buildNetworkError(state, context);
                        } else if (state.formSubmissionState
                            is FormSuccesfulState) {
                          return _buildSuccessful(state, context);
                        } else if (state.formSubmissionState
                            is InitialFormState) {
                          return Container();
                        } else {
                          return Container();
                        }
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  AppTextField _buildSearchField(BuildContext context) {
    return AppTextField(
      controller: TextEditingController(),
      prefixIcon: Icons.search,
      onChanged: (value) {
        BlocProvider.of<SearchServicesBloc>(context)
            .add(KeywordChangedEvent(keyword: value));
        BlocProvider.of<SearchServicesBloc>(context).add(FilterEvent(categoryId: categoryEntity==null?null:categoryEntity?.id  ));
      },
      hintText: AppLocalizations.of(context)?.searchHint ?? "",
      suffixIcon: Icons.sort,
      suffixIconColor: Theme.of(context).primaryColor,
      onSuffixTap: () {
        showCustomBottomSheet(
          context: context,
          child: BlocProvider.value(
            value: BlocProvider.of<SearchServicesBloc>(
              context,
            ),
            child:  FilterServices(categoryEntity: categoryEntity),
          ),
        );
      },
    );
  }

  LoadingWidget _buildLoading() {
    return const LoadingWidget();
  }

  NoConnectionWidget _buildOffline(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<SearchServicesBloc>(context).add(FilterEvent(categoryId:  categoryEntity==null?null:categoryEntity?.id));

      },
    );
  }

  NetworkErrorWidget _buildNetworkError(
      SearchServicesState state, BuildContext context) {
    return NetworkErrorWidget(
      message: (state.formSubmissionState as FormNetworkErrorState).message,
      onPressed: () {
        BlocProvider.of<SearchServicesBloc>(context).add(FilterEvent(categoryId: categoryEntity==null?null:categoryEntity?.id));
      },
    );
  }

  Widget _buildSuccessful(SearchServicesState state, BuildContext context) {
    return state.data.isNotEmpty
        ? GridView.builder(
            physics:
                const BouncingScrollPhysics(), //scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 160,
              childAspectRatio: 3 / 5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            shrinkWrap: true,
            itemCount: state.data.length,
            itemBuilder: (context, index) => ServiceItemCard(
              serviceEntity: state.data[index],
            ),
          )
        : AppText(
            AppLocalizations.of(context)!.noDataLabel,
          );
  }

  SearchServicesBloc _getSearchBloc() {
    return SearchServicesBloc(
      serachServicesUseCase: SerachServicesUseCase(
        exploreServicesRepo: ExploreServicesRepoImpl(
          exploreServicesDataSource: ExploreServicesDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }
}
