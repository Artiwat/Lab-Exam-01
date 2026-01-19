import 'package:flutter/material.dart';

/// หน้าทดสอบแสดงความแตกต่างระหว่างใช้และไม่ใช้ Key
class KeyDemoScreen extends StatefulWidget {
  const KeyDemoScreen({super.key});

  @override
  State<KeyDemoScreen> createState() => _KeyDemoScreenState();
}

class _KeyDemoScreenState extends State<KeyDemoScreen> {
  List<String> _items = ['🍎 Apple', '🍌 Banana', '🍊 Orange'];
  bool _useKey = false;

  void _shuffle() {
    setState(() {
      _items = List.from(_items)..shuffle();
    });
  }

  void _removeFirst() {
    if (_items.isNotEmpty) {
      setState(() {
        _items = List.from(_items)..removeAt(0);
      });
    }
  }

  void _reset() {
    setState(() {
      _items = ['🍎 Apple', '🍌 Banana', '🍊 Orange'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Key Demo'),
        actions: [
          Row(
            children: [
              const Text('Use Key'),
              Switch(
                value: _useKey,
                onChanged: (value) => setState(() => _useKey = value),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _useKey ? '✅ ใช้ Key' : '❌ ไม่ใช้ Key',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return ColorfulTile(
                  // ⭐ Toggle ระหว่างใช้และไม่ใช้ Key
                  key: _useKey ? ValueKey(item) : null,
                  title: item,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _shuffle,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('สลับ'),
                ),
                ElevatedButton.icon(
                  onPressed: _removeFirst,
                  icon: const Icon(Icons.remove),
                  label: const Text('ลบแรก'),
                ),
                ElevatedButton.icon(
                  onPressed: _reset,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tile ที่มี StatefulWidget เก็บสีแบบสุ่ม
class ColorfulTile extends StatefulWidget {
  final String title;

  const ColorfulTile({super.key, required this.title});

  @override
  State<ColorfulTile> createState() => _ColorfulTileState();
}

class _ColorfulTileState extends State<ColorfulTile> {
  // 🎨 สีที่สุ่มตอน initState - เก็บใน State
  late Color _color;

  @override
  void initState() {
    super.initState();
    // สุ่มสีเมื่อสร้าง State ใหม่
    _color = Colors.primaries[DateTime.now().microsecond % Colors.primaries.length];
    print('initState: ${widget.title} -> $_color');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      color: _color.withOpacity(0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _color,
          child: Text(widget.title[0]),
        ),
        title: Text(widget.title),
        subtitle: Text('Color: ${_color.toString().substring(6, 16)}'),
      ),
    );
  }
}