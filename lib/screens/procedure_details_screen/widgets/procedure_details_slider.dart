import 'package:flutter/material.dart';

import '../../../theme.dart';

class ProcedureDetailsSlider extends StatefulWidget {
  const ProcedureDetailsSlider({super.key});

  @override
  State<ProcedureDetailsSlider> createState() => _ProcedureDetailsSliderState();
}

class _ProcedureDetailsSliderState extends State<ProcedureDetailsSlider> {
  final _pageController = PageController();
  var _selectedImage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) => setState(() {
              _selectedImage = index;
            }),
            itemBuilder: (context, index) {
              final slide = _slides[index];

              return _ProcedureImageSlide(
                title: slide.title,
                subtitle: slide.subtitle,
                icon: slide.icon,
                colors: slide.colors,
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 14,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < _slides.length; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: _selectedImage == index ? 24 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: _selectedImage == index ? 0.95 : 0.45,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcedureImageSlide extends StatelessWidget {
  const _ProcedureImageSlide({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -30,
            child: Icon(icon, size: 180, color: Colors.white24),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 38),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsSlideData {
  const _DetailsSlideData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> colors;
}

const _slides = [
  _DetailsSlideData(
    title: 'Тихий ритуал восстановления',
    subtitle: 'Мягкое погружение в атмосферу СПА «Большие соли».',
    icon: Icons.spa,
    colors: [SpaThemeColors.blue, Color(0xFF7CC7C1)],
  ),
  _DetailsSlideData(
    title: 'Тепло, вода и забота',
    subtitle: 'Продуманный сценарий процедуры и комфортный темп.',
    icon: Icons.water_drop,
    colors: [Color(0xFFC2B45B), Color(0xFFE6D68B)],
  ),
  _DetailsSlideData(
    title: 'Эффект после визита',
    subtitle: 'Легкость, расслабление и рекомендации специалиста.',
    icon: Icons.favorite,
    colors: [Color(0xFF6AAE9F), Color(0xFF9E7CC4)],
  ),
];
