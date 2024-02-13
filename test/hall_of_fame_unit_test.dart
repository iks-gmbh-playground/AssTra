import 'package:asstra/4.view.hall.of.fame/do.halloffame.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('sort HallOfFameEntries', () {
    List<HallOfFameEntry> result = HallOfFameEntry.sort(getHallOfFameData());
    expect(result.elementAt(0).name, 'John');
    expect(result.elementAt(1).name, 'Tom');
    expect(result.elementAt(7).name, 'Lilo');
    expect(result.elementAt(8).name, 'Rob');
  });

  test('find position for new HallOfFameEntry', () {
    int result = HallOfFameEntry.findIndex(getHallOfFameData(), 10, 100);
    expect(result, 2);
  });
}

List<HallOfFameEntry> getHallOfFameData() {
  List<HallOfFameEntry> toReturn = List.empty(growable: true);
  toReturn.add(HallOfFameEntry(1, 'Rob', 't1', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(3, 'Tim', 't2', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(4, 'Reik', 't3', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(2, 'Lilo', 't4', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(6, 'Lulu', 't5', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(7, 'Beth', 't6', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(18, 'John', 't7', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(9, 'Lona', 't8', 1, 'Forwards'));
  toReturn.add(HallOfFameEntry(12, 'Tom', 't9', 1, 'Forwards'));

  return toReturn;
}




