import 'package:flutter/material.dart';
import '../../domain/models/task.dart';
import '../../theme/app_colors.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEarly = task.scheduledTime != null &&
        (task.scheduledTime!.contains('6') ||
            task.scheduledTime!.contains('7') ||
            task.scheduledTime!.contains('8'));

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
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
            // Imagen si existe
            if (task.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  task.imageUrl!,
                  width: double.infinity,
                  height: 140,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 140,
                      color: AppColors.primaryLight,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: AppColors.primaryLight,
                    child: const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.primary,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),

            // Contenido
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onToggle,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: task.isCompleted
                              ? AppColors.completedCheck
                              : AppColors.progressBackground,
                          width: 2,
                        ),
                        color: task.isCompleted
                            ? AppColors.completedCheck
                            : Colors.transparent,
                      ),
                      child: task.isCompleted
                          ? const Icon(Icons.check,
                              size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: task.isCompleted
                                ? AppColors.textGrey
                                : AppColors.textDark,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (task.description != null)
                          Text(
                            task.description!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textGrey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (task.scheduledTime != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isEarly
                            ? AppColors.timeChipYellow
                            : AppColors.timeChipGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.scheduledTime!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isEarly
                              ? AppColors.timeChipYellowText
                              : AppColors.timeChipGreenText,
                        ),
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
}