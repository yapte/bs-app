import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = PageController();
  var _selectedIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _controller,
          onPageChanged: (index) => setState(() => _selectedIndex = index),
          children: const [ProfilePage(), ClientSchedulePage(), CatalogPage()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectPage,
        destinations: [
          _svgDestination(
            'assets/profile_icon.svg',
            '\u041F\u0440\u043E\u0444\u0438\u043B\u044C',
          ),
          _svgDestination(
            'assets/schedule_icon.svg',
            '\u0420\u0430\u0441\u043F\u0438\u0441\u0430\u043D'
                '\u0438\u0435',
          ),
          _svgDestination(
            'assets/catalog_icon.svg',
            '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
          ),
        ],
      ),
    );
  }
}

NavigationDestination _svgDestination(String assetName, String label) {
  return NavigationDestination(
    icon: _NavIcon(assetName: assetName),
    selectedIcon: _NavIcon(assetName: assetName, selected: true),
    label: label,
  );
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.assetName, this.selected = false});

  final String assetName;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: 26,
      height: 26,
      colorFilter: selected
          ? const ColorFilter.mode(SpaThemeColors.gold, BlendMode.srcIn)
          : null,
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          '\u041F\u0440\u043E\u0444\u0438\u043B\u044C',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 34,
                  backgroundColor: SpaThemeColors.blue,
                  child: Text(
                    'AM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\u0410\u043D\u043D\u0430 '
                        '\u041C\u0438\u0445\u0430\u0439\u043B\u043E'
                        '\u0432\u0430',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '+7 (906) 639-52-42',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const _ProfileMetric(
          title: '\u0411\u0430\u043B\u0430\u043D\u0441',
          value: '12 400 \u20BD',
        ),
        const _ProfileMetric(
          title: '\u0411\u043E\u043D\u0443\u0441\u044B',
          value: '860',
        ),
        const _ProfileMetric(
          title:
              '\u041B\u044E\u0431\u0438\u043C\u0430\u044F '
              '\u0443\u0441\u043B\u0443\u0433\u0430',
          value:
              '\u0413\u0438\u0434\u0440\u043E\u0442\u0435\u0440\u0430'
              '\u043F\u0438\u044F',
        ),
      ],
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  const _ProfileMetric({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        child: ListTile(
          title: Text(title),
          trailing: Text(value, style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}

class ClientSchedulePage extends StatelessWidget {
  const ClientSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    const procedures = [
      _Procedure(
        title:
            '\u0412\u0430\u043A\u0443\u0443\u043C\u043D\u044B\u0439 '
            '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
            '\u0430\u0436',
        specialist: '\u0415\u043B\u0435\u043D\u0430',
        date: '14 \u0438\u044E\u043D\u044F',
        time: '11:30',
        room: '\u043A\u0430\u0431. 204',
      ),
      _Procedure(
        title:
            '\u0421\u0410\u0420\u0413\u0410-\u0442\u0435\u0440'
            '\u0430\u043F\u0438\u044F',
        specialist: '\u041C\u0430\u0440\u0438\u044F',
        date: '15 \u0438\u044E\u043D\u044F',
        time: '10:00',
        room: '\u0437\u0430\u043B 2',
      ),
      _Procedure(
        title:
            '\u0413\u0438\u0434\u0440\u043E\u0442\u0435\u0440\u0430'
            '\u043F\u0438\u044F',
        specialist: '\u041E\u043B\u044C\u0433\u0430',
        date: '16 \u0438\u044E\u043D\u044F',
        time: '17:15',
        room: '\u043A\u0430\u0431. 118',
      ),
      _Procedure(
        title:
            '\u0418\u043B\u043B\u044E\u043C\u0438\u043D\u0438\u0440'
            '\u0443\u044E\u0449\u0438\u0439 \u0443\u0445\u043E\u0434',
        specialist:
            '\u0410\u043D\u0430\u0441\u0442\u0430\u0441\u0438'
            '\u044F',
        date: '18 \u0438\u044E\u043D\u044F',
        time: '13:45',
        room: '\u043A\u0430\u0431. 312',
      ),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: procedures.length + 1,
      separatorBuilder: (_, index) => SizedBox(height: index == 0 ? 18 : 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            '\u041C\u043E\u0435 \u0440\u0430\u0441\u043F\u0438\u0441'
            '\u0430\u043D\u0438\u0435',
            style: Theme.of(context).textTheme.headlineLarge,
          );
        }

        final procedure = procedures[index - 1];
        return _ProcedureTile(procedure: procedure);
      },
    );
  }
}

class _Procedure {
  const _Procedure({
    required this.title,
    required this.specialist,
    required this.date,
    required this.time,
    required this.room,
  });

  final String title;
  final String specialist;
  final String date;
  final String time;
  final String room;
}

class _ProcedureTile extends StatelessWidget {
  const _ProcedureTile({required this.procedure});

  final _Procedure procedure;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: SpaThemeColors.gold,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
                  Text(
                    procedure.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    procedure.date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      height: 1.1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procedure.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${procedure.specialist} - ${procedure.room}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '\u041A\u0430\u0442\u0430\u043B\u043E\u0433',
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );
  }
}
