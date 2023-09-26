import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:masbar/core/api_service/network_service_http.dart';
import 'package:masbar/core/ui/dialogs/loading_dialog.dart';
import 'package:masbar/core/ui/widgets/app_dialog.dart';
import 'package:masbar/core/utils/helpers/toast_utils.dart';
import 'package:masbar/features/user/my_locations/data/data_source/my_locations_data_source.dart';
import 'package:masbar/features/user/my_locations/data/repositories/my_locations_repo_impl.dart';
import 'package:masbar/features/user/my_locations/presentation/bloc/delete_location_bloc.dart';
import 'package:masbar/features/user/my_locations/presentation/screens/view_my_location_screen.dart';

import '../../../../../core/ui/widgets/error_widget.dart';
import '../../../../../core/ui/widgets/loading_widget.dart';
import '../../../../../core/ui/widgets/no_connection_widget.dart';
import '../../domain/use_cases/delete_location_use_case.dart';
import '../../domain/use_cases/get_saved_locations_use_case.dart';
import '../bloc/get_saved_location_bloc.dart';

class MyLocationsScreen extends StatelessWidget {
  static const routeName = 'my_locations_screen';
  const MyLocationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _getSavedLocation(),
        ),
        BlocProvider(
          create: (context) => _getDeleteBloc(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.my_locations,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocListener<DeleteLocationBloc, DeleteLocationState>(
              listener: (context, state) {
                if (state is LoadingDeleteLocation) {
                  showLoadingDialog(context, text: 'Deleting...');
                } else if (state is DeleteLocationOfflineState) {
                  Navigator.pop(context);
                  ToastUtils.showErrorToastMessage('No internet Connection');
                } else if (state is DeleteLocationErrorState) {
                  Navigator.pop(context);
                  ToastUtils.showErrorToastMessage(
                      'An error ocureed, try again,\n ${state.message}');
                } else if (state is LoadedDeleteLocation) {
                  Navigator.pop(context);
                  BlocProvider.of<GetSavedLocationBloc>(context)
                      .add(GetLocations());
                }
              },
              child: BlocBuilder<GetSavedLocationBloc, GetSavedLocationState>(
                builder: (context, state) {
                  if (state is LoadingGetSavedLocation) {
                    return _buildLoadingState();
                  } else if (state is GetSavedLocationOfflineState) {
                    return _buildNoConnectionState(context);
                  } else if (state is GetSavedLocationErrorState) {
                    return _buildNetworkErrorState(state, context);
                  } else if (state is LoadedGetSavedLocation) {
                    return _buildData(context, state);
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildData(BuildContext context, LoadedGetSavedLocation state) {
    return state.data.isEmpty?
    Center(child: Text('No Locations'),):
     Column(
      children: [
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                height: 8,
              );
            },
            itemCount: state.data.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: UniqueKey(),
                background: Container(color: Colors.red),
                onDismissed: (direction) {
                  showDialog(
                    context: context,
                    builder: (dialogContext) {
                      return DialogItem(
                        title: 'Confirm Deletion',
                        paragraph:
                            'Are you sure you want to delete this location',
                        cancelButtonText: 'cancel',
                        cancelButtonFunction: () {
                          Navigator.pop(context);
                        },
                        nextButtonText: 'confirm',
                        nextButtonFunction: () {
                          BlocProvider.of<DeleteLocationBloc>(context)
                              .add(DeleteEvent(id: state.data[index].id));
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
                child: ListTile(
                  title: Text(
                    '${state.data[index].name}',
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ViewMyLocationScreen(
                                myLocationsEntity: state.data[index]);
                          },
                        ),
                      );
                    },
                    child: Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: Image.asset('assets/icon/icon_map.png')),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  GetSavedLocationBloc _getSavedLocation() {
    return GetSavedLocationBloc(
      getSavedLocationsUseCase: GetSavedLocationsUseCase(
        myLocationsRepo: MyLocationsRepoImpl(
          myLocationDataSource: MyLocationsDataSourceWithHttp(
            client: NetworkServiceHttp(),
          ),
        ),
      ),
    )..add(GetLocations());
  }

  NetworkErrorWidget _buildNetworkErrorState(
      GetSavedLocationErrorState state, BuildContext context) {
    return NetworkErrorWidget(
      message: state.message,
      onPressed: () {
        BlocProvider.of<GetSavedLocationBloc>(context).add(GetLocations());
      },
    );
  }

  NoConnectionWidget _buildNoConnectionState(BuildContext context) {
    return NoConnectionWidget(
      onPressed: () {
        BlocProvider.of<GetSavedLocationBloc>(context).add(GetLocations());
      },
    );
  }

  LoadingWidget _buildLoadingState() {
    return const LoadingWidget();
  }

  DeleteLocationBloc _getDeleteBloc() {
    return DeleteLocationBloc(
        deleteLocationsUseCase: DeleteLocationsUseCase(
      myLocationsRepo: MyLocationsRepoImpl(
        myLocationDataSource: MyLocationsDataSourceWithHttp(
          client: NetworkServiceHttp(),
        ),
      ),
    ));
  }
}
