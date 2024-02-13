import 'package:asstra/common/utils/asstra.util.string.dart';

import 'asstra.constants.dart';

abstract class PersistentProperties {

  final Map<String, String> properties = {};

  @override
  String toString() {
    return AssTraStringUtil.mapOfPropertiesToString(properties, keyValueSeparator, propertySeparator);
  }

  void addProperty(String key, String value) {
    properties.addEntries({key:value}.entries);
  }

  int getIntValue(String propName, int defaultValue) {
    String? toReturn = properties[propName];
    if (toReturn == null) {
      properties.addEntries({propName:defaultValue.toString()}.entries);
      toReturn = properties[propName];
    }
    return int.parse(toReturn!);
  }

  String getStringValue(String propName, String defaultValue) {
    String? toReturn = properties[propName];
    if (toReturn == null) {
      properties.addEntries({propName:defaultValue}.entries);
      toReturn = properties[propName];
    }
    return toReturn!;
  }

  void addFromStringToMap(String inputString, String separator, Map<String,String> map) {
    if (separator == "=") throw Exception("Illegal Argument: $separator");
    var keyValueList = AssTraStringUtil.stringToList(inputString, separator);
    keyValueList.map((str) => str.split("="))
        .forEach((splitResult) => map.addEntries({splitResult.elementAt(0):splitResult.elementAt(1)}.entries));
  }

}