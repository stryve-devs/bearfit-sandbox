import 'package:flutter/material.dart';

class DurationPickerResult {
  final int minutes;
  final int seconds;
  const DurationPickerResult(this.minutes, this.seconds);
  Duration get duration => Duration(minutes: minutes, seconds: seconds);
}

class DurationPickerDialog extends StatefulWidget {
  final int initialMinutes;
  final int initialSeconds;
  final int minTotalSeconds;
  final int maxTotalSeconds;
  const DurationPickerDialog({
    super.key,
    this.initialMinutes = 0,
    this.initialSeconds = 0,
    this.minTotalSeconds = 5,
    this.maxTotalSeconds = 3599,
  });

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late FixedExtentScrollController _minCtrl;
  late FixedExtentScrollController _secCtrl;
  late int _m;
  late int _s;

  @override
  void initState() {
    super.initState();
    _m = widget.initialMinutes.clamp(0, 59);
    _s = widget.initialSeconds.clamp(0, 59);
    _minCtrl = FixedExtentScrollController(initialItem: _m);
    _secCtrl = FixedExtentScrollController(initialItem: _s);
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _secCtrl.dispose();
    super.dispose();
  }

  bool _valid(int m, int s) {
    final total = m * 60 + s;
    return total >= widget.minTotalSeconds && total <= widget.maxTotalSeconds;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select duration',
              style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller: _minCtrl,
                      itemExtent: 32,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _m = i),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (c, i) => i == null || i < 0 || i > 59
                            ? null
                            : Center(
                                child: Text(
                                  i.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16),
                                ),
                              ),
                        childCount: 60,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(':', style: TextStyle(fontFamily: 'Quicksand', fontSize: 16)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: ListWheelScrollView.useDelegate(
                      controller: _secCtrl,
                      itemExtent: 32,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (i) => setState(() => _s = i),
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (c, i) => i == null || i < 0 || i > 59
                            ? null
                            : Center(
                                child: Text(
                                  i.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontFamily: 'Quicksand', fontSize: 16),
                                ),
                              ),
                        childCount: 60,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(fontFamily: 'Quicksand', fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: _valid(_m, _s)
                      ? () => Navigator.pop(context, DurationPickerResult(_m, _s))
                      : null,
                  child: const Text('OK', style: TextStyle(fontFamily: 'Quicksand', fontSize: 16)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}