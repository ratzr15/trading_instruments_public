import 'dart:convert';

class JsonUtil {
  static String toJson(dynamic map) => json.encode(map);

  static Map fromJson(String jsonString) => json.decode(jsonString);

  static List fromJsonList(String jsonString) => json.decode(jsonString);

  ///This method is used in testing in order to convert the testing data provided to Map<String,dynamic>
  ///to mimic how the data is parsed from the APIs
  static dynamic toDecodedMap(dynamic map) => json.decode(json.encode(map));
}
