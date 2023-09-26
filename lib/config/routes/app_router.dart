import 'package:flutter/material.dart';
import 'package:masbar/features/user/services/domain/entities/category_entity.dart';
import 'package:masbar/features/user/services/presentation/explore/screens/explore_services_screen.dart';
import '../../core/utils/enums/enums.dart';
import '../../features/auth/accounts/presentation/screens/login_screen.dart';
import '../../features/company/account/presentation/profile/presentation/company_emirates/screens/company_emirates_screen.dart';
import '../../features/company/account/presentation/profile/presentation/screens/company_location_screen.dart';
import '../../features/company/account/presentation/profile/presentation/screens/company_profile_screen.dart';
import '../../features/company/account/presentation/profile/presentation/screens/company_working_area.dart';
import '../../features/company/company_services/domain/entities/company_service_entity.dart';
import '../../features/company/manage_promotion/domain/entities/promotion_entity.dart';
import '../../features/company/manage_promotion/presentation/screens/assign_remove_service_screen.dart';
import '../../features/company/manage_promotion/presentation/screens/create_promo_screen.dart';
import '../../features/company/manage_promotion/presentation/screens/details_edit_promo_screen.dart';
import '../../features/company/manage_promotion/presentation/screens/manage_promotion_screen.dart';
import '../../features/company/manage_providers/presentation/screens/search_active_providers_screen.dart';
import '../../features/company/services_prices/presentation/screens/services_prices_screen.dart';
import '../../features/company/services_settings/presentation/screens/cancellation_settings.dart';
import '../../features/company/services_settings/presentation/screens/attributes_service_settings.dart';

import '../../features/auth/accounts/presentation/screens/select_signup_type_screen.dart';
import '../../core/managers/string_manager.dart';
import '../../features/auth/accounts/presentation/screens/company_signup_screen.dart';
import '../../features/auth/accounts/presentation/screens/user_signup_screen.dart';
import '../../features/auth/accounts/presentation/screens/provider_signup_screen.dart';
import '../../features/auth/accounts/presentation/screens/add_document_company_screen.dart';
import '../../features/auth/accounts/presentation/screens/add_document_provider_screen.dart';

import '../../core/ui/widgets/gallery.dart';
import '../../features/app_wrapper/app_wrapper.dart';
import '../../features/auth/accounts/presentation/screens/change_password_screen.dart';
import '../../features/auth/accounts/presentation/screens/forget_password_screen.dart';
import '../../features/company/manage_providers/presentation/screens/add_new_provider_screen.dart';
import '../../features/company/manage_providers/presentation/screens/manage_providers_screen.dart';
import '../../features/company/services_settings/presentation/screens/providers_settings_screen.dart';
import '../../features/company/services_settings/presentation/screens/services_settings_screen.dart';
import '../../features/company/summary_and_earnings/presentation/earnings/screens/company_earnings_screen.dart';
import '../../features/company/summary_and_earnings/presentation/summary/screens/company_summary_screen.dart';
import '../../features/company/user_activity/domain/entities/requets_detail_entity.dart';
import '../../features/company/user_activity/presentation/service_history/screen/company_invoice_screen.dart';
import '../../features/company/user_activity/presentation/service_history/screen/company_service_history.dart';
import '../../features/company/user_activity/presentation/service_history/screen/request_company_details_screen.dart';
import '../../features/documents_company/presentation/screens/documents_screen.dart';
import '../../features/edit_password/presentation/screens/edit_password_screen.dart';
import '../../features/edit_profile/presentation/screens/edit_company_info_screen.dart';
import '../../features/edit_profile/presentation/screens/edit_phone_screen.dart';
import '../../features/edit_profile/presentation/screens/phone_verification_screen.dart';
import '../../features/edit_profile/presentation/screens/profile_info_screen.dart';
import '../../features/edit_profile/presentation/screens/edit_state_screen.dart';
import '../../features/edit_profile/presentation/screens/edit_user_name_screen.dart';
import '../../features/edit_profile/presentation/screens/profile_edit_info_screen.dart';
import '../../features/navigation/screens/provider_screen.dart';
import '../../features/navigation/screens/user_screen.dart';
import '../../features/provider/earning_summary/presentation/earnings/screens/earning_provider_screen.dart';

