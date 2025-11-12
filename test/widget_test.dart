import 'package:flutter_test/flutter_test.dart';
import 'package:dompetkuy/models/transaction.dart';
import 'package:dompetkuy/models/goal.dart';

void main() {
  group('Transaction Model Tests', () {
    test('Transaction should be created correctly', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test Transaction',
        amount: 50000,
        type: TransactionType.income,
        category: TransactionCategory.salary,
        date: DateTime.now(),
      );

      expect(transaction.id, '1');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 50000);
      expect(transaction.type, TransactionType.income);
    });

    test('Transaction toJson should work correctly', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 100,
        type: TransactionType.expense,
        category: TransactionCategory.food,
        date: DateTime(2024, 1, 1),
      );

      final json = transaction.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Test');
      expect(json['amount'], 100);
    });
  });

  group('Goal Model Tests', () {
    test('Goal should calculate progress correctly', () {
      final goal = Goal(
        id: '1',
        name: 'Buy Laptop',
        targetAmount: 10000000,
        currentAmount: 5000000,
        deadline: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
      );

      expect(goal.progress, 0.5);
      expect(goal.isCompleted, false);
    });

    test('Goal should detect completion', () {
      final goal = Goal(
        id: '1',
        name: 'Buy Phone',
        targetAmount: 5000000,
        currentAmount: 5000000,
        deadline: DateTime.now().add(const Duration(days: 10)),
        createdAt: DateTime.now(),
      );

      expect(goal.isCompleted, true);
      expect(goal.progress, 1.0);
    });
  });
}
