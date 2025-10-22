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
  List<DesignerModel> _favoriteVendors = [];

  DesignerModel? get selectedDesigner => _selectedDesigner;
  List<DesignerModel> get businessDesigners => _businessDesigners;
  List<DesignerModel> get individualDesigners => _individualDesigners;
  bool get isLoading => _isLoading;
  List<SkillOfVendorModel> get portfolioSkills => _portfolioSkills;
  List<DesignerModel> get allVendorsForSkill => _allVendorsForSkill;
  List<DesignerModel> get favoriteVendors => _favoriteVendors;

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
  Future<bool> fetchAllVendorForSkill(
    int skillId, {
    bool keepData = false,
  }) async {
    print('📋 Fetching all vendors for skill ID: $skillId');
    setLoading(true);
    if (!keepData) {
      _allVendorsForSkill = [];
      _favoriteVendors = [];
    }
    notifyListeners();

    try {
      List<DesignerModel> result = await _designerService.getAllVendorsOfSkill(
        skillId,
      );

      print('✅ Fetched ${result.length} vendors for skill ID: $skillId');
      _allVendorsForSkill = result;
      notifyListeners();
      return true;
    } catch (e) {
      print("❌ Error fetching all vendors for skill: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }

  //Add favorite designer
  Future<bool> addFavoriteDesigner(
    int vendorId,
    int skillId, {
    bool remove = false,
  }) async {
    notifyListeners();
    setLoading(true);
    try {
      final result = await _designerService.addFavoriteDesigner(
        vendorId,
        skillId,
      );
      if (result) {
        _allVendorsForSkill = _allVendorsForSkill.map((designer) {
          if (designer.userId == vendorId) {
            final copy = designer.copyWith(
              statusFavorite: !(designer.statusFavorite),
            );
            return copy;
          }
          return designer;
        }).toList();
        if (remove) {
          _favoriteVendors.removeWhere(
            (designer) => designer.userId == vendorId,
          );
        }
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

  //Lấy tất cả designer yêu thích
  Future<bool> fetchFavoriteDesigners({bool keepData = false}) async {
    notifyListeners();
    setLoading(true);
    if (!keepData) {
      _favoriteVendors = [];
    }
    try {
      final result = await _designerService.fetchFavoriteDesigners();
      _favoriteVendors = result;
      notifyListeners();
      return true;
    } catch (e) {
      print("Error fetching favorite designers: $e");
      return false;
    } finally {
      setLoading(false);
    }
  }
}
