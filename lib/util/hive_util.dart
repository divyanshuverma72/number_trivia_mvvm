import 'package:hive/hive.dart';

abstract class NumberTriviaHiveUtil {
  Future<String?> readFromHive();
  writeToHiveDb(String triviaToCache);
}

const cachedNumberTriviaBox = 'CACHED_NUMBER_TRIVIA_BOX';
const cachedNumberTriviaKey = 'CACHED_NUMBER_TRIVIA_KEY';

class NumberTriviaHiveUtilImpl extends NumberTriviaHiveUtil {

  @override
  Future<String?> readFromHive() async {
    Box box = await _openBox(cachedNumberTriviaBox);
    return box.get(cachedNumberTriviaKey);
  }

  @override
  writeToHiveDb(String triviaToCache) async {
    Box box = await _openBox(cachedNumberTriviaBox);
    box.put(cachedNumberTriviaKey, triviaToCache);
  }

  Future<Box> _openBox(String type) async {
    final box = await Hive.openBox(type);
    return box;
  }
}


