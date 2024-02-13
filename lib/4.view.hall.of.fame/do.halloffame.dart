import 'package:hive/hive.dart';

part 'do.halloffame.g.dart';

@HiveType(typeId: 1)
class HallOfFameEntry {
  @HiveField(0)
  final int numberOfOkQuestInSequence;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String timestamp;
  @HiveField(3)
  final int millisNeeded;
  @HiveField(4)
  final String direction;

  HallOfFameEntry(this.numberOfOkQuestInSequence, this.name, this.timestamp, this.millisNeeded, this.direction);

  static List<HallOfFameEntry> sort(List<HallOfFameEntry> list) {
    list.sort((a, b) => compare(a,b));
    return list.reversed.toList();
  }

  static int findIndex(List<HallOfFameEntry> hallOfFameData, int scoreValue, int millisNeeded) {
    hallOfFameData = HallOfFameEntry.sort(hallOfFameData);
    int i = 0;
    for(i=0; i<hallOfFameData.length; i++) {
      if (hallOfFameData.elementAt(i).numberOfOkQuestInSequence < scoreValue) {
        return i;
      }
      if (hallOfFameData.elementAt(i).numberOfOkQuestInSequence == scoreValue) {
        if (hallOfFameData.elementAt(i).millisNeeded > millisNeeded) {
          return i;
        }
      }
    }
    return i;
  }

  static compare(HallOfFameEntry a, HallOfFameEntry b) {
    if (a.numberOfOkQuestInSequence == b.numberOfOkQuestInSequence) {
      return b.millisNeeded.compareTo(a.millisNeeded);
    }
    return a.numberOfOkQuestInSequence.compareTo(b.numberOfOkQuestInSequence);
  }
}

