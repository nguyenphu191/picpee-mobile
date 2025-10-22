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
    print("📋 Fetching all vendors for skill ID: $skillId");
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }

    try {
      // Lấy tổng số vendors
      final count = await getAllVendorsCount(skillId);
      print("📊 Total vendors count for skill ID $skillId: $count");

      // Gọi API để lấy danh sách vendors
      final response = await http.post(
        Uri.parse(Url.getAllVendorForSkill),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"skillId": skillId, "limit": count}),
      );

      print("📡 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final data = res['data'];

        // ✅ Kiểm tra và lấy list designers
        if (data == null) {
          print("⚠️ Data is null");
          return [];
        }

        final listdesigners = data['list'];

        if (listdesigners == null || listdesigners is! List) {
          print("⚠️ List designers is null or not a List");
          return [];
        }

        print("📋 Processing ${listdesigners.length} designers...");

        // ✅ Map từng item thành DesignerModel
        List<DesignerModel> designers = [];
        for (var item in listdesigners) {
          try {
            designers.add(DesignerModel.fromJson(item));
          } catch (e) {
            print("⚠️ Error parsing designer: $e");
            print("📦 Item data: $item");
          }
        }

        print("✅ Parsed ${designers.length} designers successfully");

        // Lấy danh sách favorite designers
        try {
          List<DesignerModel> listfavorite = await fetchFavoriteDesigners(
            skillId: skillId,
          );

          print("💖 Found ${listfavorite.length} favorite designers");

          // Đánh dấu favorite designers
          for (var designer in designers) {
            if (listfavorite.any((fav) => fav.userId == designer.userId)) {
              designer.statusFavorite = true;
            }
          }
        } catch (e) {
          print("⚠️ Error fetching favorite designers: $e");
          // Continue without favorites
        }

        return designers;
      } else {
        print("❌ Failed with status ${response.statusCode}");
        print("📄 Response body: ${response.body}");
        throw Exception("Failed to load vendors: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception in getAllVendorsOfSkill: $e");
      rethrow;
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

  //Fetch list favorite designer for 1 skill
  Future<List<DesignerModel>> fetchFavoriteDesigners({int? skillId}) async {
    print("📋 Fetching favorite designers...");
    final token = await AuthService().getToken();
    if (token == null) {
      throw Exception("No token found");
    }

    Map<String, dynamic> body = {};
    if (skillId != null) {
      body['skillId'] = skillId;
    }

    try {
      final response = await http.post(
        Uri.parse(Url.getFavoriteDesigners),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("📡 Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);

        final data = res['data'];
        if (data == null) {
          print("⚠️ Data is null");
          return [];
        }

        final listData = data['list'];
        if (listData == null || listData is! List) {
          print("⚠️ List is null or not a List");
          return [];
        }

        print("📋 Processing ${listData.length} favorite designers...");

        // ✅ Explicit type conversion with error handling
        List<DesignerModel> designers = [];
        for (var item in listData) {
          try {
            if (item is Map<String, dynamic>) {
              designers.add(DesignerModel.fromJson(item));
            } else {
              // Convert dynamic map to Map<String, dynamic>
              designers.add(
                DesignerModel.fromJson(Map<String, dynamic>.from(item as Map)),
              );
            }
          } catch (e) {
            print("⚠️ Error parsing favorite designer: $e");
            print("📦 Item data: $item");
          }
        }

        print("✅ Parsed ${designers.length} favorite designers successfully");
        return designers;
      } else {
        print("❌ Failed with status ${response.statusCode}");
        print("📄 Response body: ${response.body}");
        throw Exception("Failed to load favorite designers: ${response.body}");
      }
    } catch (e, stackTrace) {
      print("❌ Exception in fetchFavoriteDesigners: $e");
      print("📍 StackTrace: $stackTrace");
      rethrow;
    }
  }
}
