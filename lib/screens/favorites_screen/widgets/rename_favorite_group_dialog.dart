import 'package:flutter/material.dart';

import '../../../common/models/favorite_group_models.dart';
import '../../../data/favorites/mock_favorites_service.dart';

class RenameFavoriteGroupDialog extends StatefulWidget {
  const RenameFavoriteGroupDialog({required this.group, super.key});

  final FavoriteGroup group;

  @override
  State<RenameFavoriteGroupDialog> createState() =>
      _RenameFavoriteGroupDialogState();
}

class _RenameFavoriteGroupDialogState extends State<RenameFavoriteGroupDialog> {
  late final TextEditingController _controller;

  bool get _canSubmit => _controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.group.title);
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

    MockFavoritesService.instance.renameGroup(
      groupId: widget.group.id,
      title: _controller.text,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Переименовать группу'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Название группы'),
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
          child: const Text('Сохранить'),
        ),
      ],
    );
  }
}
