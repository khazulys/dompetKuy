import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with SingleTickerProviderStateMixin {
  TransactionCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final transactionProvider = context.watch<TransactionProvider>();
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    var transactions = transactionProvider.transactions;
    if (_selectedCategory != null) {
      transactions = transactions
          .where((t) => t.category == _selectedCategory)
          .toList();
    }

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
                    'Transaksi',
                    style: context.theme.typography.xl3.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colors.foreground,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'Semua',
                          isSelected: _selectedCategory == null,
                          onTap: () => setState(() => _selectedCategory = null),
                        ),
                        ...TransactionCategory.values.map((category) {
                          return _FilterChip(
                            label: _getCategoryName(category),
                            isSelected: _selectedCategory == category,
                            onTap: () =>
                                setState(() => _selectedCategory = category),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: context.theme.colors.mutedForeground,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada transaksi',
                            style: context.theme.typography.base.copyWith(
                              color: context.theme.colors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FCard(
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: context.theme.colors.muted,
                                child: Icon(
                                  _getCategoryIcon(transaction.category),
                                  color: context.theme.colors.foreground,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                transaction.title,
                                style: context.theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: context.theme.colors.foreground,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                  'id_ID',
                                ).format(transaction.date),
                                style: context.theme.typography.sm.copyWith(
                                  color: context.theme.colors.mutedForeground,
                                ),
                              ),
                              trailing: Text(
                                '${transaction.type == TransactionType.income ? '+' : '-'} ${currencyFormat.format(transaction.amount)}',
                                style: context.theme.typography.base.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      transaction.type == TransactionType.income
                                      ? context.theme.colors.foreground
                                      : context.theme.colors.mutedForeground,
                                ),
                              ),
                              onTap: () =>
                                  _showTransactionDetails(context, transaction),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'transactions-fab',
        onPressed: () => _showAddTransactionDialog(context),
        backgroundColor: context.theme.colors.primary,
        foregroundColor: context.theme.colors.primaryForeground,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getCategoryName(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return 'Gaji';
      case TransactionCategory.business:
        return 'Bisnis';
      case TransactionCategory.investment:
        return 'Investasi';
      case TransactionCategory.food:
        return 'Makanan';
      case TransactionCategory.transport:
        return 'Transport';
      case TransactionCategory.shopping:
        return 'Belanja';
      case TransactionCategory.entertainment:
        return 'Hiburan';
      case TransactionCategory.health:
        return 'Kesehatan';
      case TransactionCategory.education:
        return 'Pendidikan';
      case TransactionCategory.bills:
        return 'Tagihan';
      case TransactionCategory.other:
        return 'Lainnya';
    }
  }

  IconData _getCategoryIcon(TransactionCategory category) {
    switch (category) {
      case TransactionCategory.salary:
        return Icons.work;
      case TransactionCategory.business:
        return Icons.business;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.health:
        return Icons.health_and_safety;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.bills:
        return Icons.receipt;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    final noteController = TextEditingController();
    TransactionType type = TransactionType.expense;
    TransactionCategory category = TransactionCategory.other;
    DateTime selectedDate = DateTime.now();

    final theme = context.theme;
    final typeController = FSelectController<TransactionType>(
      vsync: this,
      value: type,
    );
    final categoryController = FSelectController<TransactionCategory>(
      vsync: this,
      value: category,
    );

    final dialog = showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: theme.colors.background,
          title: Text(
            'Tambah Transaksi',
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
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    labelStyle: TextStyle(color: theme.colors.mutedForeground),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.border),
                    ),
                  ),
                  style: TextStyle(color: theme.colors.foreground),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Jumlah',
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
                FSelect<TransactionType>.rich(
                  controller: typeController,
                  label: const Text('Tipe'),
                  hint: 'Pilih tipe transaksi',
                  format: (value) => value == TransactionType.income
                      ? 'Pemasukan'
                      : 'Pengeluaran',
                  onChange: (value) {
                    if (value != null) {
                      setState(() => type = value);
                    }
                  },
                  children: const [
                    FSelectItem(
                      title: Text('Pemasukan'),
                      value: TransactionType.income,
                    ),
                    FSelectItem(
                      title: Text('Pengeluaran'),
                      value: TransactionType.expense,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FSelect<TransactionCategory>.rich(
                  controller: categoryController,
                  label: const Text('Kategori'),
                  hint: 'Pilih kategori',
                  format: (value) => _getCategoryName(value),
                  onChange: (value) {
                    if (value != null) {
                      setState(() => category = value);
                    }
                  },
                  children: [
                    for (final cat in TransactionCategory.values)
                      FSelectItem(
                        title: Text(_getCategoryName(cat)),
                        value: cat,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Catatan (opsional)',
                    labelStyle: TextStyle(color: theme.colors.mutedForeground),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: theme.colors.border),
                    ),
                  ),
                  style: TextStyle(color: theme.colors.foreground),
                  maxLines: 3,
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
                if (titleController.text.isEmpty ||
                    amountController.text.isEmpty) {
                  return;
                }

                final transaction = Transaction(
                  id: const Uuid().v4(),
                  title: titleController.text,
                  amount: double.parse(amountController.text),
                  type: type,
                  category: category,
                  date: selectedDate,
                  note: noteController.text.isEmpty
                      ? null
                      : noteController.text,
                );

                context.read<TransactionProvider>().addTransaction(transaction);
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

    dialog.whenComplete(() {
      typeController.dispose();
      categoryController.dispose();
    });
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final theme = context.theme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: theme.colors.background,
        title: Text(
          transaction.title,
          style: theme.typography.lg.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colors.foreground,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailRow(
              'Jumlah',
              currencyFormat.format(transaction.amount),
              context,
            ),
            _detailRow(
              'Tipe',
              transaction.type == TransactionType.income
                  ? 'Pemasukan'
                  : 'Pengeluaran',
              context,
            ),
            _detailRow(
              'Kategori',
              _getCategoryName(transaction.category),
              context,
            ),
            _detailRow(
              'Tanggal',
              DateFormat('dd MMMM yyyy', 'id_ID').format(transaction.date),
              context,
            ),
            if (transaction.note != null)
              _detailRow('Catatan', transaction.note!, context),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<TransactionProvider>().deleteTransaction(
                transaction.id,
              );
              Navigator.pop(context);
            },
            child: Text('Hapus', style: TextStyle(color: theme.colors.error)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: TextStyle(color: theme.colors.mutedForeground),
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
            width: 80,
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

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? context.theme.colors.primary
                : context.theme.colors.muted,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? context.theme.colors.primary
                  : context.theme.colors.border,
            ),
          ),
          child: Text(
            label,
            style: context.theme.typography.sm.copyWith(
              color: isSelected
                  ? context.theme.colors.primaryForeground
                  : context.theme.colors.foreground,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
