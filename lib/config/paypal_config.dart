class PayPalConfig {
  // PayPal Sandbox credentials - Thay bằng credentials thật khi production
  static const String clientId =
      "AeWnhSMvGB4yb1SY_I9MlhRKgKKjM9lNqbxe_GlSLyLCG5RYKnhrTVMYy7A6j7TM6FRQ8sAuI5PgY8XS";
  static const String secretKey =
      "ELNZ0vNY-DcXNKW_UJ1SXDL1vfgKl5z9yGQ8v8Bq6nVVa8dKj9w4U8V3SoE3rVUa7q1B1fX1Z1qV1w";

  // Environment - true for sandbox, false for production
  static const bool sandboxMode = true;

  // URLs
  static const String returnURL = "https://picpee.com/success";
  static const String cancelURL = "https://picpee.com/cancel";

  // Currency
  static const String currency = "USD";

  // PayPal URLs
  static String get baseUrl =>
      sandboxMode ? "https://api.sandbox.paypal.com" : "https://api.paypal.com";
}
