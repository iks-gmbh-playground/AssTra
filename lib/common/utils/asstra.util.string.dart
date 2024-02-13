import 'package:asstra/common/asstra.constants.dart';
import 'package:flutter/material.dart';

class AssTraStringUtil {

  static void abcSort(List<String> stringList) {
    stringList.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }

  static Text markdownStringToText(String text) {
    List<dynamic> textSpans = toMarkdownLineSpans(text, 14);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }

  static Text markdownStringToSizedText16(String text) {
    List<dynamic> textSpans = toMarkdownLineSpans(text, 16);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }

  static Text markdownStringToSizedText18(String text) {
    List<dynamic> textSpans = toMarkdownLineSpans(text, 18);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }

  static Text markdownStringToSizedText20(String text) {
    List<dynamic> textSpans = toMarkdownLineSpans(text, 20);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }

  static Text markdownStringToSizedText22(String text) {
    List<dynamic> textSpans = toMarkdownLineSpans(text, 22);
    return Text.rich(
      TextSpan(
        children: <TextSpan>[...textSpans],
      ),
    );
  }


  static List<InlineSpan> toMarkdownLineSpans(String text, double fontSize) {
    final List<InlineSpan> textSpans = List.empty(growable: true);
    var boldStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize);
    var normalStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize);

    while(text.contains("*")) {
      var pos = text.indexOf('*');
      final firstPart = text.substring(0, pos);
      var secondPart = text.substring(pos+1);
      var thirdPart = '';
      pos = secondPart.indexOf('*');
      if (pos == -1) {
        text = '';
      } else {
        thirdPart = secondPart.substring(pos+1);
        secondPart = secondPart.substring(0, pos);
      }

      if (firstPart.isNotEmpty) {
        textSpans.add(TextSpan(text: firstPart, style: normalStyle));
      }
      textSpans.add(TextSpan(text: secondPart, style: boldStyle));

      text = thirdPart;
    }

    if (text.isNotEmpty) {
      textSpans.add(TextSpan(text: text, style: normalStyle));
    }

    return textSpans;

  }


  static String millisToDurationString(int millis) {
    int millisPerHour = 1000 * 60 * 60;
    int hourCounter = 0;
    while (millis > millisPerHour) {
      hourCounter++;
      millis -= millisPerHour;
    }

    int minuteCounter = 0;
    int millisPerMinute =  1000 * 60;
    while (millis > millisPerMinute) {
      minuteCounter++;
      millis -= millisPerMinute;
    }

    int secondsCounter = 0;
    int millisPerSecond =  1000;
    while (millis > millisPerSecond) {
      secondsCounter++;
      millis -= millisPerSecond;
    }

    if (hourCounter == 0 && minuteCounter == 0 && secondsCounter == 0) {
      return '$millis millis';
    } else if (hourCounter == 0 && minuteCounter == 0) {
      return '$secondsCounter,$millis secs';
    } else if (hourCounter == 0) {
      return '$minuteCounter min, $secondsCounter.${millis.toString().characters.first} secs';
    } else {
      return '$hourCounter h, $minuteCounter min, $secondsCounter secs';
    }

  }

  static String durationToString(Duration duration) {
    String seconds = duration.inSeconds.remainder(60).toString();
    if (seconds.length == 1) seconds = '0$seconds';
    return '${duration.inMinutes}:$seconds';
  }

  static String createTimestampAsString() {
    var now = DateTime.now();
    var month = now.month.toString().padLeft(2, '0');
    var day = now.day.toString().padLeft(2, '0');
    return'$day-$month-${now.year} ${now.hour}:${now.minute}';
  }


  static String mapOfPropertiesToString(Map<String,String> map, String innerPropSeparator, String outerPropSeparator) {
    if (innerPropSeparator == outerPropSeparator) throw Exception("Illegal Arguments: separators must differ");
    String toReturn = "";
    map.forEach((key, value) {
      toReturn += key + innerPropSeparator + value + outerPropSeparator;
    });
    return toReturn.substring(0, toReturn.length-outerPropSeparator.length);
  }

  static Map<String,String> stringToMapOfProperties(String mapAsString, String innerPropSeparator, String outerPropSeparator) {
    if (innerPropSeparator == outerPropSeparator) throw Exception("Illegal Arguments: separators must differ");
    Map<String,String> toReturn = {};
    var outerSplitResult = mapAsString.split(outerPropSeparator);
    for (var keyValuePair in outerSplitResult) {
      var innerSplitResult = keyValuePair.split(innerPropSeparator);
      String key = innerSplitResult.elementAt(0);
      String value = innerSplitResult.elementAt(1);
      toReturn.addEntries({key:value}.entries);
    }
    return toReturn;
  }

  static List<String> stringToList(String s, String separator) {
    if (s.isEmpty) return List.empty();
    if (separator == '\n') {
      s = s.replaceAll("\r", "");
    }
    return s.split(separator);
  }

  static String listToString(List<String> list, String separator) {
    String toReturn = "";
    if (list.isEmpty) return toReturn;
    for (var element in list) {
      toReturn += element + separator;
    }
    return toReturn.substring(0, toReturn.length-separator.length);
  }


  static Map<String,List<String>> stringToMapWithStringList(String mapAsString, String innerPropSeparator, String outerPropSeparator, String listSeparator) {
    if (mapAsString.isEmpty) return {};
    if (innerPropSeparator == outerPropSeparator ||
    innerPropSeparator == listSeparator ||
    outerPropSeparator == listSeparator
    ) throw Exception("Illegal Arguments: separators must differ");

    Map<String,List<String>> toReturn = {};
    var outerSplitResult = mapAsString.split(outerPropSeparator);
    for (var keyValuePair in outerSplitResult) {
      var innerSplitResult = keyValuePair.split(innerPropSeparator);
      String key = innerSplitResult.elementAt(0);
      String listAsString = innerSplitResult.elementAt(1);
      List<String> value = stringToList(listAsString, listSeparator);
      toReturn.addEntries({key:value}.entries);
    }
    return toReturn;
  }

  static String mapWithStringListToString(Map<String,List<String>> map, String innerPropSeparator, String outerPropSeparator, String listSeparator) {
    if (innerPropSeparator == outerPropSeparator ||
        innerPropSeparator == listSeparator ||
        outerPropSeparator == listSeparator
    ) throw Exception("Illegal Arguments: separators must differ");

    String toReturn = "";
    map.forEach((key, listValue) {
      String value = listToString(listValue, listSeparator);
      toReturn += key + innerPropSeparator + value + outerPropSeparator;
    });

    if (toReturn.isEmpty) return toReturn;
    return toReturn.substring(0, toReturn.length-outerPropSeparator.length);
  }

}