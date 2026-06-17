import 'package:flutter/material.dart';

import '../../../data/chat/spa_chat_models.dart';
import '../../../theme.dart';

class MessageAttachmentsList extends StatelessWidget {
  const MessageAttachmentsList({
    required this.attachments,
    required this.isSentByMe,
    required this.onAttachmentTap,
    super.key,
  });

  final List<SpaChatAttachment> attachments;
  final bool isSentByMe;
  final ValueChanged<SpaChatAttachment> onAttachmentTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        crossAxisAlignment: isSentByMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          for (final attachment in attachments)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _MessageAttachmentTile(
                attachment: attachment,
                onTap: () => onAttachmentTap(attachment),
              ),
            ),
        ],
      ),
    );
  }
}

class DraftChatAttachments extends StatelessWidget {
  const DraftChatAttachments({
    required this.attachments,
    required this.onRemove,
    super.key,
  });

  final List<SpaChatAttachment> attachments;
  final ValueChanged<SpaChatAttachment> onRemove;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SpaThemeColors.paper,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Вложения',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: SpaThemeColors.inkMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 58,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final attachment = attachments[index];
                  return _DraftAttachmentTile(
                    attachment: attachment,
                    onRemove: () => onRemove(attachment),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemCount: attachments.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageAttachmentTile extends StatelessWidget {
  const _MessageAttachmentTile({required this.attachment, required this.onTap});

  final SpaChatAttachment attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = _AttachmentPalette.fromType(attachment.type);
    final isImage = attachment.type == SpaChatAttachmentType.image;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: isImage ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: palette.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(palette.icon, color: palette.color, size: 20),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attachment.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: SpaThemeColors.ink,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (attachment.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          attachment.subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!isImage) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: SpaThemeColors.blue,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DraftAttachmentTile extends StatelessWidget {
  const _DraftAttachmentTile({
    required this.attachment,
    required this.onRemove,
  });

  final SpaChatAttachment attachment;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final palette = _AttachmentPalette.fromType(attachment.type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: SizedBox(
        width: 220,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: palette.color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(palette.icon, color: palette.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  attachment.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: SpaThemeColors.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                message: 'Удалить вложение',
                child: IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.close_rounded),
                  color: SpaThemeColors.inkMuted,
                  iconSize: 18,
                  visualDensity: VisualDensity.compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachmentPalette {
  const _AttachmentPalette({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  static _AttachmentPalette fromType(SpaChatAttachmentType type) {
    return switch (type) {
      SpaChatAttachmentType.image => const _AttachmentPalette(
        icon: Icons.image_outlined,
        color: SpaThemeColors.blue,
      ),
      SpaChatAttachmentType.procedure => const _AttachmentPalette(
        icon: Icons.spa_outlined,
        color: SpaThemeColors.gold,
      ),
      SpaChatAttachmentType.favoriteGroup => const _AttachmentPalette(
        icon: Icons.folder_special_outlined,
        color: SpaThemeColors.gold,
      ),
    };
  }
}
