import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/designer_model.dart';
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
}
