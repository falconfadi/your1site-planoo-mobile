import 'dart:io';

const String headerLanguageKey =HttpHeaders.acceptLanguageHeader;
const headerAuth = HttpHeaders.authorizationHeader;
const headerAccept = HttpHeaders.acceptHeader;
const headerContentType = HttpHeaders.contentTypeHeader;

const kAccessToken = 'access_token';
const kAccessTokenExpirationDate = 'token_expiration';
const kLastTokenRefresh = 'last_token_refresh';
const userID = 'user_id';
const userType = 'user_type';

const String serverUrl = "https://planoo.net/api";
const String baseUrl = "https://planoo.net/api/partner/v1/";

/// labels
const String userTypesUrl = "$serverUrl/label/usersTypes";
const String categoriesUrl = "$serverUrl/label/categories";
const String sessionDurationsUrl = "$serverUrl/label/sessionDuration";
const String daysUrl = "$serverUrl/label/weekDays";
const String facilitiesUrl = "$serverUrl/label/tags";
/// auth
const String registerUrl = "auth/register";
const String verifyUrl = "auth/verify";
const String resendCodeUrl = "auth/resendCode";
const String loginUrl = "auth/login";
const String forgetPasswordUrl = "auth/forgetPassword";
const String resetPasswordUrl = "auth/resetPassword";
const String changePasswordUrl = "auth/changePassword";
const String logoutUrl = "auth/logout";
const String refreshTokenUrl = "auth/refreshToken";
/// user
const String getUserUrl = "user/get";
const String uploadProfileImageUrl = "user/uploadProfileImage";
const String deleteProfileImageUrl = "user/deleteProfileImage";
const String editUserUrl = "user/update";
/// activity
const String createActivityUrl = "activity/create";
const String allActivitiesUrl = "activity/all";
const String activityDetailsUrl = "activity/find";
const String deleteActivityUrl = "activity/delete";
const String toggleActivationActivityUrl = "activity/toggleActivation";
const String editActivityUrl = "activity/update";
/// day
const String createWorkdayUrl = "day/create";
const String allWorkdaysUrl = "day/all";
const String deleteWorkdayUrl = "day/delete";
const String toggleActivationWorkdayUrl = "day/toggleActivation";
const String editWorkdayUrl = "day/update";
/// location
const String editLocationUrl = "location/update";
/// media
const String getMediaUrl = "media/all";
const String createMediaUrl = "media/create";
const String deleteMediaUrl = "media/delete";
/// facility
const String createFacilityUrl = "tag/create";
const String deleteFacilityUrl = "tag/delete";
/// appointment
const String checkActivityAppointmentUrl = "appointment/check";
const String createActivityAppointmentUrl = "appointment/create";