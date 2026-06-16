import 'package:flutter/material.dart';

import '../../../data/favorites/mock_favorites_service.dart';

class CreateFavoriteGroupDialog extends StatefulWidget {
  const CreateFavoriteGroupDialog({super.key});

  @override
  State<CreateFavoriteGroupDialog> createState() =>
      _CreateFavoriteGroupDialogState();
}

class _CreateFavoriteGroupDialogState extends State<CreateFavoriteGroupDialog> {
  final _controller = TextEditingController();

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_canSubmit) {
      return;
    }

    MockFavoritesService.instance.createGroup(_controller.text);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая группа'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Название группы',
          hintText: 'Например, На выходные',
        ),
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          onPressed: _canSubmit ? _submit : null,
          child: const Text('Создать'),
        ),
      ],
    );
  }
}
