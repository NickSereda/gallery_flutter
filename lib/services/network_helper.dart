import 'dart:convert';

import 'package:http/http.dart' as http;

class NetworkHelper {

  NetworkHelper({required this.url});

  final String url;

  Future getData() async {

    http.Response responce;

    responce = await http.get(Uri.parse(url));

    //if success
    if (responce.statusCode == 200) {

      String data = responce.body;
      print(data);

      return jsonDecode(data);
    } else {
      print(responce.statusCode);
      return;
    }
  }
}