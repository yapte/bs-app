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
  var _isCodeStep = false;
  var _isSendingPhone = false;
  var _isVerifyingCode = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _sendPhone() async {
    if (_isSendingPhone) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isSendingPhone = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    setState(() {
      _isSendingPhone = false;
      _isCodeStep = true;
    });
  }

  Future<void> _verifyCode() async {
    if (_isVerifyingCode || _codeController.text.length != 6) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isVerifyingCode = true);
    await Future<void>.delayed(const Duration(milliseconds: 900));

    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacementNamed('/home');
  }

  void _onCodeChanged(String value) {
    if (value.length == 6) {
      _verifyCode();
    }
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
              _isCodeStep
                  ? '\u0412\u0432\u0435\u0434\u0438\u0442\u0435 '
                        '\u043A\u043E\u0434 \u0438\u0437 SMS'
                  : '\u0423\u043A\u0430\u0436\u0438\u0442\u0435 '
                        '\u0442\u0435\u043B\u0435\u0444\u043E\u043D',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              inputFormatters: [_RussianPhoneInputFormatter()],
              enabled: !_isSendingPhone && !_isVerifyingCode && !_isCodeStep,
              decoration: const InputDecoration(
                labelText: '\u0422\u0435\u043B\u0435\u0444\u043E\u043D',
                hintText: '+7 (999) 123-45-67',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            if (_isCodeStep) ...[
              const SizedBox(height: 18),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                enabled: !_isVerifyingCode,
                onChanged: _onCodeChanged,
                decoration: const InputDecoration(
                  labelText: 'SMS-\u043A\u043E\u0434',
                  hintText: '000000',
                  prefixIcon: Icon(Icons.lock_outline),
                  counterText: '',
                ),
                maxLength: 6,
              ),
            ],
            const SizedBox(height: 28),
            if (!_isCodeStep)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSendingPhone ? null : _sendPhone,
                  child: _ButtonContent(
                    isLoading: _isSendingPhone,
                    label:
                        '\u041F\u041E\u041B\u0423\u0427\u0418\u0422\u042C '
                        '\u041A\u041E\u0414',
                  ),
                ),
              )
            else
              Center(
                child: _isVerifyingCode
                    ? const _InlineProgress(
                        label:
                            '\u041F\u0440\u043E\u0432\u0435\u0440\u044F'
                            '\u0435\u043C \u043A\u043E\u0434',
                      )
                    : Text(
                        '\u041A\u043E\u0434 '
                        '\u043E\u0442\u043F\u0440\u0430\u0432\u043B'
                        '\u0435\u043D. \u0412\u0432\u0435\u0434\u0438'
                        '\u0442\u0435 6 \u0446\u0438\u0444\u0440.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.isLoading, required this.label});

  final bool isLoading;
  final String label;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return Text(label);
    }

    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
    );
  }
}

class _InlineProgress extends StatelessWidget {
  const _InlineProgress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2.2),
        ),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
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
