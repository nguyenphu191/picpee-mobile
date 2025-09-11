import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:picpee_mobile/core/images/app_image.dart';

class BeforeAfterCard extends StatefulWidget {
  const BeforeAfterCard({super.key});
  @override
  State<BeforeAfterCard> createState() => _BeforeAfterCardState();
}

class _BeforeAfterCardState extends State<BeforeAfterCard> {
  final PageController _pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  final List<Map<String, String>> pairs = [
    {
      'before': 'https://picsum.photos/seed/apt1/1000/700',
      'after': 'https://picsum.photos/seed/apt1_after/1000/700',
    },
    {
      'before': 'https://picsum.photos/seed/apt2/1000/700',
      'after': 'https://picsum.photos/seed/apt2_after/1000/700',
    },
    {
      'before': 'https://picsum.photos/seed/apt3/1000/700',
      'after': 'https://picsum.photos/seed/apt3_after/1000/700',
    },
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final p in pairs) {
      precacheImage(NetworkImage(p['before']!), context);
      precacheImage(NetworkImage(p['after']!), context);
    }
  }

  void _goTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void _next() => _goTo((currentIndex + 1) % pairs.length);
  void _prev() => _goTo((currentIndex - 1 + pairs.length) % pairs.length);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        final double height = 300.h;
        final double imageWidth = containerWidth;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: containerWidth,
              height: height,
              child: Stack(
                children: [
                  // PageView - disable swipe gestures
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: PageView.builder(
                      controller: _pageController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Tắt swipe
                      itemCount: pairs.length,
                      onPageChanged: (i) => setState(() => currentIndex = i),
                      itemBuilder: (context, index) {
                        final before = pairs[index]['before']!;
                        final after = pairs[index]['after']!;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomBeforeAfterSlider(
                            beforeImage: before,
                            afterImage: after,
                            width: imageWidth,
                            height: height,
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
                          fontSize: 14.h,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    right: 10,
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
                        'After',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                          fontSize: 14.h,
                        ),
                      ),
                    ),
                  ),

                  // Left arrow - inside image area
                  Positioned(
                    left: 0.h,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _prev,
                        child: Container(
                          width: 44.h,
                          height: 44.h,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(
                            Icons.chevron_left,
                            size: 36.h,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Right arrow - inside image area
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: 44.h,
                          height: 44.h,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: Icon(
                            Icons.chevron_right,
                            size: 36.h,
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class CustomBeforeAfterSlider extends StatefulWidget {
  final String beforeImage;
  final String afterImage;
  final double width;
  final double height;

  const CustomBeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.width,
    required this.height,
  });

  @override
  State<CustomBeforeAfterSlider> createState() =>
      _CustomBeforeAfterSliderState();
}

class _CustomBeforeAfterSliderState extends State<CustomBeforeAfterSlider> {
  double _sliderPosition = 0.5; // Vị trí slider từ 0.0 đến 1.0

  void _updateSliderPosition(double localX) {
    setState(() {
      _sliderPosition = (localX / widget.width).clamp(0.0, 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            // Background image (After)
            Positioned(
              left: 0,
              top: 0,
              width: widget.width,
              height: widget.height,
              child: Image.network(
                widget.afterImage,
                width: widget.width,
                height: widget.height,
                fit: BoxFit.cover,
              ),
            ),

            // Foreground image (Before) - clipped
            Positioned(
              left: 0,
              top: 0,
              width: widget.width * _sliderPosition,
              height: widget.height,
              child: ClipRect(
                child: Image.network(
                  widget.beforeImage,
                  width: widget.width,
                  height: widget.height,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
            ),

            // Divider line
            Positioned(
              left: (widget.width * _sliderPosition) - 1.25,
              top: 0,
              child: Container(
                width: 2.5,
                height: widget.height,
                color: Colors.white70,
              ),
            ),

            // Handle
            Positioned(
              left: (widget.width * _sliderPosition) - 22.h,
              top: (widget.height / 2) - 18.h,
              child: Container(
                width: 40.h,
                height: 40.h,
                padding: EdgeInsets.only(left: 4),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(AppImages.ArrowIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
