import 'package:flutter/material.dart';
import '../transaction.dart';

class EntryScreen extends StatefulWidget {
  final Function(Transaction) onSave;
  const EntryScreen({super.key, required this.onSave});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _catController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _submit(bool isIncome) {
    if (_formKey.currentState!.validate()) {
      final tx = Transaction(
        id: DateTime.now().toString(),
        category: _catController.text,
        amount: double.parse(_amountController.text),
        isIncome: isIncome,
        date: DateTime.now(),
      );
      widget.onSave(tx);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('หมวดหมู่', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _catController,
                decoration: const InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกหมวดหมู่' : null,
              ),
              const SizedBox(height: 20),
              const Text('จำนวนเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(fillColor: Colors.white, filled: true, border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || double.tryParse(v) == null) return 'กรุณากรอกตัวเลขที่ถูกต้อง';
                  return null;
                },
              ),
              const SizedBox(height: 30),
              _actionButton('บันทึกรายรับ', Colors.green, () => _submit(true)),
              _actionButton('บันทึกรายจ่าย', Colors.red, () => _submit(false)),
              _actionButton('กลับหน้าหลัก', const Color(0xff4a7c7c), () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String text, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}