import 'package:flutter/material.dart';

import '../../../theme.dart';

class ClientSchedulePage extends StatelessWidget {
  const ClientSchedulePage({super.key});

  static const _schedule = [
    _ScheduleDay(
      date:
          '14 \u0438\u044E\u043D\u044F, '
          '\u043F\u044F\u0442\u043D\u0438\u0446\u0430',
      procedures: [
        _Procedure(
          title:
              '\u0412\u0430\u043A\u0443\u0443\u043C\u043D\u044B\u0439 '
              '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
              '\u0430\u0436',
          specialist: '\u0415\u043B\u0435\u043D\u0430',
          time: '11:30',
          room: '\u043A\u0430\u0431. 204',
          duration: '45 \u043C\u0438\u043D',
          category: '\u0422\u0435\u043B\u043E',
          description:
              '\u0410\u043F\u043F\u0430\u0440\u0430\u0442\u043D\u0430'
              '\u044F \u043F\u0440\u043E\u0446\u0435\u0434\u0443'
              '\u0440\u0430, \u043A\u043E\u0442\u043E\u0440\u0430'
              '\u044F \u0441\u043E\u0447\u0435\u0442\u0430\u0435\u0442'
              ' \u043C\u044F\u0433\u043A\u0438\u0439 '
              '\u0433\u0438\u0434\u0440\u043E\u043C\u0430\u0441\u0441'
              '\u0430\u0436 \u0438 \u0432\u0430\u043A\u0443\u0443'
              '\u043C\u043D\u043E\u0435 \u0432\u043E\u0437\u0434'
              '\u0435\u0439\u0441\u0442\u0432\u0438\u0435.',
          colors: [Color(0xFF72C5EF), Color(0xFF2F67B2)],
          icon: Icons.hot_tub_outlined,
        ),
        _Procedure(
          title:
              '\u0410\u0440\u043E\u043C\u0430\u0442\u0438\u0447'
              '\u0435\u0441\u043A\u0430\u044F \u0432\u0430\u043D'
              '\u043D\u0430',
          specialist: '\u041E\u043B\u044C\u0433\u0430',
          time: '16:00',
          room: '\u043A\u0430\u0431. 118',
          duration: '30 \u043C\u0438\u043D',
          category: '\u0420\u0435\u043B\u0430\u043A\u0441',
          description:
              '\u0422\u0435\u043F\u043B\u0430\u044F '
              '\u0432\u0430\u043D\u043D\u0430 \u0441 '
              '\u044D\u0444\u0438\u0440\u043D\u044B\u043C\u0438 '
              '\u043C\u0430\u0441\u043B\u0430\u043C\u0438 '
              '\u0438 \u043C\u0438\u043D\u0435\u0440\u0430'
              '\u043B\u044C\u043D\u044B\u043C\u0438 '
              '\u0441\u043E\u043B\u044F\u043C\u0438.',
          colors: [Color(0xFFC2B45B), Color(0xFF4AA3DF)],
          icon: Icons.bathtub_outlined,
        ),
      ],
    ),
    _ScheduleDay(
      date:
          '15 \u0438\u044E\u043D\u044F, '
          '\u0441\u0443\u0431\u0431\u043E\u0442\u0430',
      procedures: [
        _Procedure(
          title:
              '\u0421\u0410\u0420\u0413\u0410-\u0442\u0435\u0440'
              '\u0430\u043F\u0438\u044F',
          specialist: '\u041C\u0430\u0440\u0438\u044F',
          time: '10:00',
          room: '\u0437\u0430\u043B 2',
          duration: '60 \u043C\u0438\u043D',
          category: '\u0411\u0430\u043B\u0430\u043D\u0441',
          description:
              '\u041C\u044F\u0433\u043A\u0430\u044F '
              '\u0442\u0435\u0445\u043D\u0438\u043A\u0430 '
              '\u0434\u043B\u044F \u0433\u043B\u0443\u0431'
              '\u043E\u043A\u043E\u0433\u043E '
              '\u0440\u0430\u0441\u0441\u043B\u0430\u0431'
              '\u043B\u0435\u043D\u0438\u044F \u0438 '
              '\u0441\u043D\u044F\u0442\u0438\u044F '
              '\u043C\u044B\u0448\u0435\u0447\u043D\u043E\u0433'
              '\u043E \u043D\u0430\u043F\u0440\u044F\u0436'
              '\u0435\u043D\u0438\u044F.',
          colors: [Color(0xFF4AA3DF), Color(0xFF8A6FCE)],
          icon: Icons.self_improvement,
        ),
      ],
    ),
    _ScheduleDay(
      date:
          '18 \u0438\u044E\u043D\u044F, '
          '\u0432\u0442\u043E\u0440\u043D\u0438\u043A',
      procedures: [
        _Procedure(
          title:
              '\u0418\u043B\u043B\u044E\u043C\u0438\u043D\u0438\u0440'
              '\u0443\u044E\u0449\u0438\u0439 \u0443\u0445\u043E\u0434',
          specialist:
              '\u0410\u043D\u0430\u0441\u0442\u0430\u0441\u0438'
              '\u044F',
          time: '13:45',
          room: '\u043A\u0430\u0431. 312',
          duration: '50 \u043C\u0438\u043D',
          category: '\u041B\u0438\u0446\u043E',
          description:
              '\u0423\u0445\u043E\u0434 \u0434\u043B\u044F '
              '\u0441\u0438\u044F\u043D\u0438\u044F '
              '\u043A\u043E\u0436\u0438: '
              '\u043E\u0447\u0438\u0449\u0435\u043D\u0438\u0435, '
              '\u043C\u0430\u0441\u043A\u0430 \u0438 '
              '\u0444\u0438\u043D\u0430\u043B\u044C\u043D\u044B'
              '\u0439 \u043A\u0440\u0435\u043C.',
          colors: [Color(0xFFE8B5C8), Color(0xFF4AA3DF)],
          icon: Icons.face_retouching_natural,
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                '\u041C\u043E\u0435 \u0440\u0430\u0441\u043F\u0438\u0441'
                '\u0430\u043D\u0438\u0435',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            IconButton(
              onPressed: () => _showHistoryDialog(context),
              tooltip: '\u0418\u0441\u0442\u043E\u0440\u0438\u044F',
              icon: const Icon(Icons.history, color: SpaThemeColors.blue),
            ),
          ],
        ),
        const SizedBox(height: 18),
        for (final day in _schedule) ...[
          _DayHeader(date: day.date),
          const SizedBox(height: 10),
          for (final procedure in day.procedures) ...[
            _ProcedureTile(
              procedure: procedure,
              onTap: () => _showProcedureDetails(context, procedure),
            ),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Future<void> _showHistoryDialog(BuildContext context) async {
    final today = DateUtils.dateOnly(DateTime.now());
    await showDialog<void>(
      context: context,
      builder: (context) {
        return _HistoryRangeDialog(
          initialFrom: today.subtract(const Duration(days: 7)),
          initialTo: today,
        );
      },
    );
  }

  Future<void> _showProcedureDetails(
    BuildContext context,
    _Procedure procedure,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _ProcedureDetailsSheet(procedure: procedure);
      },
    );
  }
}

class _HistoryRangeDialog extends StatefulWidget {
  const _HistoryRangeDialog({
    required this.initialFrom,
    required this.initialTo,
  });

  final DateTime initialFrom;
  final DateTime initialTo;

  @override
  State<_HistoryRangeDialog> createState() => _HistoryRangeDialogState();
}

class _HistoryRangeDialogState extends State<_HistoryRangeDialog> {
  DateTime? _from;
  late DateTime _to;

  @override
  void initState() {
    super.initState();
    _from = widget.initialFrom;
    _to = widget.initialTo;
  }

  bool get _isValid => _from != null && !_from!.isAfter(_to);

  String? get _fromError {
    final from = _from;
    if (from == null) {
      return '\u0414\u0430\u0442\u0430 \u00AB\u0421\u00BB '
          '\u043E\u0431\u044F\u0437\u0430\u0442\u0435\u043B\u044C'
          '\u043D\u0430';
    }
    if (from.isAfter(_to)) {
      return '\u0414\u0430\u0442\u0430 \u00AB\u0421\u00BB '
          '\u043D\u0435 \u0434\u043E\u043B\u0436\u043D\u0430 '
          '\u0431\u044B\u0442\u044C \u043F\u043E\u0437\u0436\u0435 '
          '\u0434\u0430\u0442\u044B \u00AB\u041F\u041E\u00BB';
    }
    return null;
  }

  Future<void> _pickFrom() async {
    final selected = await _pickDate(_from ?? _to);
    if (selected == null) {
      return;
    }
    setState(() => _from = selected);
  }

  Future<void> _pickTo() async {
    final selected = await _pickDate(_to);
    if (selected == null) {
      return;
    }
    setState(() => _to = selected);
  }

  Future<DateTime?> _pickDate(DateTime initialDate) {
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        '\u0418\u0441\u0442\u043E\u0440\u0438\u044F '
        '\u0440\u0430\u0441\u043F\u0438\u0441\u0430\u043D\u0438\u044F',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DateField(
            label: '\u0421',
            value: _from == null ? null : _formatDate(_from!),
            errorText: _fromError,
            onTap: _pickFrom,
            onClear: () => setState(() => _from = null),
          ),
          const SizedBox(height: 14),
          _DateField(
            label: '\u041F\u041E',
            value: _formatDate(_to),
            onTap: _pickTo,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('\u041E\u0442\u043C\u0435\u043D\u0430'),
        ),
        ElevatedButton(
          onPressed: _isValid ? () => Navigator.of(context).pop() : null,
          child: const Text(
            '\u041F\u0440\u0438\u043C\u0435\u043D\u0438\u0442\u044C',
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    this.errorText,
    this.onClear,
  });

  final String label;
  final String? value;
  final String? errorText;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final errorText = this.errorText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: errorText == null
                    ? const Color(0xFFD1D5DB)
                    : Theme.of(context).colorScheme.error,
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                const Icon(Icons.event_outlined, color: SpaThemeColors.blue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    value ??
                        '\u0412\u044B\u0431\u0435\u0440\u0438\u0442'
                            '\u0435 \u0434\u0430\u0442\u0443',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                if (onClear != null)
                  IconButton(
                    onPressed: onClear,
                    tooltip: '\u041E\u0447\u0438\u0441\u0442\u0438\u0442\u044C',
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

class _ScheduleDay {
  const _ScheduleDay({required this.date, required this.procedures});

  final String date;
  final List<_Procedure> procedures;
}

class _Procedure {
  const _Procedure({
    required this.title,
    required this.specialist,
    required this.time,
    required this.room,
    required this.duration,
    required this.category,
    required this.description,
    required this.colors,
    required this.icon,
  });

  final String title;
  final String specialist;
  final String time;
  final String room;
  final String duration;
  final String category;
  final String description;
  final List<Color> colors;
  final IconData icon;
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.date});

  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.calendar_today_outlined, color: SpaThemeColors.blue),
        const SizedBox(width: 8),
        Text(date, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _ProcedureTile extends StatelessWidget {
  const _ProcedureTile({required this.procedure, required this.onTap});

  final _Procedure procedure;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
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
                    const SizedBox(height: 6),
                    Icon(procedure.icon, color: Colors.white, size: 21),
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
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _MiniChip(
                          icon: Icons.timer_outlined,
                          label: procedure.duration,
                        ),
                        _MiniChip(
                          icon: Icons.spa_outlined,
                          label: procedure.category,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_up, color: SpaThemeColors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: SpaThemeColors.blue.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: SpaThemeColors.blue),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ProcedureDetailsSheet extends StatelessWidget {
  const _ProcedureDetailsSheet({required this.procedure});

  final _Procedure procedure;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.52,
      minChildSize: 0.48,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1D5DB),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _ProcedureHero(procedure: procedure),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      procedure.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      procedure.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _DetailPill(
                          icon: Icons.schedule_outlined,
                          title: procedure.time,
                          subtitle: procedure.duration,
                        ),
                        _DetailPill(
                          icon: Icons.person_outline,
                          title: procedure.specialist,
                          subtitle:
                              '\u0441\u043F\u0435\u0446\u0438\u0430'
                              '\u043B\u0438\u0441\u0442',
                        ),
                        _DetailPill(
                          icon: Icons.meeting_room_outlined,
                          title: procedure.room,
                          subtitle:
                              '\u043C\u0435\u0441\u0442\u043E '
                              '\u043F\u0440\u043E\u0432\u0435\u0434'
                              '\u0435\u043D\u0438\u044F',
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      '\u041A\u0430\u043A '
                      '\u043F\u043E\u0434\u0433\u043E\u0442\u043E'
                      '\u0432\u0438\u0442\u044C\u0441\u044F',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    const _AdviceRow(
                      icon: Icons.water_drop_outlined,
                      text:
                          '\u0412\u044B\u043F\u0435\u0439\u0442\u0435 '
                          '\u0432\u043E\u0434\u044B \u0437\u0430 '
                          '20 \u043C\u0438\u043D\u0443\u0442 '
                          '\u0434\u043E \u043F\u0440\u043E\u0446'
                          '\u0435\u0434\u0443\u0440\u044B.',
                    ),
                    const _AdviceRow(
                      icon: Icons.access_time,
                      text:
                          '\u041F\u0440\u0438\u0434\u0438\u0442\u0435 '
                          '\u043D\u0430 10 \u043C\u0438\u043D\u0443'
                          '\u0442 \u0440\u0430\u043D\u044C\u0448\u0435.',
                    ),
                    const _AdviceRow(
                      icon: Icons.favorite_border,
                      text:
                          '\u041F\u043E\u0441\u043B\u0435 '
                          '\u0441\u0435\u0430\u043D\u0441\u0430 '
                          '\u0437\u0430\u043F\u043B\u0430\u043D'
                          '\u0438\u0440\u0443\u0439\u0442\u0435 '
                          '\u0441\u043F\u043E\u043A\u043E\u0439'
                          '\u043D\u044B\u0439 \u0440\u0438\u0442'
                          '\u043C.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProcedureHero extends StatelessWidget {
  const _ProcedureHero({required this.procedure});

  final _Procedure procedure;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: procedure.colors,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -30,
            child: Icon(
              procedure.icon,
              size: 180,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            left: 18,
            top: 18,
            child: CircleAvatar(
              radius: 31,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
              child: Icon(procedure.icon, color: Colors.white, size: 31),
            ),
          ),
          Positioned(
            left: 18,
            right: 18,
            bottom: 18,
            child: Text(
              procedure.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailPill extends StatelessWidget {
  const _DetailPill({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: SpaThemeColors.blue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceRow extends StatelessWidget {
  const _AdviceRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: SpaThemeColors.gold),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
