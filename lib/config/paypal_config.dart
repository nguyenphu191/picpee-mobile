class PayPalConfig {
  // PayPal Sandbox credentials - Thay bằng credentials thật khi production
  static const String clientId =
      "Ab4e9XyhStoO1vpkF8-Fepk_2YONooK8Fq-RJnCfL9c0RgDu4erEZsTcMN9ifGh8KuuarYgjUGEWdZcg";
  static const String secretKey =
      "EOAqc7QVsJGvz3AITKTbW8D9mw3hjtHpyxcjL_DYLyNvvl2DQ_uCn0Hn_i2xLoWXrQT4qt0B-BC6Z9hY";

  // Environment - true for sandbox, false for production
  static const bool sandboxMode = true;

  // URLs
  static const String returnURL = "https://picpee.com/success";
  static const String cancelURL = "https://picpee.com/cancel";

  // Currency
  static const String currency = "USD";

  // PayPal URLs
  static String get baseUrl =>
      sandboxMode ? "https://sandbox.paypal.com" : "https://api.paypal.com";
}
