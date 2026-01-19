class Transaction {
  final String id;
  final String category;
  final double amount;
  final bool isIncome;
  final DateTime date;

  Transaction({
    required this.id,
    required this.category,
    required this.amount,
    required this.isIncome,
    required this.date,
  });
}