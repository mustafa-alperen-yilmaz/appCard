import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:answer_on_card/Datas/datas.dart';

List<Datas> datasParse(String bodyResponse) {
  var list = json.decode(bodyResponse) as List<dynamic>;
  List<Datas> datas = list.map((dts) => Datas.fromJson(dts)).toList();
  return datas;
}

// fetching the data
Future<List<Datas>> datasFetch() async {
  final fetchResponse = await http.get(Uri.parse(
      "https://github.com/mustafa-alperen-yilmaz/appCard/blob/master/assets/data.json"));
  if (fetchResponse.statusCode == 200) {
    return compute(datasParse, fetchResponse.body);
  } else {
    throw Exception();
  }
}
