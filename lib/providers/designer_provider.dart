import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/services/deisgner_service.dart';

class DesignerProvider with ChangeNotifier {
  final DeisgnerService _designerService = DeisgnerService();
  bool _isLoading = false;
  DesignerModel? _selectedDesigner;
  List<DesignerModel> _businessDesigners = [];
  List<DesignerModel> _individualDesigners = [];

  DesignerModel? get selectedDesigner => _selectedDesigner;
  List<DesignerModel> get businessDesigners => _businessDesigners;
  List<DesignerModel> get individualDesigners => _individualDesigners;
  bool get isLoading => _isLoading;

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
}
