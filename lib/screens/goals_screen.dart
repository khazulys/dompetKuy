import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/goal_provider.dart';
import '../models/goal.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: context.theme.colors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Target Tabungan',
                    style: context.theme.typography.xl3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FCard(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Target',
                                  style: context.theme.typography.sm.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormat.format(goalProvider.totalTargetAmount),
                                  style: context.theme.typography.xl.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colors.foreground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total Terkumpul',
                                  style: context.theme.typography.sm.copyWith(
                                    color: context.theme.colors.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  currencyFormat.format(goalProvider.totalSavedAmount),
                                  style: context.theme.typography.xl.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: context.theme.colors.foreground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: context.theme.colors.foreground,
                      unselectedLabelColor: context.theme.colors.mutedForeground,
                      indicatorColor: context.theme.colors.primary,
                      tabs: const [
                        Tab(text: 'Aktif'),
                        Tab(text: 'Selesai'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildGoalList(context, goalProvider.activeGoals, false),
                          _buildGoalList(context, goalProvider.completedGoals, true),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context),
        backgroundColor: context.theme.colors.primary,
        foregroundColor: context.theme.colors.primaryForeground,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildGoalList(BuildContext context, List<Goal> goals, bool isCompleted) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (goals.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.savings_outlined,
              size: 64,
              color: context.theme.colors.mutedForeground,
            ),
            const SizedBox(height: 16),
            Text(
              isCompleted ? 'Belum ada target yang selesai' : 'Belum ada target tabungan',
              style: context.theme.typography.base.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: goals.length,
      itemBuilder: (context, index) {
        final goal = goals[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: FCard(
            child: InkWell(
              onTap: () => _showGoalDetails(context, goal),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            goal.name,
                            style: context.theme.typography.lg.copyWith(
                              fontWeight: FontWeight.w600,
                              color: context.theme.colors.foreground,
                            ),
                          ),
                        ),
                        if (goal.isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.theme.colors.muted,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Selesai',
                              style: context.theme.typography.xs.copyWith(
                                color: context.theme.colors.foreground,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terkumpul',
                                style: context.theme.typography.xs.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                              Text(
                                currencyFormat.format(goal.currentAmount),
                                style: context.theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.colors.foreground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Target',
                                style: context.theme.typography.xs.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                              Text(
                                currencyFormat.format(goal.targetAmount),
                                style: context.theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.colors.foreground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              goal.daysLeft >= 0 ? '${goal.daysLeft} hari lagi' : 'Terlambat',
                              style: context.theme.typography.xs.copyWith(
                                color: context.theme.colors.mutedForeground,
                              ),
                            ),
                            Text(
                              '${(goal.progress * 100).toStringAsFixed(0)}%',
                              style: context.theme.typography.xl.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.theme.colors.foreground,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: goal.progress.clamp(0.0, 1.0),
                        backgroundColor: context.theme.colors.muted,
                        valueColor: AlwaysStoppedAnimation(
                          context.theme.colors.primary,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddGoalDialog(BuildContext context) {
    final nameController = TextEditingController();
    final targetAmountController = TextEditingController();
    final currentAmountController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 30));
    
    final theme = context.theme;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: theme.colors.background,
          title: Text(
            'Buat Target Baru',
            style: theme.typography.lg.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colors.foreground,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Nama Target',
                    labelStyle: TextStyle(color: theme.colors.mutedForeground),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.border),
                    ),
                  ),
                  style: TextStyle(color: theme.colors.foreground),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: targetAmountController,
                  decoration: InputDecoration(
                    labelText: 'Jumlah Target',
                    labelStyle: TextStyle(color: theme.colors.mutedForeground),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.border),
                    ),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.colors.foreground),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: currentAmountController,
                  decoration: InputDecoration(
                    labelText: 'Jumlah Awal (opsional)',
                    labelStyle: TextStyle(color: theme.colors.mutedForeground),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.border),
                    ),
                    prefixText: 'Rp ',
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: theme.colors.foreground),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    'Tenggat Waktu',
                    style: theme.typography.sm.copyWith(
                      color: theme.colors.mutedForeground,
                    ),
                  ),
                  subtitle: Text(
                    DateFormat('dd MMMM yyyy', 'id_ID').format(selectedDate),
                    style: theme.typography.base.copyWith(
                      color: theme.colors.foreground,
                    ),
                  ),
                  trailing: Icon(Icons.calendar_today, color: theme.colors.foreground),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 3650)),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(color: theme.colors.mutedForeground),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty || targetAmountController.text.isEmpty) {
                  return;
                }

                final goal = Goal(
                  id: const Uuid().v4(),
                  name: nameController.text,
                  targetAmount: double.parse(targetAmountController.text),
                  currentAmount: currentAmountController.text.isEmpty
                      ? 0
                      : double.parse(currentAmountController.text),
                  deadline: selectedDate,
                  createdAt: DateTime.now(),
                );

                context.read<GoalProvider>().addGoal(goal);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.colors.primary,
                foregroundColor: context.theme.colors.primaryForeground,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDetails(BuildContext context, Goal goal) {
    final amountController = TextEditingController();
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final theme = context.theme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colors.background,
        title: Text(
          goal.name,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow('Target', currencyFormat.format(goal.targetAmount), context),
            _detailRow('Terkumpul', currencyFormat.format(goal.currentAmount), context),
            _detailRow('Sisa', currencyFormat.format(goal.targetAmount - goal.currentAmount), context),
            _detailRow('Progress', '${(goal.progress * 100).toStringAsFixed(1)}%', context),
            _detailRow('Tenggat', DateFormat('dd MMMM yyyy', 'id_ID').format(goal.deadline), context),
            _detailRow('Hari Tersisa', '${goal.daysLeft} hari', context),
            if (!goal.isCompleted) ...[
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Tambah Jumlah',
                  labelStyle: TextStyle(color: theme.colors.mutedForeground),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: theme.colors.border),
                  ),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: theme.colors.foreground),
              ),
            ],
          ],
        ),
        actions: [
          if (!goal.isCompleted)
            ElevatedButton(
              onPressed: () {
                if (amountController.text.isNotEmpty) {
                  final amount = double.parse(amountController.text);
                  context.read<GoalProvider>().addAmountToGoal(goal.id, amount);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colors.primary,
                foregroundColor: theme.colors.primaryForeground,
              ),
              child: const Text('Tambah'),
            ),
          TextButton(
            onPressed: () {
              context.read<GoalProvider>().deleteGoal(goal.id);
              Navigator.pop(context);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: theme.colors.error),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: TextStyle(color: context.theme.colors.mutedForeground),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: context.theme.typography.sm.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w500,
                color: context.theme.colors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
