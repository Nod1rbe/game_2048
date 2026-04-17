import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:game_2048/ui/widgets/home_panel.dart';
import 'package:game_2048/ui/screens/nickname_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game/suika_game.dart';
import 'ui/game_ui.dart';
import 'ui/widgets/common_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://xsyssfinviqkuygrkscn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhzeXNzZmludmlxa3V5Z3Jrc2NuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ0NDc5ODcsImV4cCI6MjA5MDAyMzk4N30.Wo9PPh5Ti19k1wHGyaBe723lbadFdUb3QM77o-75T5I',
  );

  runApp(const GameApp());
}

class GameApp extends StatefulWidget {
  const GameApp({super.key});

  @override
  State<GameApp> createState() => _GameAppState();
}

class _GameAppState extends State<GameApp> {
  late final SuikaGame _game;
  String? _nickname;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _game = SuikaGame();
    _checkNickname();
  }

  Future<void> _checkNickname() async {
    final prefs = await SharedPreferences.getInstance();
    await _game.loadPrefs(); // Load data into game instance early!
    setState(() {
      _nickname = prefs.getString('nickname');
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const MaterialApp(home: Scaffold(body: Center(child: CircularProgressIndicator())));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _nickname == null ? NicknameScreen(game: _game) : HomePanel(game: _game),
      routes: {
        '/nickname': (context) => NicknameScreen(game: _game),
        '/home': (context) => HomePanel(game: _game),
        '/game': (context) => _GameView(game: _game),
      },
    );
  }
}

class _GameView extends StatelessWidget {
  final SuikaGame game;
  const _GameView({required this.game});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const GradientBackground(),
          GameWidget<SuikaGame>(
            game: game,
            overlayBuilderMap: {'ui': (context, g) => GameUI(game: g)},
            initialActiveOverlays: const ['ui'],
          ),
        ],
      ),
    );
  }
}
