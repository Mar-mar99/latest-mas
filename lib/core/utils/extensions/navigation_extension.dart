import 'package:flutter/material.dart';

import '../enums/navigation_enums.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension NaviagtionUserExtension on NaviagtionUser {
  String getText(BuildContext context) {
    switch (this) {
      case NaviagtionUser.explore:
        return AppLocalizations.of(context)?.home ?? "";
      case NaviagtionUser.notification:
        return AppLocalizations.of(context)?.notifications ?? "";
      case NaviagtionUser.account:
        return AppLocalizations.of(context)?.account ?? "";
         case NaviagtionUser.offers:
        return AppLocalizations.of(context)?.offers ?? "";
      case NaviagtionUser.favorite:
       return AppLocalizations.of(context)?.favorites ?? "";
        ;
    }
  }
}

extension NavigationCompanyExtension on NavigationCompany {
  String getText(BuildContext context) {
    switch (this) {
      case NavigationCompany.summary:
        return AppLocalizations.of(context)?.home ?? "";
      case NavigationCompany.notification:
        return AppLocalizations.of(context)?.notifications ?? "";

      case NavigationCompany.account:
        return AppLocalizations.of(context)?.account ?? "";
    }
  }
}

extension NavigationProviderExtension on NavigationProvider {
  String getText(BuildContext context) {
    switch (this) {
      case NavigationProvider.homepage:
        return AppLocalizations.of(context)?.home ?? "";
      case NavigationProvider.notification:
        return AppLocalizations.of(context)?.notifications ?? "";

      case NavigationProvider.account:
        return AppLocalizations.of(context)?.account ?? "";
    }
  }
}
