import 'package:shared_preferences/shared_preferences.dart';

const String prefsOnboardingScreen = "PREFS_ONBOARDING_SCREEN";
const String prefsKeyIsUserLoggedIn = "PREFS_KEY_IS_USER_LOGGEDIN";
const String prefsKeyAccessToken = "PREFS_KEY_ACCESS_TOKEN";
const String prefsKeyLatitude = "PREFS_KEY_LATITUDE";
const String prefsKeyLongitude = "PREFS_KEY_LONGITUDE";
const String prefsKeyPaymentMethod = "PREFS_KEY_PAYMENT_METHOD";
const String prefsKeyUserEmail = "PREFS_KEY_USER_EMAIL";
const String prefsKeyUserPhoneNumber = "PREFS_KEY_USER_PHONE_NUMBER";
const String prefsKeyUserCountryCode = "PREFS_KEY_USER_COUNTRY_CODE";
const String prefsKeyUserFirstName = "PREFS_KEY_USER_FIRST_NAME";
const String prefsKeyUserLastName = "PREFS_KEY_USER_LAST_NAME";
const String prefsKeyUserGender = "PREFS_KEY_USER_GENDER";
const String prefsKeyForgotPasswordEmail = "PREFS_KEY_FORGOT_PASSWORD_EMAIL";
const String prefsKeyEmailOtpId = "PREFS_KEY_EMAIL_OTP_ID";

class AppPreferences {
  final SharedPreferences _sharedPreferences;

  AppPreferences(this._sharedPreferences);

  Future<void> setOnBoardingScreenViewed() async {
    _sharedPreferences.setBool(prefsOnboardingScreen, true);
  }

  Future<bool> isOnBoardingScreenViewed() async {
    return _sharedPreferences.getBool(prefsOnboardingScreen) ?? false;
  }

  Future<void> setAccessToken(String? accessToken) async {
    _sharedPreferences.setString(prefsKeyAccessToken, accessToken ?? "");
  }

  Future<String> getAccessToken() async {
    return _sharedPreferences.getString(prefsKeyAccessToken) ?? "";
  }

  Future<void> setLatitude(double latitude) async {
    _sharedPreferences.setDouble(prefsKeyLatitude, latitude);
  }

  double getLatitude() {
    return _sharedPreferences.getDouble(prefsKeyLatitude) ?? 0;
  }

  Future<void> setLongitude(double longitude) async {
    _sharedPreferences.setDouble(prefsKeyLongitude, longitude);
  }

  double getLongitude() {
    return _sharedPreferences.getDouble(prefsKeyLongitude) ?? 0;
  }

  Future<void> setUserEmail(String email) async {
    _sharedPreferences.setString(prefsKeyUserEmail, email);
  }

  String getUserEmail() {
    return _sharedPreferences.getString(prefsKeyUserEmail) ?? '';
  }

  Future<void> setForgotPasswordEmail(String email) async {
    _sharedPreferences.setString(prefsKeyForgotPasswordEmail, email);
  }

  String getForgotPasswordEmail() {
    return _sharedPreferences.getString(prefsKeyForgotPasswordEmail) ?? '';
  }

  Future<void> setEmailOtpId(String id) async {
    _sharedPreferences.setString(prefsKeyEmailOtpId, id);
  }

  String getEmailOtpId() {
    return _sharedPreferences.getString(prefsKeyEmailOtpId) ?? '';
  }

  Future<void> setUserPhoneNumber(int phoneNumber) async {
    _sharedPreferences.setInt(prefsKeyUserPhoneNumber, phoneNumber);
  }

  int getUserPhoneNumber() {
    return _sharedPreferences.getInt(prefsKeyUserPhoneNumber) ?? 0;
  }

  Future<void> setUserCountryCode(String countryCode) async {
    _sharedPreferences.setString(prefsKeyUserPhoneNumber, countryCode);
  }

  String getUserCountryCode() {
    return _sharedPreferences.getString(prefsKeyUserCountryCode) ?? '';
  }

  Future<void> setUserFirstName(String firstName) async {
    _sharedPreferences.setString(prefsKeyUserFirstName, firstName);
  }

  String getUserFirstName() {
    return _sharedPreferences.getString(prefsKeyUserFirstName) ?? '';
  }

  Future<void> setUserLastName(String lastName) async {
    _sharedPreferences.setString(prefsKeyUserLastName, lastName);
  }

  String getUserLastName() {
    return _sharedPreferences.getString(prefsKeyUserLastName) ?? '';
  }

  Future<void> setUserGender(String gender) async {
    _sharedPreferences.setString(prefsKeyUserGender, gender);
  }

  String getUserGender() {
    return _sharedPreferences.getString(prefsKeyUserGender) ?? '';
  }

  Future<void> logout() async {
    await _sharedPreferences.clear();

    await setOnBoardingScreenViewed();
  }
}
