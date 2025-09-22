import 'dart:ui';

class Project {
  final String id;
  final String name;
  final DateTime lastOrdered;
  final String description;
  final Color iconColor;
  bool isDeleted;

  Project({
    required this.id,
    required this.name,
    required this.lastOrdered,
    required this.description,
    required this.iconColor,
    this.isDeleted = false,
  });
}
