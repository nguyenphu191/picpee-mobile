class Url {
  static const String baseUrl = "https://api.picpee.com/api";
  static const String login = "$baseUrl/login";
  static const String register = "$baseUrl/login/register";
  static const String registerGoogle = "$baseUrl/register-google";
  static const String verifyEmail = "$baseUrl/verify-email";
  static const String checkExistEmail = "$baseUrl/login/check-exist";
  static const String checkExistBusinessName =
      "$baseUrl/login/check-exist-business";
  static const String getTopDesignBySkill =
      "$baseUrl/user/get-top-designer-by-skill-category";
  static const String getAllVendorForSkill =
      "$baseUrl/user/filter-designer-in-market";
  static const String getAllSkillOfVendor = "$baseUrl/user/portfolio";
  static const String getTopBusiness = "$baseUrl/user/get-verified-designer";
  static const String getReviewOfVendor = "$baseUrl/user-review/filter";
  static const String addFavoriteDesigner =
      "$baseUrl/user-favorite/add-designer-favorite";
}
