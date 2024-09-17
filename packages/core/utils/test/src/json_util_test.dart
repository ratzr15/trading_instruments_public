import 'package:flutter_test/flutter_test.dart';
import 'package:utils/utils.dart';

void main() {
  test("toJson", () {
    // Arrange
    const json = '{"key1":"value1","key2":"value2"}';
    final map = {
      "key1": "value1",
      "key2": "value2",
    };

    // Act
    final result = JsonUtil.toJson(map);

    // Assert
    expect(result, json);
  });

  test("fromJson", () {
    // Arrange
    const json = '{"key1":"value1","key2":"value2"}';
    final map = {
      "key1": "value1",
      "key2": "value2",
    };

    // Act
    final result = JsonUtil.fromJson(json);

    // Assert
    expect(result, map);
  });

  test("toDecodedMap", () {
    // Arrange
    final dynamic map = {
      "key1": "value1",
      "key2": 2,
      "key3": false,
    };

    // Act
    final result = JsonUtil.toDecodedMap(map);

    // Assert
    expect(result, map);
    expect(result, isA<Map<String, dynamic>>());
  });
}
