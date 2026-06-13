import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              SvgPicture.asset(
                'assets/logo_vectorized.svg',
                width: 180,
                semanticsLabel: 'Big Salts SPA logo',
              ),
              const SizedBox(height: 36),
              Text(
                '\u0414\u043E\u0431\u0440\u043E '
                '\u043F\u043E\u0436\u0430\u043B\u043E\u0432\u0430'
                '\u0442\u044C',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                '\u041B\u0438\u0447\u043D\u044B\u0439 '
                '\u043A\u0430\u0431\u0438\u043D\u0435\u0442 '
                '\u0433\u043E\u0441\u0442\u044F \u0421\u041F\u0410 '
                '\u00AB\u0411\u043E\u043B\u044C\u0448\u0438\u0435 '
                '\u0441\u043E\u043B\u0438\u00BB',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text('\u0412\u041E\u0419\u0422\u0418'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