import '../../features/provider/earning_summary/presentation/summary/screens/summary_provider_screen.dart';
import '../../features/provider/homepage/domain/entities/invoice_entity.dart';
import '../../features/provider/homepage/domain/entities/offline_request_entity.dart';
import '../../features/provider/homepage/domain/entities/request_provider_entity.dart';
import '../../features/provider/homepage/presentation/active_request/screens/attachments_end_service_screen.dart';
import '../../features/provider/homepage/presentation/active_request/screens/provider_invoice_request_screen.dart';
import '../../features/provider/homepage/presentation/offline_requests/screens/offline_request_provider_details.dart';
import '../../features/provider/notification_settings/presentation/screens/provider_notification_settings_screen.dart';
import '../../features/provider/review/presentation/screens/review_screen.dart';
import '../../features/provider/service_records/domain/entities/request_past_provider_entity.dart';
import '../../features/provider/service_records/domain/entities/request_upcoming_provider_entity.dart';
import '../../features/provider/service_records/presentation/screens/past_request_details_provider_screen.dart';
import '../../features/provider/service_records/presentation/screens/provider_invoice_screen.dart';
import '../../features/provider/service_records/presentation/screens/service_record_provider_screen.dart';
import '../../features/provider/service_records/presentation/screens/upcoming_request_details_provider.dart';
import '../../features/splash_screen/splash_screen.dart';
import '../../features/user/favorites/domain/entities/favorite_category_entity.dart';
import '../../features/user/favorites/presentation/fav/screens/favorites_services_screen.dart';
import '../../features/user/favorites/presentation/request_fav/screens/request_fav_provider.dart';
import '../../features/user/my_locations/domain/entities/my_location_entity.dart';
import '../../features/user/my_locations/presentation/screens/my_locations_screen.dart';
import '../../features/user/my_locations/presentation/screens/view_my_location_screen.dart';
import '../../features/user/notification_settings/presentation/screens/user_notification_settings_screen.dart';
import '../../features/user/offeres/domain/entities/offer_category_entity.dart';
import '../../features/user/offeres/domain/entities/offer_provider_entity.dart';
import '../../features/user/offeres/domain/entities/offer_service_entity.dart';
import '../../features/user/offeres/presentation/request_offer/screens/request_offer_screen.dart';
import '../../features/user/offeres/presentation/offers/screen/user_offer_providers_screen.dart';
import '../../features/user/offeres/presentation/offers/screen/user_offer_services_screen.dart';
import '../../features/user/services/domain/entities/request_details_entity.dart';
import '../../features/user/services/presentation/explore/screens/explore_categories_screen.dart';
import '../../features/user/services/presentation/explore/screens/search_services_screen.dart';
import '../../features/user/services/presentation/request_service/masbar_choosen/screens/masbar_request_service_screen.dart';
import '../../features/user/services/presentation/service_details.dart/screen/service_details_screen.dart';
import '../../features/user/services/presentation/service_details.dart/screen/user_invoice_request_screen.dart';
import '../../features/user/payment_methods/presentation/screens/add_card_screen.dart';
import '../../features/user/payment_methods/presentation/screens/payment_methods_screen.dart';
import '../../features/user/promo_code/presentation/screens/promo_code_screen.dart';
import '../../features/user/service_record/domain/entities/history_request_user_entity.dart';
import '../../features/user/service_record/presentation/screens/user_invoice_screen.dart';
import '../../features/user/service_record/presentation/screens/past_request_details_screen.dart';
import '../../features/user/service_record/presentation/screens/service_record_screen.dart';
import '../../features/user/wallet/presentation/screen/charging_wallet_screen.dart';
import '../../features/user/wallet/presentation/screen/electronic_wallet_screen.dart';
import '../../features/user_emirate/domain/entities/uae_state_entity.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case AppWrapper.routeName:
        return MaterialPageRoute(
          builder: (context) => const AppWrapper(),
        );

      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );

      case SelectSignupTypeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const SelectSignupTypeScreen(),
        );

      case UserSignupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => UserSignupScreen(),
        );

      case CompanySignupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const CompanySignupScreen(),
        );

      case AddDocumentCompanyScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => AddDocumentCompanyScreen(bloc: args['bloc']),
        );

      case AddDocumentProviderScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => AddDocumentProviderScreen(bloc: args['bloc']),
        );

      case ProviderSignupScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ProviderSignupScreen(),
        );
      case ForgetPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ForgetPasswordScreen(),
        );

      case ChangePasswordScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int id = args['id'] as int;
        TypeAuth typeAuth = args["typeAuth"] as TypeAuth;
        return MaterialPageRoute(
          builder: (context) => ChangePasswordScreen(
            id: id,
            typeAuth: typeAuth,
          ),
        );

      case DocumentsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const DocumentsScreen(),
        );

      case AttributesServiceSettings.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;

        CompanyServiceEntity companyServiceEntity =
            args['companyService'] as CompanyServiceEntity;
        return MaterialPageRoute(
          builder: (context) => AttributesServiceSettings(
              companyServiceEntity: companyServiceEntity),
        );
      case ManageProvidersScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ManageProvidersScreen(),
        );

      case AddNewProviderScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int activeExperts = args['activeExperts'] as int;
        int allowedExperts = args["allowedExperts"] as int;
        VoidCallback backHandler = args['backHandler'] as VoidCallback;
        return MaterialPageRoute(
          builder: (context) => AddNewProviderScreen(
            activeExperts: activeExperts,
            allowedExperts: allowedExperts,
            onBackHandler: backHandler,
          ),
        );

      case ProfileInfoScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final TypeAuth typeAuth = args['typeAuth'] as TypeAuth;
        return MaterialPageRoute(
          builder: (context) => ProfileInfoScreen(
            typeAuth: typeAuth,
          ),
        );
      case EditPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditPasswordScreen(),
        );

      case EditUserNameScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditUserNameScreen(),
        );

      case EditCompanyInfoScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditCompanyInfoScreen(),
        );

      case EditPhoneScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EditPhoneScreen(),
        );

      case PhoneVerificationScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        String phone = args['phone'] as String;

        return MaterialPageRoute(
          builder: (context) => PhoneVerificationScreen(phone: phone),
        );
      case EditStateScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        List<UAEStateEntity> states = args['states'] as List<UAEStateEntity>;
        UAEStateEntity selectedState = args['selectedState'] as UAEStateEntity;

        return MaterialPageRoute(
          builder: (context) =>
              EditStateScreen(selectedState: selectedState, states: states),
        );
      case PromoCodeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => PromoCodeScreen(),
        );
      case ElectronicWalletScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const ElectronicWalletScreen(),
        );

      case PaymentMethodsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const PaymentMethodsScreen(),
        );
      case AddCardScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => AddCardScreen(),
        );
      case ChargingWalletScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ChargingWalletScreen(),
        );
      case ServiceRecordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ServiceRecordScreen(),
        );
      case SearchServicesScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        CategoryEntity? data = args['category'];
        return MaterialPageRoute(
          builder: (context) => SearchServicesScreen(categoryEntity: data),
        );
      case PastRequestDetailsScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        HistoryRequestUserEntity past =
            args['past'] as HistoryRequestUserEntity;
        return MaterialPageRoute(
          builder: (context) => PastRequestDetailsScreen(past: past),
        );
      case UserInvoiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        HistoryRequestUserEntity past =
            args['past'] as HistoryRequestUserEntity;
        return MaterialPageRoute(
          builder: (context) => UserInvoiceScreen(past: past),
        );
      case Gallery.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        List<String> images = args['images'] as List<String>;
        return MaterialPageRoute(
          builder: (context) => Gallery(imagesUrl: images),
        );

      case AttachmentsEndServiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        final RequestProviderEntity requestProviderEntity = args['request'];
        return MaterialPageRoute(
          builder: (context) => AttachmentsEndServiceScreen(
              requestProviderEntity: requestProviderEntity),
        );

      case ProviderInvoiceRequestScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        double lat = args['lat'] as double;
        double lng = args['lng'] as double;
        InvoiceEntity invoice = args['invoice'] as InvoiceEntity;
        int id = args['id'] as int;
        return MaterialPageRoute(
          builder: (context) => ProviderInvoiceRequestScreen(
            lat: lat,
            lng: lng,
            invoiceEntity: invoice,
            id: id,
          ),
        );

      case ProviderScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ProviderScreen(),
        );
      case UserScreen.routName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        bool? showExplorePage = args['showExploreScreen'] as bool?;

        return MaterialPageRoute(
          builder: (context) => UserScreen(
            showExploreHomepage: showExplorePage,
          ),
        );
      case ServiceDetailsScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;

        int id = args['id'] as int;
        return MaterialPageRoute(
          builder: (context) => ServiceDetailsScreen(requestId: id),
        );
      case UserInvoiceRequestScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        RequestDetailsEntity data = args['data'] as RequestDetailsEntity;
        return MaterialPageRoute(
          builder: (context) =>
              UserInvoiceRequestScreen(requestDetailsEntity: data),
        );
      case UpcomingRequestDetailsProviderScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        RequestUpcomingProviderEntity data =
            args['data'] as RequestUpcomingProviderEntity;
        return MaterialPageRoute(
          builder: (context) =>
              UpcomingRequestDetailsProviderScreen(upcoming: data),
        );

      case PastRequestDetailsProviderScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        RequestPastProviderEntity data =
            args['data'] as RequestPastProviderEntity;
        return MaterialPageRoute(
          builder: (context) => PastRequestDetailsProviderScreen(past: data),
        );
      case ProviderInvoiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        RequestPastProviderEntity data =
            args['data'] as RequestPastProviderEntity;
        return MaterialPageRoute(
          builder: (context) => ProviderInvoiceScreen(past: data),
        );

      case ServiceRecordProviderScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ServiceRecordProviderScreen(),
        );
      case ReviewScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ReviewScreen(),
        );
      case EarningProviderScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => EarningProviderScreen(),
        );
      case SummaryProviderScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SummaryProviderScreen(),
        );
      case CompanySummaryScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanySummaryScreen(),
        );
      case CompanyEarningsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanyEarningsScreen(),
        );
      case CompanyServiceHistory.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanyServiceHistory(),
        );
      case RequestCompanyDetailsScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int id = args['id'];
        return MaterialPageRoute(
          builder: (context) => RequestCompanyDetailsScreen(id: id),
        );
      case CompanyInvoiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        RequestDetailEntity data = args['data'];
        return MaterialPageRoute(
          builder: (context) => CompanyInvoiceScreen(data: data),
        );
      case ServicesPricesScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ServicesPricesScreen(),
        );
      case CompanyEmiratesScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanyEmiratesScreen(),
        );
      case CompanyWorkingAreaScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanyWorkingAreaScreen(),
        );
      case CompanyLocationScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CompanyLocationScreen(),
        );
      case ExploreCategoriesScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ExploreCategoriesScreen(),
        );
      case ExploreServicesScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        CategoryEntity data = args['category'];
        return MaterialPageRoute(
          builder: (context) => ExploreServicesScreen(categoryEntity: data),
        );
      case ServicesSettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ServicesSettingsScreen(),
        );
      case CancelationSettings.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;

        CompanyServiceEntity companyServiceEntity =
            args['companyService'] as CompanyServiceEntity;
        return MaterialPageRoute(
          builder: (context) =>
              CancelationSettings(companyServiceEntity: companyServiceEntity),
        );
      case AssignProviderToServiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;

        CompanyServiceEntity companyServiceEntity =
            args['companyService'] as CompanyServiceEntity;
        return MaterialPageRoute(
          builder: (context) =>
              AssignProviderToServiceScreen(service: companyServiceEntity),
        );
      case MyLocationsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => MyLocationsScreen(),
        );
      case ViewMyLocationScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        MyLocationsEntity myLocationsEntity =
            args['myLocation'] as MyLocationsEntity;
        return MaterialPageRoute(
          builder: (context) =>
              ViewMyLocationScreen(myLocationsEntity: myLocationsEntity),
        );
      case SearchActiveProvidersScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => SearchActiveProvidersScreen(),
        );
      case UserOfferServicesScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        OfferCategoryEntity categoryEntity = args['category'];
        return MaterialPageRoute(
          builder: (context) =>
              UserOfferServicesScreen(categoryEntity: categoryEntity),
        );
      case UserOfferProvidersScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        OfferServiceEntity serviceEntity = args['service'];
        return MaterialPageRoute(
          builder: (context) =>
              UserOfferProvidersScreen(offerServiceEntity: serviceEntity),
        );
      case ManagePromotionScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ManagePromotionScreen(),
        );
      case CreatePromoScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => CreatePromoScreen(),
        );
      case FavoritesServicesScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        FavoriteCategoryEntity categoryEntity = args['category'];
        return MaterialPageRoute(
          builder: (context) =>
              FavoritesServicesScreen(category: categoryEntity),
        );
      case DetailsEditPromoScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int id = args['id'];
        return MaterialPageRoute(
          builder: (context) => DetailsEditPromoScreen(id: id),
        );
      case AssignRemovePromoServiceScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        PromotionEntity data = args['data'];
        return MaterialPageRoute(
          builder: (context) => AssignRemovePromoServiceScreen(data: data),
        );

      case RequestFavProviderScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int serviceId = args['serviceId'];
        int providerId = args['providerId'];
        String cancelFee = args['cancelFee'];
        return MaterialPageRoute(
          builder: (context) => RequestFavProviderScreen(
            providerId: providerId,
            serviceId: serviceId,
            cancellationFee: cancelFee,
          ),
        );

      case RequestOfferScreen.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        int serviceId = args['serviceId'];
        OfferProviderEntity provider = args['provider'];

        return MaterialPageRoute(
          builder: (context) => RequestOfferScreen(
            provider: provider,
            serviceId: serviceId,
          ),
        );
      case UserNotificationSettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => UserNotificationSettingsScreen(),
        );
      case ProviderNotificationSettingsScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ProviderNotificationSettingsScreen(),
        );
      case OfflineRequestProviderDetails.routeName:
        final args = routeSettings.arguments as Map<String, dynamic>;
        OfflineRequestEntity data = args['data'];
        return MaterialPageRoute(
          builder: (context) => OfflineRequestProviderDetails(data: data),
        );
      default:
        return unDefinedRoute();
    }
  }

  Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.noRouteFound),
        ),
        body: const Center(
          child: Text(AppStrings.noRouteFound),
        ),
      ),
    );
  }
}
