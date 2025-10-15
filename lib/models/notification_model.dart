// notification_model.dart
class NotificationModel {
  int id;
  Sender sender;
  String title;
  String text;
  NotificationContent content;
  DateTime createdTime;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.sender,
    required this.title,
    required this.text,
    required this.content,
    required this.createdTime,
    required this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      sender: Sender.fromJson(json['sender'] ?? {}),
      title: json['title'] ?? '',
      text: json['text'] ?? '',
      content: NotificationContent.fromJson(json['content'] ?? {}),
      createdTime: DateTime.fromMillisecondsSinceEpoch(
        (json['createdTime'] ?? 0),
      ),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender.toJson(),
      'title': title,
      'text': text,
      'content': content.toJson(),
      'createdTime': createdTime.millisecondsSinceEpoch,
      'isRead': isRead,
    };
  }
}

class Sender {
  final int id;
  final String username;
  final String lastname;
  final String firstname;
  final String businessName;
  final String countryName;
  final String countryCode;
  final String phoneCode;
  final String phone;
  final String timezone;
  final String avatar;

  Sender({
    required this.id,
    required this.username,
    required this.lastname,
    required this.firstname,
    required this.businessName,
    required this.countryName,
    required this.countryCode,
    required this.phoneCode,
    required this.phone,
    required this.timezone,
    required this.avatar,
  });

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username'] ?? '',
      lastname: json['lastname'] ?? '',
      firstname: json['firstname'] ?? '',
      businessName: json['businessName'] ?? '',
      countryName: json['countryName'] ?? '',
      countryCode: json['countryCode'] ?? '',
      phoneCode: json['phoneCode'] ?? '',
      phone: json['phone'] ?? '',
      timezone: json['timezone'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'lastname': lastname,
      'firstname': firstname,
      'businessName': businessName,
      'countryName': countryName,
      'countryCode': countryCode,
      'phoneCode': phoneCode,
      'phone': phone,
      'timezone': timezone,
      'avatar': avatar,
    };
  }
}

class NotificationContent {
  final String link;
  final String userIds;

  NotificationContent({required this.link, required this.userIds});

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      link: json['link'] ?? '',
      userIds: json['userIds']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'link': link, 'userIds': userIds};
  }
}
