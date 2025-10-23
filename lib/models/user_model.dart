class User {
  String? avatar;
  double? balance;
  String? banner;
  String? biography;
  String? businessName;
  String? code;
  String? countryCode;
  String? countryName;
  String? describesBusiness;
  String? describesSpecialty;
  String? descriptionCompany;
  String? firstname;
  int id;
  String? lastname;
  String? paypalAccount;
  String? phone;
  String? phoneCode;
  String? registrationId;
  List<String>? registrationImages;
  String role;
  String? status;
  String? statusVerify;
  int? teamSize;
  String? timezone;
  String? type;
  List<UserWorking>? userWorkings;
  String? email;

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
      code: "",
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
      'username': email,
    };
  }

  Map<String, dynamic> updateJson() {
    return {
      'avatar': avatar,
      'biography': biography,
      'businessName': businessName,
      'countryCode': countryCode,
      'countryName': countryName,
      'descriptionCompany': descriptionCompany,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'phoneCode': phoneCode,
      'role': role,
      'teamSize': teamSize,
      'timezone': timezone,
      'username': email,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, firstname: $firstname, lastname: $lastname, email: $email, role: $role}';
  }
}

class UserWorking {
  String? dayOfWeek;
  String? endTime;
  int? id;
  String? startTime;

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
