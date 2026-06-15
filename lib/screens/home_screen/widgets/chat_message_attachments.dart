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

class _MessageAttachmentTile extends StatelessWidget {
  const _MessageAttachmentTile({required this.attachment, required this.onTap});

  final SpaChatAttachment attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                    color: (isImage ? SpaThemeColors.blue : SpaThemeColors.gold)
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isImage ? Icons.image_outlined : Icons.spa_outlined,
                    color: isImage ? SpaThemeColors.blue : SpaThemeColors.gold,
                    size: 20,
                  ),
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
