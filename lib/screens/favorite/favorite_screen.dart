import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/theme/app_colors.dart';
import 'package:picpee_mobile/core/utils/service_hard_data.dart'
    show servicesData, ServiceItem;
import 'package:picpee_mobile/models/designer_model.dart';
import 'package:picpee_mobile/providers/designer_provider.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<ServiceItem> services = servicesData;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFavorites();
    });

    // Lắng nghe thay đổi từ search controller
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase().trim();
    });
  }

  // Hàm lọc danh sách favorites theo từ khóa
  List<DesignerModel> _filterFavorites(List<DesignerModel> favorites) {
    if (_searchQuery.isEmpty) {
      return favorites;
    }

    return favorites.where((designer) {
      // Tìm service tương ứng
      final service = services.firstWhere(
        (service) => service.id == designer.skillId,
        orElse: () => ServiceItem(
          id: 2,
          title: 'Unknown Service',
          category: '',
          description: '',
          options: [],
        ),
      );

      // Tìm kiếm theo: business name, service title, status
      final businessName = designer.businessName.toLowerCase();
      final serviceTitle = service.title.toLowerCase();
      final status = designer.getStatusReceiveOrder().toLowerCase();

      return businessName.contains(_searchQuery) ||
          serviceTitle.contains(_searchQuery) ||
          status.contains(_searchQuery);
    }).toList();
  }

  Future<void> _fetchFavorites() async {
    final designerProvider = Provider.of<DesignerProvider>(
      context,
      listen: false,
    );
    final success = await designerProvider.fetchFavoriteDesigners();
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load favorite designers'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DesignerProvider>(
      builder: (context, designerProvider, child) {
        final listFavorites = designerProvider.favoriteVendors;
        final filteredFavorites = _filterFavorites(listFavorites);

        return Scaffold(
          backgroundColor: AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Favorites',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 18.h,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _fetchFavorites,
            child: Stack(
              children: [
                Column(
                  children: [
                    // Search bar
                    Container(
                      margin: EdgeInsets.only(
                        top: 12.h,
                        left: 12.w,
                        right: 12.w,
                        bottom: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search favorites...',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () {
                                    _searchController.clear();
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey[400]!,
                              width: 1.2,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),

                    // Hiển thị số kết quả tìm kiếm
                    if (_searchQuery.isNotEmpty && listFavorites.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Row(
                          children: [
                            Text(
                              'Found ${filteredFavorites.length} result${filteredFavorites.length != 1 ? 's' : ''}',
                              style: TextStyle(
                                fontSize: 13.h,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (_searchQuery.isNotEmpty && listFavorites.isNotEmpty)
                      SizedBox(height: 8.h),

                    // List of favorites
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 12.w),
                        child: filteredFavorites.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _searchQuery.isEmpty
                                          ? Icons.favorite_border
                                          : Icons.search_off,
                                      size: 64.h,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 16.h),
                                    Text(
                                      _searchQuery.isEmpty
                                          ? 'No favorites found'
                                          : 'No results for "$_searchQuery"',
                                      style: TextStyle(
                                        fontSize: 16.h,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (_searchQuery.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 8.h),
                                        child: Text(
                                          'Try different keywords',
                                          style: TextStyle(
                                            fontSize: 14.h,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: filteredFavorites.length,
                                itemBuilder: (context, index) {
                                  final item = filteredFavorites[index];
                                  return _buildItemCard(item, services);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
                if (designerProvider.isLoading)
                  Container(color: Colors.black.withOpacity(0.3)),
                if (designerProvider.isLoading)
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10.r,
                            offset: Offset(0, 5.h),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.buttonGreen,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "Loading...",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildItemCard(DesignerModel item, List<ServiceItem> servicesData) {
    final service = servicesData.firstWhere(
      (service) => service.id == item.skillId,
      orElse: () => ServiceItem(
        id: 2,
        title: 'Unknown Service',
        category: '',
        description: '',
        options: [],
      ),
    );
    return Container(
      height: 108.h,
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  item.imageCover.trim(),
                  width: 136.w,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.buttonGreen,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 136.w,
                      height: double.infinity,
                      color: Colors.grey[200],
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey[400],
                        size: 40.h,
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 0.h,
                left: 0.h,
                child: IconButton(
                  icon: Icon(
                    item.statusFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined,
                  ),
                  onPressed: () async {
                    await Provider.of<DesignerProvider>(
                      context,
                      listen: false,
                    ).addFavoriteDesigner(
                      item.userId,
                      item.skillId,
                      remove: true,
                    );
                  },
                  iconSize: 24.h,
                  color: item.statusFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(width: 5.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  service.title,
                  style: TextStyle(
                    fontSize: 14.h,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipOval(
                      child: Image.network(
                        item.avatar.trim(),
                        width: 30.h,
                        height: 30.h,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.buttonGreen,
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 30.h,
                            height: 30.h,
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.person,
                              color: Colors.grey[400],
                              size: 20.h,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            item.businessName,
                            style: TextStyle(
                              fontSize: 14.h,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14.h, color: Colors.amber),
                              SizedBox(width: 4.w),
                              Text(
                                '${_formatPrice(item.ratingPoint)} ',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '(${item.totalReview} reviews)',
                                style: TextStyle(
                                  fontSize: 12.h,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: item.getStatusColor(),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.getStatusIcon().icon,
                        color: item.getStatusColor(),
                        size: 14.h,
                      ),
                      SizedBox(width: 3.h),
                      Text(
                        item.getStatusReceiveOrder(),
                        style: TextStyle(
                          color: item.getTextColor(),
                          fontSize: 12.h,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price == price.toInt()) {
      return price.toInt().toString();
    }
    String fixed = price.toStringAsFixed(2);
    if (fixed.endsWith('0')) {
      return price.toStringAsFixed(1);
    }
    return fixed;
  }
}
