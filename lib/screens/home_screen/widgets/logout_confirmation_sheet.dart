import 'package:flutter/material.dart';

class LogoutConfirmationSheet extends StatelessWidget {
  const LogoutConfirmationSheet({required this.onConfirm, super.key});

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '\u0414\u0435\u0439\u0441\u0442\u0432\u0438\u0442'
              '\u0435\u043B\u044C\u043D\u043E '
              '\u0432\u044B\u0439\u0442\u0438?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('\u041D\u0435\u0442'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('\u0414\u0430'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
