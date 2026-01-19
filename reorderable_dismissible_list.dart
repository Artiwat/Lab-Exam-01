// ชื่อไฟล์: reorderable_dismissible_list.dart
import 'package:flutter/material.dart';

class ReorderableDismissibleList extends StatefulWidget {
  const ReorderableDismissibleList({super.key});

  @override
  State<ReorderableDismissibleList> createState() => _ReorderableDismissibleListState();
}

class _ReorderableDismissibleListState extends State<ReorderableDismissibleList> {
  // ข้อมูล AQI 10 อันดับ (ตัวเลขสมมติเพื่อการแสดงผล)
  final List<Map<String, dynamic>> _items = [
    {'id': '1', 'province': 'เชียงใหม่', 'aqi': 185, 'status': 'มีผลกระทบต่อสุขภาพ'},
    {'id': '2', 'province': 'แม่ฮ่องสอน', 'aqi': 178, 'status': 'มีผลกระทบต่อสุขภาพ'},
    {'id': '3', 'province': 'กรุงเทพฯ', 'aqi': 152, 'status': 'เริ่มมีผลกระทบ'},
    {'id': '4', 'province': 'สมุทรปราการ', 'aqi': 145, 'status': 'เริ่มมีผลกระทบ'},
    {'id': '5', 'province': 'ขอนแก่น', 'aqi': 120, 'status': 'ปานกลาง'},
    {'id': '6', 'province': 'ชลบุรี', 'aqi': 95, 'status': 'ปานกลาง'},
    {'id': '7', 'province': 'ระยอง', 'aqi': 82, 'status': 'ปานกลาง'},
    {'id': '8', 'province': 'นครราชสีมา', 'aqi': 65, 'status': 'ดี'},
    {'id': '9', 'province': 'ภูเก็ต', 'aqi': 42, 'status': 'ดีมาก'},
    {'id': '10', 'province': 'สุราษฎร์ธานี', 'aqi': 35, 'status': 'ดีมาก'},
  ];

  // Helper function สำหรับเลือกสีตามค่า AQI
  Color _getAQIColor(int aqi) {
    if (aqi > 150) return Colors.purple;
    if (aqi > 100) return Colors.orange;
    if (aqi > 50) return Colors.yellow[700]!;
    return Colors.green;
  }

  // Logic สำหรับการจัดลำดับใหม่
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1; // ปรับ index เมื่อเลื่อนลงล่าง
      }
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
  }

  // Logic สำหรับการปัดเพื่อลบหรือจัดเก็บ
  void _handleDismiss(DismissDirection direction, int index) {
    final item = _items[index];
    final String action = direction == DismissDirection.startToEnd ? 'เก็บเข้ากรุ' : 'ลบรายการ';
    
    setState(() {
      _items.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action: จังหวัด${item['province']}'),
        backgroundColor: direction == DismissDirection.startToEnd ? Colors.blueGrey : Colors.red,
        action: SnackBarAction(
          label: 'เลิกทำ',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _items.insert(index, item);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thailand AQI Ranking'),
        centerTitle: true,
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: _items.length,
        onReorder: _onReorder,
        itemBuilder: (context, index) {
          final item = _items[index];

          return Dismissible(
            // ใช้ ID เป็น Key เพื่อความเสถียร
            key: ValueKey(item['id']),
            
            // พื้นหลัง Swipe ขวา (Archive)
            background: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.archive, color: Colors.white),
            ),
            
            // พื้นหลัง Swipe ซ้าย (Delete)
            secondaryBackground: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.delete_forever, color: Colors.white),
            ),

            onDismissed: (direction) => _handleDismiss(direction, index),

            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getAQIColor(item['aqi']),
                  child: Text(
                    '${item['aqi']}',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  '${index + 1}. จังหวัด${item['province']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('สถานะ: ${item['status']}'),
                trailing: const Icon(Icons.drag_handle), // สัญลักษณ์สำหรับการลาก
              ),
            ),
          );
        },
      ),
    );
  }
}