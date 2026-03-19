import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  final List<Task> tasks;

  const ProfileScreen({super.key, required this.tasks});

  int get _completed => tasks.where((t) => t.isCompleted).length;
  int get _pending => tasks.where((t) => !t.isCompleted).length;
  String get _productivityLevel {
    if (tasks.isEmpty) return 'Getting Started 🌱';
    final rate = _completed / tasks.length;
    if (rate >= 0.8) return 'Productivity Master 🏆';
    if (rate >= 0.5) return 'On Track 🚀';
    return 'Keep Going 💪';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryLight,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 46,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'My Tasks Dashboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _productivityLevel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _overviewRow(
                    Icons.list_alt_rounded,
                    'Total Tasks',
                    '${tasks.length}',
                    AppColors.primary,
                  ),
                  const Divider(height: 20),
                  _overviewRow(
                    Icons.check_circle_outline,
                    'Completed',
                    '$_completed',
                    Colors.green,
                  ),
                  const Divider(height: 20),
                  _overviewRow(
                    Icons.pending_outlined,
                    'Pending',
                    '$_pending',
                    Colors.orange,
                  ),
                  const Divider(height: 20),
                  _overviewRow(
                    Icons.emoji_events_outlined,
                    'Completion Rate',
                    tasks.isEmpty
                        ? '0%'
                        : '${((_completed / tasks.length) * 100).toInt()}%',
                    AppColors.primaryDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Motivational quote
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Icon(Icons.format_quote_rounded,
                      color: AppColors.primary, size: 28),
                  SizedBox(height: 8),
                  Text(
                    '"The secret of getting ahead is getting started."',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '— Mark Twain',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _overviewRow(
      IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}