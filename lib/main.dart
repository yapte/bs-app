import 'package:flutter/material.dart';

import 'theme.dart';

void main() {
  runApp(const BigSaltsApp());
}

class BigSaltsApp extends StatelessWidget {
  const BigSaltsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          '\u0421\u041F\u0410 \u0411\u043E\u043B\u044C\u0448\u0438\u0435 '
          '\u0441\u043E\u043B\u0438',
      debugShowCheckedModeBanner: false,
      theme: SpaTheme.light,
      home: const SpaHomePage(),
    );
  }
}

class SpaHomePage extends StatelessWidget {
  const SpaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const _BrandMark(),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: '\u041A\u043E\u043D\u0442\u0430\u043A\u0442\u044B',
            icon: const Icon(Icons.phone_outlined, color: SpaThemeColors.gold),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: const [
            _HeroPanel(),
            SizedBox(height: 20),
            _NavigationChips(),
            SizedBox(height: 34),
            _SectionTitle(
              '\u041F\u043E\u0441\u043B\u0435\u0434\u043D\u0438\u0435 '
              '\u043D\u043E\u0432\u043E\u0441\u0442\u0438',
            ),
            SizedBox(height: 18),
            _NewsGrid(),
            SizedBox(height: 20),
            Center(child: _AllNewsButton()),
            SizedBox(height: 34),
            _SectionTitle(
              '\u041F\u043E\u043F\u0443\u043B\u044F\u0440\u043D\u044B\u0435 '
              '\u0443\u0441\u043B\u0443\u0433\u0438',
            ),
            SizedBox(height: 18),
            _PopularServices(),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 44,
          decoration: const BoxDecoration(
            color: SpaThemeColors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
            ),
          ),
          child: const Icon(Icons.water_drop, color: Colors.white, size: 23),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\u0421\u041F\u0410',
              style: TextStyle(
                fontSize: 22,
                color: SpaThemeColors.ink,
                fontWeight: FontWeight.w400,
                height: 0.95,
              ),
            ),
            Text(
              '\u0411\u041E\u041B\u042C\u0428\u0418\u0415 '
              '\u0421\u041E\u041B\u0418',
              style: TextStyle(
                fontSize: 8,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NavigationChips extends StatelessWidget {
  const _NavigationChips();

  @override
  Widget build(BuildContext context) {
    const labels = [
      '\u0423\u0441\u043B\u0443\u0433\u0438',
      '\u041E \u0421\u041F\u0410',
      '\u041F\u0438\u0442\u0430\u043D\u0438\u0435',
      '\u041F\u0440\u043E\u0436\u0438\u0432\u0430\u043D\u0438\u0435',
      '\u0411\u0430\u0441\u0441\u0435\u0439\u043D',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final label in labels) ...[
            ActionChip(
              label: Text(label),
              onPressed: () {},
              avatar: const Icon(Icons.keyboard_arrow_down, size: 17),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 390),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFC9B391), Color(0xFF8F7A5D), Color(0xFF5A4D42)],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withValues(alpha: 0.20),
              ),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.spa_outlined, color: Colors.white, size: 54),
                  const SizedBox(height: 18),
                  Text(
                    '\u0414\u043E\u0431\u0440\u043E '
                    '\u043F\u043E\u0436\u0430\u043B\u043E\u0432\u0430'
                    '\u0442\u044C',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '\u043F\u043E\u0447\u0443\u0432\u0441\u0442\u0432'
                    '\u0443\u0439\u0442\u0435 \u043A\u043E\u043C\u0444'
                    '\u043E\u0440\u0442 \u0438 \u0443\u044E\u0442\n'
                    '\u0421\u041F\u0410 \u00AB\u0411\u043E\u043B\u044C'
                    '\u0448\u0438\u0435 \u0441\u043E\u043B\u0438\u00BB',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      height: 1.18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 28),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      '\u041D\u0410\u0428\u0418 '
                      '\u041A\u041E\u041D\u0422\u0410\u041A\u0422\u042B',
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    '\u0414\u0430\u0440\u0443\u0435\u043C '
                    '\u043A\u0440\u0430\u0441\u043E\u0442\u0443, '
                    '\u043F\u043E\u0434\u0434\u0435\u0440\u0436\u0438'
                    '\u0432\u0430\u0435\u043C \u043C\u043E\u043B\u043E'
                    '\u0434\u043E\u0441\u0442\u044C \u0438 '
                    '\u0441\u043E\u0445\u0440\u0430\u043D\u044F\u0435'
                    '\u043C \u0441\u0430\u043C\u043E\u0435 '
                    '\u0433\u043B\u0430\u0432\u043D\u043E\u0435 - '
                    '\u0437\u0434\u043E\u0440\u043E\u0432\u044C\u0435 '
                    '\u0412\u0430\u0448\u0435\u0439 \u0434\u0443\u0448'
                    '\u0438 \u0438 \u0442\u0435\u043B\u0430.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}

class _NewsGrid extends StatelessWidget {
  const _NewsGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        Icons.hot_tub_outlined,
        '\u0412\u0430\u043A\u0443\u0443\u043C\u043D\u044B\u0439 '
            '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
            '\u0430\u0436',
        '\u0410\u043F\u043F\u0430\u0440\u0430\u0442\u043D\u0430\u044F '
            '\u043F\u0440\u043E\u0446\u0435\u0434\u0443\u0440\u0430, '
            '\u0432\u043E\u0434\u0430 \u0438 \u0432\u0430\u043A\u0443'
            '\u0443\u043C.',
      ),
      (
        Icons.face_retouching_natural,
        '\u0418\u043B\u043B\u044E\u043C\u0438\u043D\u0438\u0440\u0443'
            '\u044E\u0449\u0438\u0439 \u0443\u0445\u043E\u0434',
        '\u041F\u0440\u043E\u0433\u0440\u0430\u043C\u043C\u0430 '
            '\u0443\u0445\u043E\u0434\u0430 \u0437\u0430 \u043B\u0438'
            '\u0446\u043E\u043C \u043D\u0430 \u043B\u0438\u043D\u0438'
            '\u0438 VAGHEGGI.',
      ),
      (
        Icons.self_improvement,
        '\u0421\u0410\u0420\u0413\u0410-\u0422\u0415\u0420\u0410'
            '\u041F\u0418\u042F',
        '\u0414\u043B\u044F \u0442\u0435\u0445, \u043A\u043E\u043C'
            '\u0443 \u043D\u0443\u0436\u043D\u043E \u0432\u044B\u043A'
            '\u043B\u044E\u0447\u0438\u0442\u044C \u0432\u043D\u0443'
            '\u0442\u0440\u0435\u043D\u043D\u0438\u0439 \u043A\u0440'
            '\u0438\u0442\u0438\u043A.',
      ),
      (
        Icons.bathtub_outlined,
        '\u0413\u0438\u0434\u0440\u043E\u0442\u0435\u0440\u0430\u043F'
            '\u0438\u044F',
        '\u0412\u0430\u043D\u043D\u044B \u043D\u0430 \u043E\u0441'
            '\u043D\u043E\u0432\u0435 \u044D\u0444\u0438\u0440\u043D'
            '\u044B\u0445 \u043C\u0430\u0441\u0435\u043B ETHERAPY.',
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 720;

        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isWide ? 4 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isWide ? 0.50 : 0.62,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return _NewsCard(
              icon: item.$1,
              title: item.$2,
              description: item.$3,
            );
          },
        );
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              color: const Color(0xFFF1EEE7),
              child: Icon(icon, color: SpaThemeColors.blue, size: 46),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: SpaThemeColors.gold,
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      height: 1.2,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllNewsButton extends StatelessWidget {
  const _AllNewsButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: OutlinedButton(
        onPressed: () {},
        child: const Text(
          '\u0421\u041C\u041E\u0422\u0420\u0415\u0422\u042C '
          '\u0412\u0421\u0415 \u041D\u041E\u0412\u041E\u0421\u0422'
          '\u0418',
        ),
      ),
    );
  }
}

