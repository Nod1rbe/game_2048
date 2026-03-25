import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  late AudioPool _dropSoundPool;
  late AudioPool _bloopPool;
  late AudioPool _merge1SoundPool;
  late AudioPool _merge3SoundPool;

  final Map<String, int> _lastPlayedTimes = {};

  Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      'click.wav',
      'new_drop.wav',
      'bloop.mp3',
      'merge1.mp3',
      'merge3.mp3',
    ]);

    _dropSoundPool = await FlameAudio.createPool('new_drop.wav', maxPlayers: 4);
    _bloopPool = await FlameAudio.createPool('bloop.mp3', maxPlayers: 4);
    _merge1SoundPool = await FlameAudio.createPool('merge1.mp3', maxPlayers: 2);
    _merge3SoundPool = await FlameAudio.createPool('merge3.mp3', maxPlayers: 2);
  }

  void playSound(String path, {double volume = 0.5}) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastPlayedTimes[path] ?? 0;
    if (now - lastTime > 60) {
      if (path == 'new_drop.wav') {
        _dropSoundPool.start(volume: volume);
      } else if (path == 'merge1.mp3') {
        _merge1SoundPool.start(volume: volume);
      } else if (path == 'merge3.mp3') {
        _merge3SoundPool.start(volume: volume);
      } else {
        FlameAudio.play(path, volume: volume);
      }
      _lastPlayedTimes[path] = now;
    }
  }

  void playContactSound() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final lastTime = _lastPlayedTimes['contact'] ?? 0;
    if (now - lastTime > 80) {
      _bloopPool.start(volume: 0.5);
      _lastPlayedTimes['contact'] = now;
    }
  }
}
