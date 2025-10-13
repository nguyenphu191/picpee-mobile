import 'package:flutter/widgets.dart';
import 'package:picpee_mobile/models/review_model.dart';
import 'package:picpee_mobile/services/review_service.dart';

class ReviewProvider with ChangeNotifier {
  final ReviewService _reviewService = ReviewService();
  List<ReviewModel> _vendorReview = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  int _totalPages = 1;
  int _limit = 10;

  List<ReviewModel> get vendorReview => _vendorReview;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  bool get hasMoreReviews => _currentPage < _totalPages;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoadingMore(bool value) {
    _isLoadingMore = value;
    notifyListeners();
  }

  // Fetch initial reviews (reset data)
  Future<bool> fetchReviewOfVendor(
    int vendorId, {
    int page = 1,
    int limit = 10,
  }) async {
    setLoading(true);
    _limit = limit;
    try {
      print(
        'fetchReviewOfVendor: vendorId=$vendorId, page=$page, limit=$limit',
      );

      final (reviews, totalPages) = await _reviewService.getReviewVendor(
        vendorId: vendorId,
        page: page,
        limit: limit,
      );

      print('Fetched ${reviews.length} reviews, totalPages=$totalPages');

      // Reset data - quan trọng để tránh lặp
      _vendorReview = reviews;
      _currentPage = page;
      _totalPages = totalPages;

      setLoading(false);
      return true;
    } catch (e) {
      print('Error fetching reviews: $e');
      _vendorReview = [];
      _currentPage = 1;
      _totalPages = 1;
      setLoading(false);
      return false;
    }
  }

  // Load more reviews (append data)
  Future<bool> loadMoreReviews(int vendorId) async {
    // Don't load if already loading or no more pages
    if (_isLoadingMore || !hasMoreReviews) {
      print(
        'loadMoreReviews: Skip - isLoadingMore=$_isLoadingMore, hasMoreReviews=$hasMoreReviews',
      );
      return false;
    }

    setLoadingMore(true);
    try {
      final nextPage = _currentPage + 1;
      print('loadMoreReviews: Loading page $nextPage');

      final (reviews, totalPages) = await _reviewService.getReviewVendor(
        vendorId: vendorId,
        page: nextPage,
        limit: _limit,
      );

      print('loadMoreReviews: Received ${reviews.length} reviews');
      print('Current list size before append: ${_vendorReview.length}');

      // Append new reviews to existing list - tránh duplicate
      // Chỉ thêm reviews chưa có trong list
      for (var review in reviews) {
        if (!_vendorReview.any((r) => r.id == review.id)) {
          _vendorReview.add(review);
        }
      }

      print('Current list size after append: ${_vendorReview.length}');

      _currentPage = nextPage;
      _totalPages = totalPages;

      setLoadingMore(false);
      return true;
    } catch (e) {
      print('Error loading more reviews: $e');
      setLoadingMore(false);
      return false;
    }
  }

  // Clear reviews (useful when switching vendors)
  void clearReviews() {
    _vendorReview = [];
    _currentPage = 1;
    _totalPages = 1;
    _isLoading = false;
    _isLoadingMore = false;
    notifyListeners();
  }
}
