import '../game/suika_game.dart';

class GameTexts {
  static const Map<String, Map<String, String>> t = {
    'uz': {
      'SUIKA': 'FRUITMERGE',
      'MEVALARNI BIRLASHTIRING': 'MEVALARNI BIRLASHTIRING',
      'PAUZA': 'PAUZA',
      'O\'yin to\'xtatildi': 'O\'yin to\'xtatildi',
      'Joriy ball: ': 'Joriy ball: ',
      'O\'YIN TUGADI': 'O\'YIN TUGADI',
      'BALL': 'BALL',
      'REKORD': 'REKORD',
      'QAYTA O\'YNASH': 'QAYTA O\'YNASH',
      'Ajoyib!': 'Ajoyib!',
      'Combo x3!': 'Combo x3!',
      'Dahshat!': 'Dahshat!',
    },
    'ru': {
      'SUIKA': 'FRUITMERGE',
      'MEVALARNI BIRLASHTIRING': 'СОЕДИНЯЙТЕ ФРУКТЫ',
      'PAUZA': 'ПАУЗА',
      'O\'yin to\'xtatildi': 'Игра приостановлена',
      'Joriy ball: ': 'Текущий счет: ',
      'O\'YIN TUGADI': 'ИГРА ОКОНЧЕНА',
      'BALL': 'СЧЕТ',
      'REKORD': 'РЕКОРД',
      'QAYTA O\'YNASH': 'ИГРАТЬ СНОВА',
      'Ajoyib!': 'Отлично!',
      'Combo x3!': 'Комбо x3!',
      'Dahshat!': 'Невероятно!',
    },
    'en': {
      'SUIKA': 'FRUITMERGE',
      'MEVALARNI BIRLASHTIRING': 'MERGE THE FRUITS',
      'PAUZA': 'PAUSED',
      'O\'yin to\'xtatildi': 'Game Paused',
      'Joriy ball: ': 'Current Score: ',
      'O\'YIN TUGADI': 'GAME OVER',
      'BALL': 'SCORE',
      'REKORD': 'BEST',
      'QAYTA O\'YNASH': 'PLAY AGAIN',
      'Ajoyib!': 'Great!',
      'Combo x3!': 'Combo x3!',
      'Dahshat!': 'Awesome!',
    }
  };

  static String get(String key) {
    return t[SuikaGame.langNotifier.value]?[key] ?? key;
  }
}
