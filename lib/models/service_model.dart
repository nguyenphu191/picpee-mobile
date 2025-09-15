class ServiceModel {
  final String id;
  final String title;
  final String beforeImageUrl;
  final String subtitle;
  final String afterImageUrl;
  final double rating;
  final int reviewCount;
  final String turnaroundTime;
  final double startingPrice;
  final Designer? designer;
  final int capacity;
  final String category;

  ServiceModel({
    this.id = "",
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.turnaroundTime,
    required this.startingPrice,
    required this.beforeImageUrl,
    required this.afterImageUrl,
    this.designer,
    this.capacity = 0,
    this.category = "All",
    this.subtitle = "",
  });
}

class Designer {
  final String id;
  final String name;
  final String avatarUrl;
  final double rating;
  final int completedOrders;
  final bool isAutoAccepting;

  Designer({
    required this.name,
    required this.avatarUrl,
    required this.rating,
    required this.completedOrders,
    this.id = "",
    this.isAutoAccepting = false,
  });
}