class _PopularServices extends StatelessWidget {
  const _PopularServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _ServiceTile(
          icon: Icons.local_florist_outlined,
          title: '\u0410\u044E\u0440\u0432\u0435\u0434\u0430',
          description:
              '\u0418\u043D\u0434\u0438\u0439\u0441\u043A\u0430\u044F '
              '\u0444\u0438\u043B\u043E\u0441\u043E\u0444\u0438\u044F '
              '\u0432\u043E\u0441\u0441\u0442\u0430\u043D\u043E\u0432'
              '\u043B\u0435\u043D\u0438\u044F \u0442\u0435\u043B\u0430 '
              '\u0438 \u0434\u0443\u0448\u0438.',
        ),
        SizedBox(height: 12),
        _ServiceTile(
          icon: Icons.water,
          title:
              '\u0411\u0430\u043D\u043D\u044B\u0439 \u043A\u043E\u043C'
              '\u043F\u043B\u0435\u043A\u0441',
          description:
              '\u0420\u0443\u0441\u0441\u043A\u0430\u044F \u0438 '
              '\u0422\u0443\u0440\u0435\u0446\u043A\u0430\u044F '
              '\u0431\u0430\u043D\u0438 \u0434\u043B\u044F '
              '\u0433\u043B\u0443\u0431\u043E\u043A\u043E\u0433\u043E '
              '\u0440\u0430\u0441\u0441\u043B\u0430\u0431\u043B\u0435'
              '\u043D\u0438\u044F.',
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 128),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF877B67), Color(0xFF4B433A)],
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white.withValues(alpha: 0.18),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
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
