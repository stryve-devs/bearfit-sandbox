import 'package:flutter/material.dart';

import './data/programs_data.dart';
import './widgets/program_card.dart';

// Pages
import './home/home_routines_page.dart';
import './travel/travel_routines_page.dart';
import './dumbbell/dumbbell_routines_page.dart';
import './bands/band_routines_page.dart';
import './cardio_hiit/cardio_hiit_routines_page.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Explore',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          final title = program.title.toLowerCase();

          return GestureDetector(
            onTap: () {
              if (title.contains('home')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeRoutinesPage(),
                  ),
                );
              } else if (title.contains('travel')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TravelRoutinesPage(),
                  ),
                );
              } else if (title.contains('dumbbell')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DumbbellRoutinesPage(),
                  ),
                );
              } else if (title.contains('band')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BandRoutinesPage(),
                  ),
                );
              } else if (title.contains('cardio') ||
                  title.contains('hiit')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CardioHiitRoutinesPage(),
                  ),
                );
              }
            },
            child: ProgramCard(program: program),
          );
        },
      ),
    );
  }
}
