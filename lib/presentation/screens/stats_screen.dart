import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../../theme/app_colors.dart';

class StatsScreen extends StatelessWidget {
  final List<Task> tasks;

  const StatsScreen({super.key, required this.tasks});

  Map<String, int> get _tasksByCategory {
    final Map<String, int> map = {};
    for (final task in tasks) {
      map[task.category] = (map[task.category] ?? 0) + 1;
    }
    return map;
  }

  int get _completed => tasks.where((t) => t.isCompleted).length;
  int get _pending => tasks.where((t) => !t.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    final categoryMap = _tasksByCategory;
    final total = tasks.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          'My Statistics',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    'Total',
                    '$total',
                    Icons.list_alt_rounded,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    'Completed',
                    '$_completed',
                    Icons.check_circle_outline,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    'Pending',
                    '$_pending',
                    Icons.pending_outlined,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Completion rate
            const Text(
              'Completion Rate',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
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
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        total == 0
                            ? '0%'
                            : '${((_completed / total) * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        '$_completed / $total tasks done',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: total == 0 ? 0 : _completed / total,
                      backgroundColor: AppColors.progressBackground,
                      valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                      minHeight: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Tasks by category
            const Text(
              'Tasks by Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 12),
            if (categoryMap.isEmpty)
              const Center(
                child: Text(
                  'No tasks yet',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              )
            else
              ...categoryMap.entries.map((entry) {
                final percent = total == 0 ? 0.0 : entry.value / total;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.key,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDark,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '${entry.value} task${entry.value > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: percent,
                          backgroundColor: AppColors.progressBackground,
                          valueColor:
                              const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
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
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textGrey,
            ),
          ),
        ],
      ),
    );
  }
}