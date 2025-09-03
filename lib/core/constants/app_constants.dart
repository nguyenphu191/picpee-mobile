class AppConstants {
  // App Info
  static const String appName = 'Legal Assistant';
  static const String appVersion = '1.0.0';

  // Firebase Configuration (sử dụng lại từ dự án web)
  static const String firebaseApiKey =
      "AIzaSyA8xrw8YpD0D6FAflNhLNn09ZhRgXFizkE";
  static const String firebaseAuthDomain = "legal-d147d.firebaseapp.com";
  static const String firebaseProjectId = "legal-d147d";
  static const String firebaseStorageBucket = "legal-d147d.firebasestorage.app";
  static const String firebaseMessagingSenderId = "564284504937";

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String conversationsCollection = 'conversations';
  static const String messagesCollection = 'messages';
  static const String documentsCollection = 'documents';

  // API Endpoints (nếu có backend API riêng)
  static const String baseApiUrl = 'https://your-api-endpoint.com';
  static const String chatApiUrl = '$baseApiUrl/chat';
  static const String documentsApiUrl = '$baseApiUrl/documents';

  // Document Types
  static const List<String> documentTypes = [
    'Luật',
    'Nghị định',
    'Thông tư',
    'Quyết định',
    'Nghị quyết'
  ];

  // Document Categories (dựa trên dự án web)
  static const List<Map<String, dynamic>> documentCategories = [
    {'id': 'business', 'name': 'Kinh doanh - Thương mại', 'count': 45123},
    {'id': 'civil', 'name': 'Dân sự', 'count': 32456},
    {'id': 'administrative', 'name': 'Hành chính', 'count': 28789},
    {'id': 'criminal', 'name': 'Hình sự', 'count': 21567},
    {'id': 'tax', 'name': 'Thuế - Phí - Lệ phí', 'count': 19234},
    {'id': 'labor', 'name': 'Lao động - Tiền lương', 'count': 16448},
    {'id': 'technology', 'name': 'Công nghệ thông tin', 'count': 14708},
  ];

  // Chat Constants
  static const int maxMessageLength = 1000;
  static const int maxMessagesPerConversation = 100;
  static const Duration typingDelay = Duration(milliseconds: 1500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;

  // Quick Actions cho Chat (từ dự án web)
  static const List<Map<String, String>> quickActions = [
    {
      'title': 'Tra cứu Luật Lao động',
      'description': 'Tìm hiểu về quyền và nghĩa vụ của người lao động',
      'query': 'Cho tôi biết về Luật Lao động mới nhất'
    },
    {
      'title': 'Soạn hợp đồng',
      'description': 'Hỗ trợ soạn thảo các loại hợp đồng',
      'query': 'Hướng dẫn tôi soạn hợp đồng lao động'
    },
    {
      'title': 'Thủ tục hành chính',
      'description': 'Hướng dẫn các thủ tục cần thiết',
      'query': 'Thủ tục đăng ký kinh doanh như thế nào?'
    },
    {
      'title': 'Tư vấn pháp lý',
      'description': 'Giải đáp các thắc mắc về pháp luật',
      'query': 'Tôi cần tư vấn về vấn đề pháp lý'
    },
  ];

  // Error Messages
  static const String networkError = 'Lỗi kết nối mạng. Vui lòng thử lại.';
  static const String serverError = 'Lỗi server. Vui lòng thử lại sau.';
  static const String authError = 'Lỗi xác thực. Vui lòng đăng nhập lại.';
  static const String unknownError = 'Có lỗi xảy ra. Vui lòng thử lại.';

  // Success Messages
  static const String loginSuccess = 'Đăng nhập thành công!';
  static const String registerSuccess = 'Đăng ký thành công!';
  static const String updateProfileSuccess = 'Cập nhật thông tin thành công!';
}
