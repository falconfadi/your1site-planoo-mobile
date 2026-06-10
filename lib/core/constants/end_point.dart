import 'dart:io';

const String headerLanguageKey =HttpHeaders.acceptLanguageHeader;
const headerAuth = HttpHeaders.authorizationHeader;
const headerAccept = HttpHeaders.acceptHeader;
const headerContentType = HttpHeaders.contentTypeHeader;

const kAccessToken = 'access_token';
const kAccessTokenExpirationDate = 'token_expiration';
const userID = 'user_id';
const userType = 'user_type';
const String rememberMeKey = "remember_me";

const String serverUrl = "https://planoo.net/";
const String baseUrl = "https://planoo.net/api/partner/v1/";

/// labels
const String userTypesUrl = "${serverUrl}api/label/usersTypes";
const String categoriesUrl = "${serverUrl}api/label/categories";
const String sessionDurationsUrl = "${serverUrl}api/label/sessionDuration";
const String daysUrl = "${serverUrl}api/label/weekDays";
const String facilitiesUrl = "${serverUrl}api/label/tags";
const String courseDurationsUrl = "${serverUrl}api/label/courseDuration";
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
const String deleteUserUrl = "user/delete";
const String toggleUserNotificationUrl = "user/toggleNotification";
/// court
const String createCourtUrl = "activity/create";
const String allCourtsUrl = "activity/all";
const String courtDetailsUrl = "activity/find";
const String deleteCourtUrl = "activity/delete";
const String toggleActivationCourtUrl = "activity/toggleActivation";
const String editCourtUrl = "activity/update";
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
const String allAppointmentsUrl = "appointment/all";
const String getAppointmentDetailsUrl = "appointment/find";
const String checkCourtAppointmentUrl = "appointment/check";
const String createCourtAppointmentUrl = "appointment/create";
const String cancelCourtAppointmentUrl = "appointment/cancel";
const String acceptedAppointmentsUrl = "appointment/accepted";
/// course
const String createCourseUrl = "course/create";
const String allCoursesUrl = "course/all";
const String courseDetailsUrl = "course/find";
const String deleteCourseUrl = "course/delete";
const String toggleActivationCourseUrl = "course/toggleActivation";
const String editCourseUrl = "course/update";
/// event
const String createEventUrl = "event/create";
const String allEventsUrl = "event/all";
const String eventDetailsUrl = "event/find";
const String deleteEventUrl = "event/delete";
const String toggleActivationEventUrl = "event/toggleActivation";
const String editEventUrl = "event/update";
/// notification
const String getNotificationsUrl = "notification/all";
const String viewNotificationUrl = "notification/view";
const String deleteNotificationUrl = "notification/delete";
const String clearNotificationsUrl = "notification/clear";
const String checkNewNotificationsUrl = "notification/checkNew";
/// review
const String getReviewsUrl = "review/all/";