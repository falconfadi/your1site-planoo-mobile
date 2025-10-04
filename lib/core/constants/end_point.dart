import 'dart:io';

const String headerLanguageKey =HttpHeaders.acceptLanguageHeader;
const headerAuth = HttpHeaders.authorizationHeader;
const headerAccept = HttpHeaders.acceptHeader;
const headerContentType = HttpHeaders.contentTypeHeader;

const kAccessToken = '';
const kAccessTokenExpirationDate = 'Token Expiration';
const userID = 'userId';
const accountType = 'type';

const String baseUrl = "";  // todo add the base url later

const String registerUrl = "auth/register";
const String verifyUrl = "auth/verify";
const String resendCodeUrl = "auth/resendCode";
const String loginUrl = "auth/login";
const String forgetPasswordUrl = "auth/forgetPassword";
const String resetPasswordUrl = "auth/resetPassword";
const String changePasswordUrl = "auth/changePassword";
const String logoutUrl = "auth/logout";
const String refreshTokenUrl = "auth/refreshToken";

