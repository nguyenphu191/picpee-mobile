import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:picpee_mobile/models/project_model.dart';
import 'package:picpee_mobile/services/project_service.dart';

class ProjectProvider with ChangeNotifier {
  final ProjectService _projectService = ProjectService();
  bool _isloading = false;
  List<ProjectModel> _projects = [];
  ProjectModel? _currentProject;

  bool get loading => _isloading;
  List<ProjectModel> get projects => _projects;
  ProjectModel? get currentProject => _currentProject;

  void setLoading(bool value) {
    _isloading = value;
    notifyListeners();
  }

  void setCurrentProject(ProjectModel? project) {
    _currentProject = project;
    notifyListeners();
  }

  Future<bool> fetchProjects() async {
    setLoading(true);
    _projects = [];
    try {
      _projects = await _projectService.fetchProjects();
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> createProject(String name) async {
    setLoading(true);
    try {
      final newProject = await _projectService.createProject(name);
      _projects.add(newProject);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> updateProject(String name, int id) async {
    setLoading(true);
    try {
      final success = await _projectService.updateProject(name, id);
      if (success) {
        final index = _projects.indexWhere((project) => project.id == id);
        if (index != -1) {
          _projects[index] = ProjectModel(
            id: _projects[index].id,
            name: name,
            status: _projects[index].status,
            moveTrashTime: _projects[index].moveTrashTime,
            deletedTime: _projects[index].deletedTime,
            createdTime: _projects[index].createdTime,
            modifiedTime: DateFormat(
              'dd/MM/yyyy hh:mm a',
            ).format(DateTime.now()),
            lastOrderTime: _projects[index].lastOrderTime,
            skillNames: _projects[index].skillNames,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> deleteProject(int id) async {
    setLoading(true);
    try {
      final success = await _projectService.deleteProject(id);
      if (success) {
        _projects.removeWhere((project) => project.id == id);
      }
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> moveToTrash(int id) async {
    setLoading(true);
    try {
      final success = await _projectService.moveToTrashProject(id);
      if (success) {
        final index = _projects.indexWhere((project) => project.id == id);
        if (index != -1) {
          _projects[index] = ProjectModel(
            id: _projects[index].id,
            name: _projects[index].name,
            status: "INACTIVE",
            moveTrashTime: DateFormat(
              'dd/MM/yyyy hh:mm a',
            ).format(DateTime.now()),
            deletedTime: _projects[index].deletedTime,
            createdTime: _projects[index].createdTime,
            modifiedTime: DateFormat(
              'dd/MM/yyyy hh:mm a',
            ).format(DateTime.now()),
            lastOrderTime: _projects[index].lastOrderTime,
            skillNames: _projects[index].skillNames,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> restoreProject(int id) async {
    setLoading(true);
    try {
      final success = await _projectService.restoreProject(id);
      if (success) {
        final index = _projects.indexWhere((project) => project.id == id);
        if (index != -1) {
          _projects[index] = ProjectModel(
            id: _projects[index].id,
            name: _projects[index].name,
            status: "ACTIVE",
            moveTrashTime: DateFormat(
              'dd/MM/yyyy hh:mm a',
            ).format(DateTime.now()),
            deletedTime: _projects[index].deletedTime,
            createdTime: _projects[index].createdTime,
            modifiedTime: DateFormat(
              'dd/MM/yyyy hh:mm a',
            ).format(DateTime.now()),
            lastOrderTime: _projects[index].lastOrderTime,
            skillNames: _projects[index].skillNames,
          );
          notifyListeners();
        }
      }
      return success;
    } catch (e) {
      return false;
    } finally {
      setLoading(false);
    }
  }
}
