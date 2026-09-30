import 'package:flutter/material.dart';
import 'package:username/username.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) =>
      MaterialApp(
        title: 'Username 随机用户名示例',
        theme: ThemeData(
          colorSchemeSeed: Colors.indigo,
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        home: const MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _enOne = '';
  List<String> _enList = [];
  String _cnOne = '';
  List<String> _cnList = [];

  void _genEnOne() =>
      setState(() => _enOne = Username.en().fullname);

  void _genEnList() => setState(
      () => _enList = Username.en(surName: 'Jackson').getFullnames(count: 3));

  void _genCnOne() =>
      setState(() => _cnOne = Username.cn().fullname);

  void _genCnList() => setState(
      () => _cnList = Username.cn(surName: '王').getFullnames(count: 6));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Username 随机用户名示例')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NameCard(
                title: '英文名',
                icon: Icons.language,
                color: Colors.blue,
                name: _enOne,
                list: _enList,
                onGenOne: _genEnOne,
                onGenList: _genEnList,
                genOneLabel: '生成 1 个',
                genListLabel: '生成 3 个（Jackson 姓氏）',
              ),
              const SizedBox(height: 16),
              _NameCard(
                title: '中文名',
                icon: Icons.translate,
                color: Colors.deepOrange,
                name: _cnOne,
                list: _cnList,
                onGenOne: _genCnOne,
                onGenList: _genCnList,
                genOneLabel: '生成 1 个',
                genListLabel: '生成 6 个（王姓）',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NameCard extends StatelessWidget {
  const _NameCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.name,
    required this.list,
    required this.onGenOne,
    required this.onGenList,
    required this.genOneLabel,
    required this.genListLabel,
  });

  final String title;
  final IconData icon;
  final Color color;
  final String name;
  final List<String> list;
  final VoidCallback onGenOne;
  final VoidCallback onGenList;
  final String genOneLabel;
  final String genListLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name.isEmpty ? '（点击下方按钮生成）' : name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (list.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final n in list) Chip(label: Text(n)),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: onGenOne,
                  icon: const Icon(Icons.refresh),
                  label: Text(genOneLabel),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: onGenList,
                  child: Text(genListLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
