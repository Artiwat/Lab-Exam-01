import 'package:flutter/material.dart';
import 'transaction.dart'; // ตรวจสอบชื่อไฟล์ให้ตรงกัน

void main() => runApp(const AccountApp());

class AccountApp extends StatefulWidget {
  const AccountApp({super.key});

  @override
  State<AccountApp> createState() => _AccountAppState();
}

class _AccountAppState extends State<AccountApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final List<Transaction> _transactions = []; // เก็บข้อมูลใน Memory

  void _toggleTheme(bool isDark) {
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        scaffoldBackgroundColor: const Color(0xff99d5cf), // สีพื้นหลังตาม Screenshot
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: HomeScreen(
        transactions: _transactions,
        onToggleTheme: _toggleTheme,
        isDarkMode: _themeMode == ThemeMode.dark,
        onUpdate: () => setState(() {}),
      ),
    );
  }
}

// --- หน้าหลัก ---
class HomeScreen extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(bool) onToggleTheme;
  final bool isDarkMode;
  final VoidCallback onUpdate;

  const HomeScreen({
    super.key,
    required this.transactions,
    required this.onToggleTheme,
    required this.isDarkMode,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Account Income\n(\$_\$)', // แก้ไข Error ตรงนี้
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff4a7c7c)),
            ),
            const SizedBox(height: 40),
            _menuButton(context, 'ทำรายการ', () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => EntryScreen(transactions: transactions)));
              onUpdate();
            }),
            _menuButton(context, 'สรุปผล', () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) => SummaryScreen(transactions: transactions)));
              onUpdate();
            }),
            _menuButton(context, 'การตั้งค่า', () => _showSettings(context)),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(BuildContext context, String text, VoidCallback onPressed) {
    return Container(
      width: 220,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff4a7c7c),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ตั้งค่า'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('โหมดมืด (Dark Theme)'),
            Switch(value: isDarkMode, onChanged: (val) {
              onToggleTheme(val);
              Navigator.pop(context);
            }),
          ],
        ),
      ),
    );
  }
}

// --- หน้าบันทึกรายรับรายจ่าย ---
class EntryScreen extends StatefulWidget {
  final List<Transaction> transactions;
  const EntryScreen({super.key, required this.transactions});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  final _catController = TextEditingController();
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _save(bool isIncome) {
    if (_formKey.currentState!.validate()) {
      widget.transactions.add(Transaction(
        id: DateTime.now().toString(),
        category: _catController.text,
        amount: double.parse(_amountController.text),
        isIncome: isIncome,
        date: DateTime.now(),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('หมวดหมู่', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _catController,
                decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'กรุณากรอกหมวดหมู่' : null,
              ),
              const SizedBox(height: 20),
              const Text('จำนวนเงิน', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(filled: true, fillColor: Colors.white, border: OutlineInputBorder()),
                validator: (v) => (v == null || double.tryParse(v) == null) ? 'กรุณากรอกตัวเลขเท่านั้น' : null,
              ),
              const SizedBox(height: 30),
              _btn('บันทึกรายรับ', Colors.green, () => _save(true)),
              _btn('บันทึกรายจ่าย', Colors.red, () => _save(false)),
              _btn('กลับหน้าหลัก', const Color(0xff4a7c7c), () => Navigator.pop(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _btn(String text, Color color, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

// --- หน้าสรุปผล (รองรับ Swipe to delete) ---
class SummaryScreen extends StatefulWidget {
  final List<Transaction> transactions;
  const SummaryScreen({super.key, required this.transactions});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    double totalIn = widget.transactions.where((t) => t.isIncome).fold(0, (s, t) => s + t.amount);
    double totalOut = widget.transactions.where((t) => !t.isIncome).fold(0, (s, t) => s + t.amount);

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          // Table Header
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
          Expanded(
            child: ListView.builder(
              itemCount: widget.transactions.length,
              itemBuilder: (context, index) {
                final tx = widget.transactions[index];
                return Dismissible(
                  key: Key(tx.id),
                  background: Container(color: Colors.red, child: const Icon(Icons.delete, color: Colors.white)),
                  onDismissed: (direction) {
                    setState(() => widget.transactions.removeAt(index));
                  },
                  child: Container(
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black12))),
                    child: Row(
                      children: [
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.blueGrey[200], child: Text(tx.category))),
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.green[100], child: Text(tx.isIncome ? tx.amount.toStringAsFixed(2) : '-', textAlign: TextAlign.center))),
                        Expanded(child: Container(padding: const EdgeInsets.all(10), color: Colors.red[100], child: Text(!tx.isIncome ? tx.amount.toStringAsFixed(2) : '-', textAlign: TextAlign.center))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white.withOpacity(0.5),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('รายรับ'), Text(totalIn.toStringAsFixed(2))]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('รายจ่าย'), Text(totalOut.toStringAsFixed(2))]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('คงเหลือ', style: TextStyle(fontWeight: FontWeight.bold)), Text((totalIn - totalOut).toStringAsFixed(2))]),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff4a7c7c), foregroundColor: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('กลับหน้าหลัก'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}