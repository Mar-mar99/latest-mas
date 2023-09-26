class ApiConstants {
  static const String baseAppUrl = "https://dev.masbar.ae/api/";

  static const String helpUrl = 'http://masbar.ae/help';
  static const String stripeInfo = 'https://stripe.com/customers';

  ///User API
  static const String login = "user/oauth/token?x=1";
  static const String socialLogin = "user/social-login";
  static const String register = "user/signup";
  static const String resendVerificationCodeViaEmail = "user/resent_otp";
  static const String verifyEmail = "user/verify_account";
  static const String sendResetPassword = "user/email/sendPasswordResetCode";
  static const String sendPasswordResetCode = "user/forgot/password";
  static const String userResetPassword = "user/reset/password";
  static const String getUserData = "user/profile";
  static const String updateProfileAPI = "user/profile/update";
  static const String updateUserPhoneAPI = "user/profile/change-mobile";
  static const String verifyUserPhoneAPI = "user/profile/set-mobile";
  static const String changePassword = "user/profile/change/password";
  static const String getAllServiceAPI = "user/services";
  static const String getServiceInfoAPI = "user/state-services/";
  static const String addPromoCodeApi = "user/promo-codes/add";
  static const String getPromoCodeApi = "user/promo-codes";
  static const String addWalletApi = "user/wallet/charge";
  static const String getWalletApi = "user/wallet/history";
  static const String userCard = "user/card";
  static const String setDefaultCardAPI = "user/cards/set_default";
  static const String deleteCardAPI = "user/card/destory?card_id=";
  static const String requestsService = "user/requests/send";
  static const String cancelRequests = "user/requests/cancel";
  static const String requestDetails = "user/requests";
  static const String pendingRequests = "user/requests/pending";
  static const String currentActiveRequest = "user/requests/current";
  static const String userNotifications = "user/notifications";
  static const String userDeleteNotification = "user/notifications/delete/";
  static const String getRequestsHistoryUser = "user/requests/history";
  static const String getRequestsUpcomingUser = "user/requests/upcoming";
  static const String userRate = "user/requests/rate";
  static const String userLogout = "user/oauth/logout";
  static const String uaeStates = "user/states";
  static const String userDeleteAccount = "user/profile/delete";
  static const String getCategories = "user/categories";
  static const String getSavedLocation = "user/profile/locations";
  static const String deleteLocation = "user/profile/locations/delete";
  static const String saveLocation = "user/profile/locations/store";
  static const String promoCodeCategory = "user/promo-codes/categorized";
  static const String promoCodeServices = "user/promo-codes/services";
  static const String promoCodeProviders = "user/promo-codes/providers";
    static const String promoCreateRequest = "user/requests/pick-promo-provider";
  static const String favoritesCategories = "user/favourites/categorized";
  static const String favoritesServices = "user/favourites/services";
  static const String saveFavorite = "user/favourites/store";
  static const String removeFavorite = "user/favourites/destroy";
  static const String listFavorites = 'user/favourites/providers';
  static const String requestFav = 'user/requests/pick-favourite-provider';
  static const String searchServiceProviders = 'user/requests/search-providers';
  static const String requestOnlineProviders = 'user/requests/pick-provider';
  static const String requestOfflineProviders =
      'user/requests/pick-offline-provider';
  static const String requestBusyProviders = 'user/requests/pick-busy-provider';
 static const String getNotificationSettings = 'user/profile/notification-settings/get';
 static const String setNotificationSettings = 'user/profile/notification-settings/set';
 static const String acceptProviderSechdule = 'user/requests/accept-provider-schedule';



  /// Company
  static const String loginCompany = "companies/oauth/token";
  static const String updateProfileCompaniesAPI = "companies/profile/update";
  static const String getCompaniesData = "companies/profile";

  static const String loginProvider = "provider/oauth/token";
  static const String forgotCompanies = "companies/password/forgot";
  static const String resetPasswordCompaniesAPI = "companies/password/reset";
  static const String registerCompany = "companies/register";
  static const String verifyEmailCompany = "companies/verify_account";
  static const String resendVerificationCodeViaEmailCompany =
      "companies/resent_otp";
  static const String getInfoManageProviders = "companies/manage-providers";
  static const String searchManageProviders = "companies/manage-providers/list";
  static const String enableUserManageProviders =
      "companies/manage-providers/enable/";
  static const String disableUserManageProviders =
      "companies/manage-providers/disable/";
  static const String invitationManageProviders =
      "companies/manage-providers/invite";
  static const String getInvitationsManageProviders =
      "companies/manage-providers/get-invitations";
  static const String reSendInvitationsManageProviders =
      "companies/manage-providers/resend-invitation/";
  static const String deleteInvitationsManageProviders =
      "companies/manage-providers/delete-invitation/";
  static const String getDocumentAPI = "companies/get-documents";
  static const String deleteDocumentAPI = "companies/delete-document/";
  static const String uploadDocumentAPI = "companies/upload-documents";
  static const String reUploadDocumentAPI = "companies/re-upload-document/";
  static const String updateCompanyPhoneAPI = "companies/profile/change-mobile";
  static const String verifyCompanyPhoneAPI = "companies/profile/set-mobile";
  static const String companiesProfileChangePassword =
      "companies/profile/change/password";
  static const String companiesEarningDaily = "companies/summary/daily";
  static const String companiesEarningPeriod = "companies/summary/period";
  static const String expertsActivityAPI = "companies/experts/activites?page=";
  static const String expertUpcomingRequestsAPI =
      "companies/experts/upcoming-requests?page=";
  static const String expertPastRequestsAPI =
      "companies/experts/past-requests?page=";
  static const String expertListAPI = "companies/experts/list";
  static const String companiesExpertsRequestDetails =
      "companies/experts/request-details";
  static const String companiesLogout = "companies/oauth/logout";
  static const String companiesServices = "companies/services";
  static const String companiesProviders = "companies/manage-providers/lookup";
  static const String getcompanyServiceAttributes =
      "companies/manage-providers/attributes/";
  static const String saveCompanyAttributes =
      "companies/manage-providers/set-attributes";
  static const String companyDeleteAccount = "companies/profile/delete";
  static const String companyStates = "companies/profile/states";
  static const String companyServices = "companies/services";
  static const String getcompanyServicesPrices = "companies/services/prices";
  static const String getServiceAssignedProvider =
      'companies/services/assigned-providers';
  static const String assigneProviderToService =
      'companies/services/assign-provider';
  static const String removeProviderToService =
      'companies/services/remove-provider';
  static const String getCancellationSettings =
      'companies/profile/cancelation/get-config';
  static const String setCancellationSettings =
      'companies/profile/cancelation/set-config';
  static const String getPromotionList = 'companies/promotions';
  static const String viewPromotionDetails = 'companies/promotions';
  static const String createPromo = 'companies/promotions/create';
  static const String updatePromo = 'companies/promotions/update';
  static const String deletePromo = 'companies/promotions/delete';
  static const String assignServiceToPromo =
      'companies/promotions/assign-service';
  static const String removeServiceFromPromo =
      'companies/promotions/remove-service';

  static const String updatecompanyServicesPrices =
      "companies/services/update-prices";
  static const String updateCompanyStates = "companies/profile/states/update";
  static const String updateCompanyAddress = "companies/profile/address/update";

  static const String companyContract =
      'https://dashboard.masbar.ae/company/contract';

  /// Provider
  static const String verifyEmailProvider = "provider/verify-email";
  static const String resendVerificationCodeViaEmailProvider =
      "provider/resent_otp";
  static const String registerProvider = "provider/register";
  static const String incomingRequestDetails = "provider/requests/incoming";
  static const String incomingRequests = "provider/requests";
  static const String providerLocation = "provider/set-location";
  static const String providerAcceptRequest = "provider/requests/accept";
  static const String providerRejectRequest = "provider/requests/reject";
  static const String providerCancelAfterAccept = "provider/requests/cancel";
  static const String providerArrived = "provider/requests/arrived";
  static const String providerStartWorkingOnTheService =
      "provider/requests/start";
  static const String providerFinishWorkingOnTheService =
      "provider/requests/finish";
  static const String providerGoOnline = "provider/go-online";
  static const String providerGoOffline = "provider/go-offline";
  static const String currentRequests = "provider/requests/current";
  static const String markCashPaid = "provider/requests/cash-paid";
  static const String suggestAnotherTime = "provider/requests/suggest-time";
  static const String offlineRequest = "provider/requests/offline";

  static const String providerRequestDetails = "provider/requests/details";
  static const String providerNotifications = "provider/notifications";
  static const String providerDeleteNotification =
      "provider/notifications/delete/";
  static const String providerProfileUpdate = "provider/profile/update";
  static const String updateProviderPhoneAPI = "provider/profile/change-mobile";
  static const String verifyProviderPhoneAPI = "provider/profile/set-mobile";
  static const String providerProfile = "provider/profile";
  static const String providerProfileChangePassword =
      "provider/profile/change/password";
  static const String providerRequestsPast = "provider/requests/past";
  static const String providerRequestsUpcoming = "provider/requests/upcoming";
  static const String providerRate = "provider/requests/rate";
  static const String providerProfileReviews = "provider/profile/reviews";
  static const String providerEarningPeriod = "provider/summary/period";
  static const String providerEarningDaily = "provider/summary/daily";
  static const String providerLogout = "provider/oauth/logout";
  static const String providerDeleteAccount = "provider/profile/delete";
   static const String getProviderNotificationSettings = 'provider/profile/notification-settings/get';
 static const String setProviderNotificationSettings = 'provider/profile/notification-settings/set';

  static const String providerContract =
      'https://dashboard.masbar.ae/provider/contract';

  static const STORAGE_URL = "https://dev.masbar.ae/storage/";

  static const userImageDefault = 'https://reputationprotectiononline.com/wp-content/uploads/2022/04/78-786207_user-avatar-png-user-avatar-icon-png-transparent.png';
}
