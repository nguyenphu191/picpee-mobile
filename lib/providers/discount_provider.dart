import 'package:flutter/material.dart';
import 'package:picpee_mobile/models/discount_model.dart';
import 'package:picpee_mobile/services/discount_service.dart';

class DiscountProvider with ChangeNotifier {
  final DiscountService _discountService = DiscountService();
  bool _isLoading = false;
  List<DiscountModel> _discounts = [];
  DiscountModel? _appliedDiscount;

  List<DiscountModel> get discounts => _discounts;
  DiscountModel? get appliedDiscount => _appliedDiscount;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> fetchAllDiscounts() async {
    setLoading(true);
    _discounts = [];
    try {
      _discounts = await _discountService.fetchUserDiscounts();
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      return false;
    }
  }

  Future<bool> fetchDiscountByCode(String code, int vendorId) async {
    setLoading(true);
    _appliedDiscount = null;
    try {
      _appliedDiscount = await _discountService.fetchDiscountByCode(
        code,
        vendorId,
      );
      setLoading(false);
      return true;
    } catch (e) {
      setLoading(false);
      return false;
    }
  }
}
