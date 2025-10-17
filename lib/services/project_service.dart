import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/core/utils/url.dart' show Url;
import 'package:picpee_mobile/services/auth_service.dart';

class ProjectService {
  Future<List<ProjectModel>> fetchProjects() async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.getAllProjects),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      final projects = (data['list'] as List)
          .map((projectJson) => ProjectModel.fromJson(projectJson))
          .toList();
      //filter status
      final filteredProjects = projects
          .where((project) => project.status == 'ACTIVE')
          .toList();
      return filteredProjects;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<ProjectModel> createProject(String name) async {
    final token = await AuthService().getToken();
    final response = await http.post(
      Uri.parse(Url.createProject),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      final res = jsonDecode(response.body);
      final data = res['data'];
      return ProjectModel.fromJson(data);
    } else {
      throw Exception('Failed to create project');
    }
  }

  Future<bool> updateProject(String name, int id) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.createProject}/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProject(int id) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.deleteProject}/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> restoreProject(int id) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.restoreProject}/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> moveToTrashProject(int id) async {
    final token = await AuthService().getToken();
    final response = await http.put(
      Uri.parse("${Url.moveProjectTrash}/$id"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({}),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  /// Hàm chuyển DateTime -> chuỗi số (timestamp)
  static String dateTimeToTimestampString(DateTime date) {
    return date.millisecondsSinceEpoch.toString();
  }
}
