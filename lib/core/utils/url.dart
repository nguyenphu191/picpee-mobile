class Url {
  static const String baseUrl = "http://36.50.134.201:8080/api";
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
  static const String updateAcc = "$baseUrl/user/update";
  static const String getTopBusiness = "$baseUrl/user/get-verified-designer";
  static const String getReviewOfVendor = "$baseUrl/user-review/filter";
  static const String addFavoriteDesigner =
      "$baseUrl/user-favorite/add-designer-favorite";
  static const String getListNotifications =
      "$baseUrl/notification/list-notifications";
  static const String markNotificationAsRead =
      "$baseUrl/notification/mark-as-read-by-id";
  static const String markAllNotificationsAsRead =
      "$baseUrl/notification/mark-as-read";
  static const String getCountUnreadNotifications =
      "$baseUrl/notification/count-notification-unread";
  static const String getAllProjects = "$baseUrl/project/filter";
  static const String createProject = "$baseUrl/project";
  static const String deleteProject = "$baseUrl/project/delete";
  static const String moveProjectTrash = "$baseUrl/project/move-trash";
  static const String restoreProject = "$baseUrl/project/restore";
  static const String getOrdersOfProject = "$baseUrl/project/order-info";
  static const String getVendorsOfProject = "$baseUrl/project/vendor-info";
  static const String getDetailOrder = "$baseUrl/order/customer/get-order-info";
  static const String completedOrder = "$baseUrl/order/customer/complete";
  static const String payOrder = "$baseUrl/order/customer/purchase";
  static const String disputeOrder = "$baseUrl/order/customer/dispute";
  static const String revisionOrder = "$baseUrl/order/customer/revision";
  static const String createOrder = "$baseUrl/order/customer";
  static const String deleteOrder = "$baseUrl/order/customer/delete";
  static const String getActivity = "$baseUrl/order-activity/get-by-order-id";
  static const String getComment = "$baseUrl/order/comment/filter";
  static const String addComment = "$baseUrl/order/comment";
  static const String getCheckList = "$baseUrl/order";
  static const String getAddOn = "$baseUrl/user-skill/vendor";
  static const String getAllDiscounts =
      "$baseUrl/promotion/filter-for-customer";
  static const String getDiscount = "$baseUrl/promotion/get-by-code";
  static const String applyDiscount = "$baseUrl/discount/apply-discount";
  static const String getAllSkills = "$baseUrl/skill-manager/filter";
  static const String getFavoriteDesigners =
      "$baseUrl/user-favorite/filter-designer";
}
