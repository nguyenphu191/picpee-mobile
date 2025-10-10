import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picpee_mobile/core/images/app_image.dart';
import 'package:picpee_mobile/models/skill_of_vendor_model.dart';
import 'package:picpee_mobile/providers/skill_provider.dart';
import 'package:provider/provider.dart';

class BeforeAfterCard extends StatefulWidget {
  final double? width;
  final double? height;
  final int designerId;
  final int skillId;

  const BeforeAfterCard({
    super.key,
    this.width,
    this.height,
    required this.designerId,
    required this.skillId,
  });

  @override
  State<BeforeAfterCard> createState() => _BeforeAfterCardState();
}

class _BeforeAfterCardState extends State<BeforeAfterCard> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDetailSkill();
    });
  }

  @override
  void didUpdateWidget(BeforeAfterCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if designerId or skillId has changed
    if (oldWidget.designerId != widget.designerId ||
        oldWidget.skillId != widget.skillId) {
      // Reset current index when designer/skill changes
      currentIndex = 0;
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }

      // Fetch new skill details
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchDetailSkill();
      });
    }
  }

  Future<void> fetchDetailSkill() async {
    print(
      "Fetching skill details for designerId: ${widget.designerId}, skillId: ${widget.skillId}",
    );
    final SkillProvider skillProvider = Provider.of<SkillProvider>(
      context,
      listen: false,
    );

    // Clear previous data first
    skillProvider.skillOfVendor = null;

    final res = await skillProvider.fetchSkillOfVendor(
      widget.designerId,
      widget.skillId,
    );
    if (!res) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load skill details.'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo(
    currentIndex + 1 <
            (_pageController.positions.isNotEmpty
                ? _pageController.position.maxScrollExtent ~/
                          _pageController.position.viewportDimension +
                      1
                : 1)
        ? currentIndex + 1
        : 0,
  );
  void _prev() => _goTo(
    currentIndex - 1 >= 0
        ? currentIndex - 1
        : (_pageController.positions.isNotEmpty
              ? _pageController.position.maxScrollExtent ~/
                    _pageController.position.viewportDimension
              : 0),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<SkillProvider>(
      builder: (context, skillProvider, child) {
        if (skillProvider.isLoading || skillProvider.skillOfVendor == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
            ),
          );
        }
        final skill = skillProvider.skillOfVendor!;
        final List<SkillImage> images = skill.images;
        return LayoutBuilder(
          builder: (context, constraints) {
            final double containerWidth = widget.width ?? constraints.maxWidth;
            final double height = widget.height ?? 300.h;
            final double imageWidth = containerWidth;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: containerWidth,
                  height: height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: PageView.builder(
                          controller: _pageController,
                          physics:
                              const NeverScrollableScrollPhysics(), // Tắt swipe
                          itemCount: images.length,
                          onPageChanged: (i) =>
                              setState(() => currentIndex = i),
                          itemBuilder: (context, index) {
                            final before = images[index].imageBefore ?? "";
                            final after = images[index].imageAfter ?? "";
                            final singleImage = images[index].imageLink ?? "";

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: images[index].typeUpload == "BEFORE_AFTER"
                                  ? CustomBeforeAfterSlider(
                                      beforeImage: before,
                                      afterImage: after,
                                      width: imageWidth,
                                      height: height,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: singleImage.isNotEmpty
                                          ? Stack(
                                              children: [
                                                // Loading placeholder
                                                Container(
                                                  width: imageWidth,
                                                  height: height,
                                                  color: Colors.grey.shade200,
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 40.w,
                                                      height: 40.h,
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 3,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Actual image
                                                Image.network(
                                                  singleImage,
                                                  width: imageWidth,
                                                  height: height,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child; // Image loaded successfully
                                                    }
                                                    return Container(
                                                      width: imageWidth,
                                                      height: height,
                                                      color:
                                                          Colors.grey.shade200,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 40.w,
                                                              height: 40.h,
                                                              child: CircularProgressIndicator(
                                                                strokeWidth: 3,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                      Color
                                                                    >(
                                                                      Colors
                                                                          .grey
                                                                          .shade600,
                                                                    ),
                                                                value:
                                                                    loadingProgress
                                                                            .expectedTotalBytes !=
                                                                        null
                                                                    ? loadingProgress
                                                                              .cumulativeBytesLoaded /
                                                                          loadingProgress
                                                                              .expectedTotalBytes!
                                                                    : null,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 12.h,
                                                            ),
                                                            Text(
                                                              'Loading image...',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey
                                                                    .shade600,
                                                                fontSize: 14.h,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) {
                                                        return Container(
                                                          width: imageWidth,
                                                          height: height,
                                                          color: Colors
                                                              .grey
                                                              .shade300,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .error_outline,
                                                                size: 48.h,
                                                                color: Colors
                                                                    .grey
                                                                    .shade500,
                                                              ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Text(
                                                                'Failed to load image',
                                                                style: TextStyle(
                                                                  color: Colors
                                                                      .grey
                                                                      .shade600,
                                                                  fontSize:
                                                                      12.h,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                ),
                                              ],
                                            )
                                          : Container(
                                              width: imageWidth,
                                              height: height,
                                              color: Colors.grey.shade200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons
                                                        .image_not_supported_outlined,
                                                    size: 64.h,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  SizedBox(height: 8.h),
                                                  Text(
                                                    'No image available',
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12.h,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ),
                            );
                          },
                        ),
                      ),

                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            'Before',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 12.h,
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.h,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            'After',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                              fontSize: 12.h,
                            ),
                          ),
                        ),
                      ),

                      // Left arrow
                      Positioned(
                        left: 0.h,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _prev,
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Icon(
                                Icons.chevron_left,
                                size: 32.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Right arrow
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _next,
                            child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              child: Icon(
                                Icons.chevron_right,
                                size: 32.h,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class CustomBeforeAfterSlider extends StatefulWidget {
  final String? beforeImage;
  final String? afterImage;
  final XFile? beforeImageFile;
  final XFile? afterImageFile;
  final double width;
  final double height;

  const CustomBeforeAfterSlider({
    super.key,
    this.beforeImage,
    this.afterImage,
    this.beforeImageFile,
    this.afterImageFile,
    required this.width,
    required this.height,
  });

  @override
  State<CustomBeforeAfterSlider> createState() =>
      _CustomBeforeAfterSliderState();
}

class _CustomBeforeAfterSliderState extends State<CustomBeforeAfterSlider> {
  double _sliderPosition = 0.5;
  bool _beforeImageLoaded = false;
  bool _afterImageLoaded = false;

  void _updateSliderPosition(double localX) {
    setState(() {
      _sliderPosition = (localX / widget.width).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      width: widget.width,
      height: widget.height,
      child: GestureDetector(
        onPanUpdate: (details) {
          _updateSliderPosition(details.localPosition.dx);
        },
        onTapDown: (details) {
          _updateSliderPosition(details.localPosition.dx);
        },
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            // Loading background for both images
            if (!_beforeImageLoaded || !_afterImageLoaded)
              Positioned(
                left: 0,
                top: 0,
                width: widget.width,
                height: widget.height,
                child: Container(
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 40.w,
                          height: 40.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey.shade600,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Loading images...',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14.h,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            Positioned.fill(
              child: widget.afterImage != null && widget.afterImage!.isNotEmpty
                  ? Image.network(
                      widget.afterImage!,
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted && !_afterImageLoaded) {
                              setState(() {
                                _afterImageLoaded = true;
                              });
                            }
                          });
                          return child;
                        }
                        return Container(
                          color: Colors
                              .transparent, // Let the background loader show
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 32.h,
                                color: Colors.grey.shade500,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'After image failed',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10.h,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : widget.afterImageFile != null
                  ? Image.file(
                      File(widget.afterImageFile!.path),
                      fit: BoxFit.cover,
                      alignment: Alignment.center,
                    )
                  : Container(color: Colors.grey.shade300),
            ),

            Positioned(
              left: 0,
              top: 0,
              width: widget.width * _sliderPosition,
              height: widget.height,
              child: ClipRect(
                child:
                    widget.beforeImage != null && widget.beforeImage!.isNotEmpty
                    ? Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            width: widget.width,
                            height: widget.height,
                            child: Image.network(
                              widget.beforeImage!,
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                            if (mounted &&
                                                !_beforeImageLoaded) {
                                              setState(() {
                                                _beforeImageLoaded = true;
                                              });
                                            }
                                          });
                                      return child;
                                    }
                                    return Container(color: Colors.transparent);
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: widget.width,
                                  height: widget.height,
                                  color: Colors.grey.shade400,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 24.h,
                                        color: Colors.grey.shade600,
                                      ),
                                      Text(
                                        'Before image failed',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 8.h,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : widget.beforeImageFile != null
                    ? Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            width: widget.width,
                            height: widget.height,
                            child: Image.file(
                              File(widget.beforeImageFile!.path),
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ),

            if (_beforeImageLoaded && _afterImageLoaded)
              Positioned(
                left: (widget.width * _sliderPosition) - 1.25,
                top: 0,
                child: Container(
                  width: 2.5,
                  height: widget.height,
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Handle (only show when images are loaded)
            if (_beforeImageLoaded && _afterImageLoaded)
              Positioned(
                left: (widget.width * _sliderPosition) - 15.h,
                top: (widget.height / 2) - 15.h,
                child: Center(
                  child: Image.asset(
                    AppImages.ArrowIcon,
                    width: 28.h,
                    height: 28.h,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
