import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/status_provider.dart';
import 'providers/history_provider.dart';
import 'theme/aqua_theme.dart';
import 'screens/monitor_screen.dart';
import 'screens/activity_screen.dart';
import 'screens/config_screen.dart';
import 'widgets/aqua_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StatusProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const AquaFlowApp(),
    ),
  );
}

class AquaFlowApp extends StatelessWidget {
  const AquaFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AquaFlow',
      theme: AquaTheme.light,
      debugShowCheckedModeBanner: false,
      home: const AquaShell(),
    );
  }
}

class AquaShell extends StatefulWidget {
  const AquaShell({super.key});

  @override
  State<AquaShell> createState() => _AquaShellState();
}

class _AquaShellState extends State<AquaShell> {
  int _selectedIndex = 0;

  static final _screens = [
    const MonitorScreen(),
    const ActivityScreen(),
    const ConfigScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AquaNavBar(
        selectedIndex: _selectedIndex,
        onTabSelected: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
