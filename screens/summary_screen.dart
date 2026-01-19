import 'package:flutter/material.dart';
import '../transaction.dart';

class SummaryScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) onDelete;

  const SummaryScreen({super.key, required this.transactions, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    double totalIncome = transactions.where((t) => t.isIncome).fold(0, (sum, t) => sum + t.amount);
    double totalExpense = transactions.where((t) => !t.isIncome).fold(0, (sum, t) => sum + t.amount);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Header Table
          Container(
            color: const Color(0xff4a7c7c),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Row(
              children: [
                Expanded(child: Text('หมวดหมู่', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                Expanded(child: Text('รายรับ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                Expanded(child: Text('รายจ่าย', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return Dismissible(
                  key: Key(tx.id),
                  background: Container(color: Colors.red, alignment: Alignment.centerLeft, child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (dir) => onDelete(tx.id),
                  child: Container(
                    decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
                    child: Row(
                      children: [
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.blueGrey.shade200, child: Text(tx.category))),
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.green.shade100, child: Text(tx.isIncome ? tx.amount.toStringAsFixed(2) : '-', textAlign: TextAlign.center))),
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.red.shade100, child: Text(!tx.isIncome ? tx.amount.toStringAsFixed(2) : '-', textAlign: TextAlign.center))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Summary Footer
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.teal.shade50,
            child: Column(
              children: [
                _sumRow('รายรับ', totalIncome),
                _sumRow('รายจ่าย', totalExpense),
                const Divider(),
                _sumRow('คงเหลือ', totalIncome - totalExpense, isBold: true),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff4a7c7c), foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('กลับหน้าหลัก'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _sumRow(String label, double value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 18)),
        Text(value.toStringAsFixed(2), style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 18)),
      ],
    );
  }
}