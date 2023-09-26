import 'dart:io';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masbar/core/network/check_internet.dart';
import 'package:masbar/features/auth/accounts/domain/entities/user_entity.dart';
import 'package:masbar/features/edit_profile/domain/use_cases/update_provider_profile_use_case.dart';

import '../../../../core/api_service/network_service_http.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/ui/dialogs/loading_dialog.dart';
import '../../../../core/ui/widgets/profile/large_avatar.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../../core/utils/helpers/helpers.dart';
import '../../../../core/utils/helpers/pick_image.dart';
import '../../../../core/utils/helpers/toast_utils.dart';
import '../../../auth/accounts/data/data sources/user_remote_data_source.dart';
import '../../../auth/accounts/data/repositories/user_repo_impl.dart';
import '../../../auth/accounts/domain/repositories/auth_repo.dart';
import '../../data/data_source/update_profile_data_source.dart';
import '../../data/repositories/update_profile_repo_impl.dart';
import '../../domain/use_cases/update_company_profile_use_case.dart';
import '../../domain/use_cases/update_user_profile_use_case.dart';
import '../bloc/edit_profile_bloc.dart';
import '../screens/profile_info_screen.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthRepo>().getUserData();
    return BlocProvider(
      create: (context) => _getEditAvatarBloc(context),
      child: Builder(builder: (context) {
        return BlocListener<EditProfileBloc, EditProfileState>(
          listener: (context, state) {
            _getEditProfileImageListener(state, context);
          },
          child: InkWell(
            onTap: () async {
              final source = await showPickerImageSheet(context);
              if (source != null) {
                File? image = await pickImage(context, source);
                if (image != null) {

                  _updateImage(context, user, image);
                }
              }
            },
            child: Stack(
              children: [
                LargeAvatar(
                  url: Helpers.getImage(
                    user!.picture,
                  ),
                  name: '${user.firstName}  ${user.lastName}',
                  disableProfileView: false,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
               color: Theme.of(context).primaryColor,
              ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20,
color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  void _updateImage(BuildContext context, UserEntity user, File image) {
    switch (
        Helpers.getUserTypeEnum(context.read<AuthRepo>().getUserData()!.type!)) {
      case TypeAuth.user:
        BlocProvider.of<EditProfileBloc>(context).add(
          SubmitUserProfileImageEvent(
            avatar: image,
            stateId: context.read<AuthRepo>().getUserData()!.stateId!,
            firstName: context.read<AuthRepo>().getUserData()!.firstName!,
            lastName: context.read<AuthRepo>().getUserData()!.lastName!,
          ),
        );
        print('user');
        break;
      case TypeAuth.company:
        BlocProvider.of<EditProfileBloc>(context).add(
          SubmitCompanyProfileImageEvent(
            avatar: image,
            state: context.read<AuthRepo>().getUserData()!.stateId!,
            firstName: context.read<AuthRepo>().getUserData()!.firstName!,
            address: context.read<AuthRepo>().getUserData()!.address!,
            local: context.read<AuthRepo>().getUserData()!.local!,
          ),
        );
        print('compnay');
        break;
      case TypeAuth.provider:
        BlocProvider.of<EditProfileBloc>(context).add(
          SubmitProviderProfileImageEvent(
            avatar: image,
            stateId: context.read<AuthRepo>().getUserData()!.stateId!,
            firstName: context.read<AuthRepo>().getUserData()!.firstName!,
            lastName: context.read<AuthRepo>().getUserData()!.lastName!,
          ),
        );
        print('provider');
        break;
    }

  }

  EditProfileBloc _getEditAvatarBloc(BuildContext context) {
    return EditProfileBloc(
        updateProviderProfileUseCase: UpdateProviderProfileUseCase(
          authRepo: context.read<AuthRepo>(),
          userRepo: UserRepoImpl(

            userRemoteDataSource: UserRemoteDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
          updateProfileRepo: UpdateProfileRepoImpl(
            updateProfileDataSource: UpdateProfileDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
            networkInfo: NetworkInfoImpl(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
        ),
        updateCompanyProfileUseCase: UpdateCompanyProfileUseCase(
          authRepo: context.read<AuthRepo>(),
          userRepo: UserRepoImpl(

            userRemoteDataSource: UserRemoteDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
          updateProfileRepo: UpdateProfileRepoImpl(
            updateProfileDataSource: UpdateProfileDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
            networkInfo: NetworkInfoImpl(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
        ),
        updateUserProfileUseCase: UpdateUserProfileUseCase(
          authRepo: context.read<AuthRepo>(),
          userRepo: UserRepoImpl(

            userRemoteDataSource: UserRemoteDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
          ),
          updateProfileRepo: UpdateProfileRepoImpl(
            updateProfileDataSource: UpdateProfileDataSourceWithHttp(
              client: NetworkServiceHttp(),
            ),
            networkInfo: NetworkInfoImpl(
              internetConnectionChecker: InternetConnectionChecker(),
            ),
          ),
        ));
  }

  void _getEditProfileImageListener(
      EditProfileState state, BuildContext context) {
    if (state is LoadingEditProfile) {
      showLoadingDialog(context);
    } else if (state is EditProfileOfflineState) {
      Navigator.pop(context);
      ToastUtils.showErrorToastMessage('No internet connection');
    } else if (state is EditProfileErrorState) {

      Navigator.pop(context);
      ToastUtils.showErrorToastMessage(state.message);
    } else if (state is DoneEditProfile) {
      ToastUtils.showSusToastMessage('The image has been updated successfully');
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProfileInfoScreen(
                typeAuth: Helpers.getUserTypeEnum(
                    context.read<AuthRepo>().getUserData()!.type!));
          },
        ),
      );
    }
  }
}
