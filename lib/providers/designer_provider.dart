import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/services/deisgner_service.dart';

class DesignerProvider with ChangeNotifier {
  final DeisgnerService _designerService = DeisgnerService();
  bool _isLoading = false;
  DesignerModel? _selectedDesigner;
  List<DesignerModel> _businessDesigners = [];
  List<DesignerModel> _individualDesigners = [];
  List<SkillOfVendorModel> _portfolioSkills = [];
  List<DesignerModel> _allVendorsForSkill = [];

  DesignerModel? get selectedDesigner => _selectedDesigner;
  List<DesignerModel> get businessDesigners => _businessDesigners;
  List<DesignerModel> get individualDesigners => _individualDesigners;
  bool get isLoading => _isLoading;
  List<SkillOfVendorModel> get portfolioSkills => _portfolioSkills;
  List<DesignerModel> get allVendorsForSkill => _allVendorsForSkill;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> selectDesigner(DesignerModel designer) async {
    _selectedDesigner = designer;
    notifyListeners();
    return true;
  }

  Future<bool> fetchBusinessDesigners() async {
    print('Fetching business designers...');
    setLoading(true);
    _businessDesigners = [];
    try {
      final designers = await _designerService.fetchBusinessDesigners();
      _businessDesigners = designers;
      print('Fetched ${designers.length} business designers.');
      setLoading(false);
      return true;
    } catch (e) {
      print('Error fetching business designers: $e');
      setLoading(false);
      return false;
    }
  }

  Future<bool> fetchIndividualDesigners() async {
    print('Fetching individual designers...');
    setLoading(true);
    _individualDesigners = [];
    try {
      final designers = await _designerService.fetchIndividualDesigners();
      _individualDesigners = designers;
      print('Fetched ${designers.length} individual designers.');
      setLoading(false);
      return true;
    } catch (e) {
      print('Error fetching individual designers: $e');
      setLoading(false);
      return false;
    }
  }

  Future<bool> fetchPortfolio(int vendorId) async {
    print('Fetching portfolio for vendorId: $vendorId...');
    setLoading(true);
    _portfolioSkills = [];
    _selectedDesigner = null;
    try {
      final (designer, skills) = await _designerService.fetchPortfolio(
        vendorId,
      );
      _selectedDesigner = designer;
      _portfolioSkills = skills;
      print('Fetched portfolio with ${skills.length} skills.');
      setLoading(false);
      return true;
    } catch (e) {
      print('Error fetching portfolio: $e');
      setLoading(false);
      return false;
    }
  }

  //Lấy tất cả vendor theo skill
  Future<bool> fetchAllVendorForSkill(int skillId) async {
    notifyListeners();
    setLoading(true);
    _allVendorsForSkill = [];
    try {
      final result = await _designerService.getAllVendorsOfSkill(skillId);
      _allVendorsForSkill = result;
      print("Fetched All Vendors for Skill: ${_allVendorsForSkill.length}");
      notifyListeners();
      return true;
    } catch (e) {
      print("Error fetching all vendors for skill: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  //Add favorite designer
  Future<bool> addFavoriteDesigner(int vendorId, int skillId) async {
    notifyListeners();
    setLoading(true);
    try {
      final result = await _designerService.addFavoriteDesigner(
        vendorId,
        skillId,
      );
      print("Added favorite designer: $result");
      if (result) {
        _allVendorsForSkill = _allVendorsForSkill.map((designer) {
          if (designer.userId == vendorId) {
            final copy = designer.copyWith(
              statusFavorite: !(designer.statusFavorite ?? false),
            );
            return copy;
          }
          return designer;
        }).toList();
      }
      notifyListeners();
      return result;
    } catch (e) {
      print("Error adding favorite designer: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
