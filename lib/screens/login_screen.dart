import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          children: [
            Text(
              '\u0412\u0445\u043E\u0434',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Text(
              '\u0423\u043A\u0430\u0436\u0438\u0442\u0435 '
              '\u0442\u0435\u043B\u0435\u0444\u043E\u043D '
              '\u0438 \u043A\u043E\u0434 \u0438\u0437 SMS',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [_RussianPhoneInputFormatter()],
              decoration: const InputDecoration(
                labelText: '\u0422\u0435\u043B\u0435\u0444\u043E\u043D',
                hintText: '+7 (999) 123-45-67',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _codeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
              decoration: const InputDecoration(
                labelText: 'SMS-\u043A\u043E\u0434',
                hintText: '000000',
                prefixIcon: Icon(Icons.lock_outline),
                counterText: '',
              ),
              maxLength: 6,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text('\u0412\u041E\u0419\u0422\u0418'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RussianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.startsWith('8')) {
      digits = '7${digits.substring(1)}';
    }
    if (!digits.startsWith('7')) {
      digits = '7$digits';
    }
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    final buffer = StringBuffer('+7');
    final localDigits = digits.length > 1 ? digits.substring(1) : '';

    if (localDigits.isNotEmpty) {
      buffer.write(' (');
      buffer.write(localDigits.substring(0, _end(localDigits, 3)));
      if (localDigits.length >= 3) {
        buffer.write(')');
      }
    }
    if (localDigits.length > 3) {
      buffer.write(' ');
      buffer.write(localDigits.substring(3, _end(localDigits, 6)));
    }
    if (localDigits.length > 6) {
      buffer.write('-');
      buffer.write(localDigits.substring(6, _end(localDigits, 8)));
    }
    if (localDigits.length > 8) {
      buffer.write('-');
      buffer.write(localDigits.substring(8, _end(localDigits, 10)));
    }

    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  int _end(String value, int max) {
    return value.length < max ? value.length : max;
  }
}
