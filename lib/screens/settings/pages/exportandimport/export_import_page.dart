import 'package:flutter/material.dart';
import 'export_data_page.dart';
import 'import_data_page.dart';

class ExportImportPage extends StatelessWidget {
  const ExportImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF2A1608),
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Export & Import Data',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          _tile(
            context,
            icon: Icons.upload_file,
            title: 'Export Data',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExportDataPage()),
              );
            },
          ),
          _tile(
            context,
            icon: Icons.download,
            title: 'Import Data',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ImportDataPage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF2E2E2E),
          border: Border(
            bottom: BorderSide(color: Colors.black),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFFF7A00)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFF7A00),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white54),
          ],
        ),
      ),
    );
  }
}
