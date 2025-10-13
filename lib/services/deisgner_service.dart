import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/services/auth_service.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;

class DeisgnerService {
  Future<List<DesignerModel>> fetchBusinessDesigners() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse(Url.getTopBusiness),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'limit': 4}),
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      final data = res['data'] as List;
      return data.map((json) => DesignerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load business designers');
    }
  }

  Future<List<DesignerModel>> fetchIndividualDesigners() async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.post(
      Uri.parse(Url.getTopBusiness),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "statusUser": "ACTIVE",
        "typeUser": "INDIVIDUAL",
        "limit": 4,
      }),
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      final data = res['data'] as List;
      return data.map((json) => DesignerModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load individual designers');
    }
  }

  Future<(DesignerModel, List<SkillOfVendorModel>)> fetchPortfolio(
    int vendorId,
  ) async {
    print('Fetching portfolio for vendorId from service: $vendorId');
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception('No token found');
    }
    final response = await http.get(
      Uri.parse("${Url.getAllSkillOfVendor}/$vendorId"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final res = json.decode(response.body);
      final data = res['data'];
      final designer = DesignerModel.fromJson(data);
      final skills = (data['userSkills'] as List)
          .map((json) => SkillOfVendorModel.fromJson(json))
          .toList();
      return (designer, skills);
    } else {
      throw Exception('Failed to load designer by ID');
    }
  }

  Future<int> getAllVendorsCount(int skillId) async {
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.getAllVendorForSkill),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"skillId": skillId}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      int count = data['count'];
      return count;
    } else {
      throw Exception("Failed to load skills: ${response.body}");
    }
  }

  //Lấy danh sách tất cả vendor của skill
  Future<List<DesignerModel>> getAllVendorsOfSkill(int skillId) async {
    print("Fetching all vendors for skill ID: $skillId");
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final count = await getAllVendorsCount(skillId);
    print("Total vendors count for skill ID $skillId: $count");
    final response = await http.post(
      Uri.parse(Url.getAllVendorForSkill),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"skillId": skillId, "limit": count}),
    );
    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final listdesigners = data['list'] as List<dynamic>;
      List<DesignerModel> designers = listdesigners
          .map((e) => DesignerModel.fromJson(e))
          .toList();
      return designers;
    } else {
      throw Exception("Failed to load skills: ${response.body}");
    }
  }

  //Add favorite designer
  Future<bool> addFavoriteDesigner(int designerId, int skillId) async {
    print("Adding favorite designer ID: $designerId for skill ID: $skillId");
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }
    final response = await http.post(
      Uri.parse(Url.addFavoriteDesigner),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"userId": designerId, "skillId": skillId}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print("Failed to add favorite designer: ${response.body}");
      return false;
    }
  }
}
