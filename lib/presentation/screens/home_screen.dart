import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../domain/models/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../theme/app_colors.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'stats_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final TaskRepository repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await widget.repository.getTasks();
      setState(() => _tasks = tasks);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tasks: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _toggleTask(Task task) async {
    try {
      await widget.repository.toggleTaskCompletion(
        task.id,
        !task.isCompleted,
      );
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating task: $e')),
        );
      }
    }
  }

  Future<void> _deleteTask(String id) async {
    try {
      await widget.repository.deleteTask(id);
      await _loadTasks();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting task: $e')),
        );
      }
    }
  }

  Future<void> _goToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTaskScreen(repository: widget.repository),
      ),
    );
    if (result == true) await _loadTasks();
  }

  List<Task> get _todayTasks => _tasks;
  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  double get _completionPercent =>
      _tasks.isEmpty ? 0 : _completedCount / _tasks.length;
  int get _totalWeekly => _tasks.length;
  int get _pendingWeekly => _tasks.where((t) => !t.isCompleted).length;

  Widget _buildHomeTab() {
    return Column(
      children: [
        // ── Top card ──────────────────────────────────────────
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              CircularPercentIndicator(
                radius: 45,
                lineWidth: 7,
                percent: _completionPercent.clamp(0.0, 1.0),
                center: Text(
                  '${(_completionPercent * 100).toInt()}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
                progressColor: AppColors.primary,
                backgroundColor: AppColors.progressBackground,
                circularStrokeCap: CircularStrokeCap.round,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Weekly Tasks',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textDark,
                          ),
                        ),
                        GestureDetector(
                          onTap: _goToAddTask,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: AppColors.textDark,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _statBox('$_totalWeekly', AppColors.textDark),
                        const SizedBox(width: 12),
                        _statBox('$_pendingWeekly', Colors.redAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Today Tasks header ──────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Today Tasks',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                '$_completedCount of ${_tasks.length}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // ── Progress bar ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _completionPercent.clamp(0.0, 1.0),
              backgroundColor: AppColors.progressBackground,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ── Task list ───────────────────────────────────────
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : _tasks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt,
                              size: 60, color: AppColors.textGrey),
                          SizedBox(height: 12),
                          Text(
                            'No tasks yet!\nTap + to add one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _todayTasks.length,
                      itemBuilder: (_, index) {
                        final task = _todayTasks[index];
                        return TaskCard(
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onDelete: () => _deleteTask(task.id),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            // Tab 0 — Home
            Column(children: [Expanded(child: _buildHomeTab())]),

            // Tab 1 — Stats
            StatsScreen(tasks: _tasks),

            // Tab 2 — placeholder (Add opens as modal)
            const SizedBox(),

            // Tab 3 — Notifications placeholder
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded,
                      size: 60, color: AppColors.textGrey),
                  SizedBox(height: 12),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                        color: AppColors.textGrey, fontSize: 15),
                  ),
                ],
              ),
            ),

            // Tab 4 — Profile
            ProfileScreen(tasks: _tasks),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedNavIndex == 2 ? 0 : _selectedNavIndex,
          onTap: (index) {
            if (index == 2) {
              _goToAddTask();
            } else {
              setState(() => _selectedNavIndex = index);
            }
          },
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textGrey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.add, color: Colors.white, size: 22),
              ),
              label: 'Add',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none_rounded),
              label: 'Notifications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.progressBackground),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: color,
        ),
      ),
    );
  }
}