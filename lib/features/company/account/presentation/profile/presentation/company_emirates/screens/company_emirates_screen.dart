import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/ui/widgets/app_button.dart';
import 'package:masbar/core/utils/helpers/helpers.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';

import '../../../../../../../../core/api_service/network_service_http.dart';
import '../../../../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../../data/date_source/company_profile_data_source.dart';
import '../../../data/repositories/company_profile_repo_impl.dart';
import '../../../domain/entities/company_emirates_entity.dart';
import '../../../domain/use_cases/get_company_emirates_use_case.dart';
import '../../../domain/use_cases/update_company_emirates_use_case.dart';
import '../bloc/get_company_emirates_bloc.dart';
import '../bloc/update_company_emirates_bloc.dart';
import '../widgets/company_emirates_widgets.dart';

class CompanyEmiratesScreen extends StatelessWidget {
  static const routeName = 'company_emirates_screen';
  CompanyEmiratesScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getEmiratesBloc(),
        ),
        BlocProvider(
          create: (context) => _getUpdateEmiratesBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return BlocListener<UpdateCompanyEmiratesBloc,
            UpdateCompanyEmiratesState>(
          listener: (context, state) {
            _buildUpdateListener(state);
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!.company_emirates),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  BlocBuilder<GetCompanyEmiratesBloc, GetCompanyEmiratesState>(
                builder: (context, state) {
                  if (state is LoadingGetCompanyEmirates) {
                    return _buildLoading(context);
                  } else if (state is GetCompanyEmiratesOfflineState) {
                    return _buildNoInternet(context);
                  } else if (state is GetCompanyEmiratesErrorState) {
                    return _buildError(state, context);
                  } else if (state is LoadedGetCompanyEmirates) {


                    return _buildData(state, context);
                  } else {
                    return Container();
                  }
                },
              ),
            )),
          ),
        );
      }),
    );
  }

  void _buildUpdateListener(UpdateCompanyEmiratesState state) {
    if (state is UpdateCompanyEmiratesOfflineState) {
      ToastUtils.showErrorToastMessage('No interner Connection');
    } else if (state is UpdateCompanyEmiratesErrorState) {
      ToastUtils.showErrorToastMessage(
          'Error has happened, ${state.message}, try again');
    } else if (state is LoadedUpdateCompanyEmirates) {
      ToastUtils.showSusToastMessage('Updated Successfully');
    }
  }

  Widget _buildData(LoadedGetCompanyEmirates state, BuildContext context) {
return CompanyEmiratesWidgets(data: state.data);
  }



  GetCompanyEmiratesBloc _getEmiratesBloc() {
    return GetCompanyEmiratesBloc(
      getCompanyEmiratesUseCase: GetCompanyEmiratesUseCase(
        companyProfileRepo: CompanyProfileRepoImpl(
          companyProfileDataSource: CompanyProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetEmiratesEvent());
  }

  UpdateCompanyEmiratesBloc _getUpdateEmiratesBloc() {
    return UpdateCompanyEmiratesBloc(
      updateCompanyEmiratesUseCase: UpdateCompanyEmiratesUseCase(
        companyProfileRepo: CompanyProfileRepoImpl(
          companyProfileDataSource: CompanyProfileDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    );
  }

  Widget _buildError(GetCompanyEmiratesErrorState state, BuildContext context) {
    return NetworkErrorWidget(
        message: state.message,
        onPressed: () {
          BlocProvider.of<GetCompanyEmiratesBloc>(context)
              .add(GetEmiratesEvent());
        });
  }

  Widget _buildNoInternet(BuildContext context) {
    return NoConnectionWidget(onPressed: () {
      BlocProvider.of<GetCompanyEmiratesBloc>(context).add(GetEmiratesEvent());
    });
  }

  Widget _buildLoading(BuildContext context) {
    return const LoadingWidget();
  }


}
