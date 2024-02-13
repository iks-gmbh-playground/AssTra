import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {

  test('listToString', () {
    List<String> list = List.empty(growable: true);
    list.add("A");
    list.add("B");
    String result = AssTraStringUtil.listToString(list, "__");
    expect(result, "A__B");
  });

  test('stringToList', () {
    String stringAsList = "A__B__C";
    List<String> result = AssTraStringUtil.stringToList(stringAsList, "__");
    expect(result.elementAt(0), "A");
    expect(result.elementAt(1), "B");
    expect(result.elementAt(2), "C");
    expect(result.length, 3);
  });

  test('mapOfPropertiesToString', () {
    Map<String,String> map = {};
    map.addEntries({'key1':'value1'}.entries);
    map.addEntries({'key2':'value2'}.entries);
    String result = AssTraStringUtil.mapOfPropertiesToString(map, "-", "|");
    expect(result, "key1-value1|key2-value2");
  });

  test('stringToMapOfProperties', () {
    String mapAsString = "key1--value1||key2--value2";
    Map<String,String> result = AssTraStringUtil.stringToMapOfProperties(mapAsString, "--", "||");
    expect(result['key1'], "value1");
    expect(result['key2'], "value2");
    expect(result.length, 2);
  });

  test('mapWithStringListToString', () {
    Map<String,List<String>> map = {};
    List<String> list1 = {'a','b'}.toList();
    map.addEntries({'key1':list1}.entries);
    List<String> list2 = {'1','2','3'}.toList();
    map.addEntries({'key2':list2}.entries);
    String result = AssTraStringUtil.mapWithStringListToString(map, "-", "#", ',');
    expect(result, "key1-a,b#key2-1,2,3");
  });

  test('stringToMapWithStringList', () {
    String mapAsString = "key1--v1,v2,v3||key2--v4,v5";
    Map<String,List<String>> result = AssTraStringUtil.stringToMapWithStringList(mapAsString, "--", "||", ",");
    expect(result['key1']?.elementAt(2), "v3");
    expect(result['key1']?.length, 3);
    expect(result['key2']?.elementAt(0), "v4");
    expect(result['key2']?.length, 2);
    expect(result.length, 2);
  });

  test('Nothing to format', () {
    const text = 'xy';
    List<InlineSpan> result = AssTraStringUtil.toMarkdownLineSpans(text, 12);
    expect(result.length, 1);
  });

  test('One bold part to format', () {
    const text = 'xy *bold* bla';
    List<InlineSpan> result = AssTraStringUtil.toMarkdownLineSpans(text, 12);
    expect(result.length, 3);
  });

  test('One bold part to format without end tag', () {
    const text = 'xy *bold bla';
    List<InlineSpan> result = AssTraStringUtil.toMarkdownLineSpans(text, 12);
    expect(result.length, 2);
  });

  test('Three bold part to format', () {
    const text = 'start *bold1* bla *bold2* bla *bold3* end';
    List<InlineSpan> result = AssTraStringUtil.toMarkdownLineSpans(text, 12);
    expect(result.length, 7);
  });


  test('format millis to duration string', () {
    expect(AssTraStringUtil.millisToDurationString(123), '123 millis');
    expect(AssTraStringUtil.millisToDurationString(1230), '1,230 secs');
    expect(AssTraStringUtil.millisToDurationString(65432), '1 min, 5.4 secs');
    expect(AssTraStringUtil.millisToDurationString(9876542),
        '2 h, 44 min, 36 secs');
  });
}
