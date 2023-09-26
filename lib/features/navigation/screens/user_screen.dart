// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:masbar/core/utils/enums/enums.dart';
import 'package:masbar/core/utils/extensions/navigation_extension.dart';
import 'package:masbar/features/notification/presentation/screens/notification_screen.dart';

import '../../../core/utils/enums/navigation_enums.dart';
import '../../../core/utils/helpers/permission_location_request.dart';
import '../../user/favorites/presentation/fav/screens/favorites_categories_screen.dart';
import '../../user/offeres/presentation/offers/screen/use_offer_categories_screen.dart';
import '../../user/profile/presentation/screens/profile_user_screen.dart';
import '../../user/services/presentation/homepage/screen/user_homepage_screen.dart';
import '../cubit/user_navigation_cubit.dart';
import '../widgets/nav_bottom_bar_style.dart';

class UserScreen extends StatefulWidget {
  final bool? showExploreHomepage;

  static const routName = 'user_screen';
  const UserScreen({
    Key? key,
    this.showExploreHomepage,
  }) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestLocationPermission(context, TypeAuth.user);
    });
    if (widget.showExploreHomepage != null && widget.showExploreHomepage!) {
      BlocProvider.of<UserNavigationCubit>(context)
          .getItem(NaviagtionUser.explore);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return BlocBuilder<UserNavigationCubit, UserNavigationState>(
        builder: (context, state) {
          print('user $state');
          return Scaffold(
            appBar: state.naviagtionUser != NaviagtionUser.explore
                ? AppBar(
                    title: _buildTitle(context, state),
                  )
                : null,
            bottomNavigationBar: _buildBottomBar(state),
            body: _buildBody(state),
          );
        },
      );
    });
  }

  Widget _buildTitle(BuildContext context, UserNavigationState state) {
    return AppBar(
      title: Text(
        state.naviagtionUser.getText(
          context,
        ),
      ),
    );
  }

  Widget _buildBottomBar(UserNavigationState state) {
    return StyleProvider(
      style: StyleNavBottomBar(),
      child: ConvexAppBar(
          style: TabStyle.reactCircle,
          backgroundColor: Colors.white,
          color: Colors.grey,
          activeColor: Theme.of(context).primaryColor,
          initialActiveIndex: state.index,
          curveSize: 90,
          height: 80,
          onTap: (index) {
            BlocProvider.of<UserNavigationCubit>(context)
                .getItem(NaviagtionUser.values[index]);
          },
          elevation: 2,
          items: [
            TabItem(
              icon: const Icon(Boxicons.bx_star),
              title: AppLocalizations.of(context)?.favorites ?? "",
            ),
            TabItem(
              icon: const Icon(Boxicons.bx_bell),
              title: AppLocalizations.of(context)?.notifications ?? "",
            ),
            TabItem(
              icon: Icon(Boxicons.bx_home_circle,),
              title: AppLocalizations.of(context)?.home ?? "",
            ),
            TabItem(
              icon: const Icon(Boxicons.bx_gift),
              title: AppLocalizations.of(context)?.offers,
            ),
            TabItem(
              icon: const Icon(Boxicons.bx_user),
              title: AppLocalizations.of(context)?.account ?? "",
            )
          ]),
    );
  }

  Widget _buildBody(UserNavigationState state) {
    if (state.naviagtionUser == NaviagtionUser.explore) {
      return UserHomepageScreen(
        showExplorePage: widget.showExploreHomepage,
      );
    } else if (state.naviagtionUser == NaviagtionUser.notification) {
      return const NotificationScreen(
        typeAuth: TypeAuth.user,
      );
    } else if (state.naviagtionUser == NaviagtionUser.account) {
      return const ProfileUserScreen();
    } else if (state.naviagtionUser == NaviagtionUser.offers) {
      return const UserOffersCategoriesScreen();
    } else if (state.naviagtionUser == NaviagtionUser.favorite) {
      return const FavoritesCategoriesScreen();
    } else {
      return Container();
    }
  }
}
