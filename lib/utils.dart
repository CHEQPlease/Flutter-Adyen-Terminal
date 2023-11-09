

import 'dart:convert';

Map<String, dynamic> convertStringToHashMap(String jsonString) {
  try {
    Map<String, dynamic> resultMap = json.decode(jsonString);
    return resultMap;
  } catch (e) {
    // Return an empty map if conversion fails
    return {};
  }
}


