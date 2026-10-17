import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CyberTerminalApp());
}

class CyberTerminalApp extends StatelessWidget {
  const CyberTerminalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberTerminal OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.greenAccent,
        fontFamily: 'monospace',
      ),
      home: const TerminalHome(),
    );
  }
}

class TerminalHome extends StatefulWidget {
  const TerminalHome({super.key});

  @override
  State<TerminalHome> createState() => _TerminalHomeState();
}

class _TerminalHomeState extends State<TerminalHome> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    TerminalScreen(),
    RadarScreen(),
    ToolsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.terminal), label: 'Terminal'),
          BottomNavigationBarItem(icon: Icon(Icons.radar), label: 'Global Radar'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Exploits'),
        ],
      ),
    );
  }
}

// ==================== 1. TERMINAL SCREEN ====================
class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final List<String> _logs = [
    '[SYSTEM] Initializing CyberTerminal v4.0.2...',
    '[SECURE] Establishing encrypted tunnel over port 443...',
    '[OK] Root privileges acquired successfully.',
  ];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  final Random _random = Random();
  Timer? _streamTimer;
  bool _isStreaming = true;

  final List<String> _mockCodePool = [
    '0x4F7A9B C2:FF:11:AA:EE [TCP] SYN_SENT target=192.168.1.105',
    'Injecting payload into memory sector 0x7FFF...',
    'Bypassing firewall layer 3... [SUCCESS]',
    'SQL Injection payload sent: SELECT * FROM users WHERE admin=1;',
    'Decrypting AES-256 hash: \$2a\$12\$R9h/c.1a2b3c4d5e6f7g8h...',
    'ACCESS GRANTED: Node [US-EAST-1] compromised.',
    'Downloading classified database (14.8 GB / 50.0 GB)...',
    'Tracing IP address: 185.220.101.5 [TOR Exit Node]',
    'Buffer overflow executed at memory address 0x00401000',
  ];

  @override
  void initState() {
    super.initState();
    _startAutoStream();
  }

  void _startAutoStream() {
    _streamTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (!_isStreaming) return;
      String newLog = _mockCodePool[_random.nextInt(_mockCodePool.length)];
      setState(() {
        _logs.add(newLog);
        if (_logs.length > 100) _logs.removeAt(0);
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleCommand(String cmd) {
    setState(() {
      _logs.add('root@cyber-os:~# $cmd');
      if (cmd.toLowerCase() == 'root') {
        _logs.add('[ACCESS] Superuser permissions granted across all sectors.');
      } else if (cmd.toLowerCase() == 'matrix') {
        _logs.add('[MATRIX] Wake up, Neo... The Matrix has you.');
        for (int i = 0; i < 5; i++) {
          _logs.add('01010011 01010101 01000011 01000011 01000101 01010011');
        }
      } else if (cmd.toLowerCase() == 'clear') {
        _logs.clear();
      } else if (cmd.isNotEmpty) {
        _logs.add('Executing "$cmd"... [OK] Target packet routed.');
      }
    });
    _inputController.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    _streamTimer?.cancel();
    _scrollController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CYBER_TERMINAL // v4.0',
            style: TextStyle(color: Colors.greenAccent, fontSize: 16)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(_isStreaming ? Icons.pause : Icons.play_arrow,
                color: Colors.greenAccent),
            onPressed: () => setState(() => _isStreaming = !_isStreaming),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      _logs[index],
                      style: TextStyle(
                        color: _logs[index].contains('ACCESS') ||
                                _logs[index].contains('[OK]')
                            ? Colors.greenAccent
                            : Colors.green.shade700,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey.shade900,
            child: Row(
              children: [
                const Text('root@os:~# ',
                    style: TextStyle(color: Colors.greenAccent)),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    style: const TextStyle(
                        color: Colors.greenAccent, fontSize: 14),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type command (e.g. root, matrix)...',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onSubmitted: _handleCommand,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: () => _handleCommand(_inputController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== 2. RADAR SCREEN ====================
class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key});

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GLOBAL TARGET RADAR',
            style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RadarPainter(_controller.value),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Text('TARGET: PENTAGON_SERVER_04',
                style: TextStyle(color: Colors.cyanAccent, fontSize: 16)),
            const Text('STATUS: TRACING_LOCATION [LAT: 38.871, LON: -77.056]',
                style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class RadarPainter extends CustomPainter {
  final double animationValue;
  RadarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final paintCircle = Paint()
      ..color = Colors.cyanAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, radius * 0.3, paintCircle);
    canvas.drawCircle(center, radius * 0.6, paintCircle);
    canvas.drawCircle(center, radius, paintCircle);

    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paintCircle);
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paintCircle);

    final sweepPaint = Paint()
      ..shader = SweepGradient(
        center: Alignment.center,
        startAngle: 0,
        endAngle: pi * 2,
        colors: [
          Colors.cyan.withOpacity(0),
          Colors.cyanAccent.withOpacity(0.8)
        ],
        stops: const [0.5, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      (animationValue * 2 * pi) - (pi / 2),
      pi / 2,
      true,
      sweepPaint,
    );

    final targetPaint = Paint()..color = Colors.redAccent;
    canvas.drawCircle(Offset(center.dx + 40, center.dy - 60), 4, targetPaint);
    canvas.drawCircle(Offset(center.dx - 70, center.dy + 50), 4, targetPaint);
  }

  @override
  bool shouldRepaint(covariant RadarPainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// ==================== 3. TOOLS / EXPLOITS SCREEN ====================
class ProgressDialog extends StatefulWidget {
  final String title;
  const ProgressDialog({super.key, required this.title});

  @override
  State<ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> {
  double _progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_progress >= 1.0) {
        timer.cancel();
      } else {
        setState(() {
          _progress += 0.02;
          if (_progress > 1.0) _progress = 1.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text(widget.title,
          style: const TextStyle(color: Colors.greenAccent)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey.shade800,
            valueColor:
                const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
          ),
          const SizedBox(height: 16),
          Text('${(_progress * 100).toInt()}% COMPLETED',
              style: const TextStyle(color: Colors.greenAccent)),
        ],
      ),
      actions: [
        if (_progress >= 1.0)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('DONE',
                style: TextStyle(color: Colors.greenAccent)),
          ),
      ],
    );
  }
}

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  void _showBiometricDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('BIOMETRIC SCAN',
            style: TextStyle(color: Colors.greenAccent)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fingerprint, size: 80, color: Colors.greenAccent),
            SizedBox(height: 16),
            Text('Scanning thumbprint signature...',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('ACCESS GRANTED',
                style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE',
                style: TextStyle(color: Colors.greenAccent)),
          ),
        ],
      ),
    );
  }

  void _showProgressDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(title: title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CYBER EXPLOIT TOOLS',
            style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildToolCard(
            context,
            title: 'Biometric Access Scanner',
            subtitle: 'Simulate fingerprint recognition for mainframe entry',
            icon: Icons.fingerprint,
            onTap: () => _showBiometricDialog(context),
          ),
          _buildToolCard(
            context,
            title: 'Decrypt Pentagon Database',
            subtitle: 'Bypass military encryption protocols',
            icon: Icons.security,
            onTap: () =>
                _showProgressDialog(context, 'Decrypting Pentagon Database...'),
          ),
          _buildToolCard(
            context,
            title: 'Bypass Firewall & Routing',
            subtitle: 'Inject spoofed headers and flood ports',
            icon: Icons.router,
            onTap: () => _showProgressDialog(context, 'Bypassing Firewall...'),
          ),
          _buildToolCard(
            context,
            title: 'Mainframe Crash Simulation',
            subtitle: 'Simulate kernel panic and server shutdown',
            icon: Icons.bolt,
            onTap: () =>
                _showProgressDialog(context, 'Purging Mainframe Memory...'),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      color: Colors.grey.shade900,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.greenAccent, size: 36),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.greenAccent, size: 16),
        onTap: onTap,
      ),
    );
  }
}
