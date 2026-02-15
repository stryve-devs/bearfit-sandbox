import 'package:flutter/material.dart';
import 'select_timer_sound_page.dart';
import 'timer_volume_page.dart';
import 'check_set_volume_page.dart';
import 'live_pr_volume_page.dart';

class SoundsPage extends StatefulWidget {
  const SoundsPage({super.key});

  @override
  State<SoundsPage> createState() => _SoundsPageState();
}

class _SoundsPageState extends State<SoundsPage> {
  String timerSound = "Default";
  String timerVolume = "High";
  String checkSet = "Off";
  String livePR = "High";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C120A),
        leading: const BackButton(color: Color(0xFFFF7825)),
        title: const Text("Sounds",
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [

          _tile("Timer Sound", timerSound, () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SelectTimerSoundPage(
                  initialValue: timerSound,
                ),
              ),
            );
            if (result != null) {
              setState(() => timerSound = result);
            }
          }),

          _tile("Timer Volume", timerVolume, () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TimerVolumePage(
                  initialValue: timerVolume,
                ),
              ),
            );
            if (result != null) {
              setState(() => timerVolume = result);
            }
          }),

          _tile("Check Set", checkSet, () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CheckSetVolumePage(
                  initialValue: checkSet,
                ),
              ),
            );
            if (result != null) {
              setState(() => checkSet = result);
            }
          }),

          _tile("Live Personal Record Volume", livePR, () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LivePRVolumePage(
                  initialValue: livePR,
                ),
              ),
            );
            if (result != null) {
              setState(() => livePR = result);
            }
          }),
        ],
      ),
    );
  }

  Widget _tile(String title, String value, VoidCallback onTap) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(color: Colors.orange)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.white54),
        ],
      ),
      onTap: onTap,
    );
  }
}
