class User {
  final String? avatar;
  final double? balance;
  final String? banner;
  final String? biography;
  final String? businessName;
  final String? code;
  final String? countryCode;
  final String? countryName;
  final String? describesBusiness;
  final String? describesSpecialty;
  final String? descriptionCompany;
  final String? firstname;
  final int id;
  final String? lastname;
  final String? paypalAccount;
  final String? phone;
  final String? phoneCode;
  final String? registrationId;
  final List<String>? registrationImages;
  final String role;
  final String? status;
  final String? statusVerify;
  final int? teamSize;
  final String? timezone;
  final String? type;
  final List<UserWorking>? userWorkings;
  final String? email;

  User({
    this.avatar,
    this.balance,
    this.banner,
    this.biography,
    this.businessName,
    this.code,
    this.countryCode,
    this.countryName,
    this.describesBusiness,
    this.describesSpecialty,
    this.descriptionCompany,
    this.firstname,
    required this.id,
    this.lastname,
    this.paypalAccount,
    this.phone,
    this.phoneCode,
    this.registrationId,
    this.registrationImages,
    required this.role,
    this.status,
    this.statusVerify,
    this.teamSize,
    this.timezone,
    this.type,
    this.userWorkings,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: json['avatar'] ?? "",
      balance: json['balance'] != null
          ? double.tryParse(json['balance'].toString()) ?? 0.0
          : 0.0,
      banner: json['banner'] ?? "",
      biography: json['biography'] ?? "",
      businessName: json['businessName'] ?? "",
      code: json['code'] ?? "",
      countryCode: json['countryCode'] ?? "",
      countryName: json['countryName'] ?? "",
      describesBusiness: json['describesBusiness'] ?? "",
      describesSpecialty: json['describesSpecialty'] ?? "",
      descriptionCompany: json['descriptionCompany'] ?? "",
      firstname: json['firstname'] ?? "",
      id: json['id'] ?? 0,
      lastname: json['lastname'] ?? "",
      paypalAccount: json['paypalAccount'] ?? "",
      phone: json['phone'] ?? "",
      phoneCode: json['phoneCode'] ?? "",
      registrationId: json['registrationId'] ?? "",
      registrationImages:
          (json['registrationImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      role: json['role'] ?? "",
      status: json['status'] ?? "",
      statusVerify: json['statusVerify'] ?? "",
      teamSize: json['teamSize'] ?? 0,
      timezone: json['timezone'] ?? "",
      type: json['type'] ?? "",
      userWorkings:
          (json['userWorkings'] as List<dynamic>?)
              ?.map((e) => UserWorking.fromJson(e))
              .toList() ??
          [],
      email: json['username'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'balance': balance,
      'banner': banner,
      'biography': biography,
      'businessName': businessName,
      'code': code,
      'countryCode': countryCode,
      'countryName': countryName,
      'describesBusiness': describesBusiness,
      'describesSpecialty': describesSpecialty,
      'descriptionCompany': descriptionCompany,
      'firstname': firstname,
      'id': id,
      'lastname': lastname,
      'paypalAccount': paypalAccount,
      'phone': phone,
      'phoneCode': phoneCode,
      'registrationId': registrationId,
      'registrationImages': registrationImages,
      'role': role,
      'status': status,
      'statusVerify': statusVerify,
      'teamSize': teamSize,
      'timezone': timezone,
      'type': type,
      'userWorkings': userWorkings?.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'User{id: $id, firstname: $firstname, lastname: $lastname, email: $email, role: $role}';
  }
}

class UserWorking {
  final String? dayOfWeek;
  final String? endTime;
  final int? id;
  final String? startTime;

  UserWorking({this.dayOfWeek, this.endTime, this.id, this.startTime});

  factory UserWorking.fromJson(Map<String, dynamic> json) {
    return UserWorking(
      dayOfWeek: json['dayOfWeek'],
      endTime: json['endTime'],
      id: json['id'],
      startTime: json['startTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dayOfWeek': dayOfWeek,
      'endTime': endTime,
      'id': id,
      'startTime': startTime,
    };
  }
}
