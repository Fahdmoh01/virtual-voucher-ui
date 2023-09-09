class APIEndpoints {
  // final String baseUrl = "https://api.evoucher.my/api-v1/";
  // static const String baseUrl = "http://192.168.137.1:8000/api-v1/"; //no vpn ip
  // static const String baseUrl = "http://10.12.18.103:8000/api-v1/"; //vpn ip
  static const String baseUrl =
      "http://159.223.204.68/api-v1/"; // actual server ip - digital ocean
  static const String login = "${baseUrl}login/";
  static const String signup = "${baseUrl}sign-up/";
  static const String logout = "${baseUrl}logout/";
  static const String stats = "${baseUrl}stats/";
  static const String creditWallet = "${baseUrl}credit-wallet/";
  static const String debitWallet = "${baseUrl}debit-wallet/";
  static const String events = "${baseUrl}cud-event/";
  static const String vouchers = "${baseUrl}cud-voucher/";
  static const String allEvents = "${baseUrl}all-events/";
  static const String allVouchers = "${baseUrl}all-vouchers/";
  static const String redeemVouchers = "${baseUrl}redeem-voucher/";
  static const String changeProfile = "${baseUrl}change-profile/";
  static const String joinEvent = "${baseUrl}add-participant/";
  static const String broadcastVoucher = "${baseUrl}broadcast-voucher/";
}
