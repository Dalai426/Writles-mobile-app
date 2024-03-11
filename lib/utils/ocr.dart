import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';

Future<String?> ocrText(File file, context) async {
  print(file.path);

  String flaskApiKeyValue = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
  String url = dotenv.get("API_FLASK", fallback: "");

  Map<String, String> header = {
    "X-API-KEY": flaskApiKeyValue,
    "Content-Type": "multipart/form-data"
  };

  var uri = Uri.http(url, 'ocr');

  var request = http.MultipartRequest('POST', uri)
    ..headers.addAll(header)
    ..files.add(await http.MultipartFile.fromPath('img', file.path));
  try {
    var res = await request.send();
    http.Response response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      Map<String, dynamic> responseBodyJson = json.decode(response.body);
      CherryToast.error(
        title: Text(
          responseBodyJson['msg'],
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);
    }
  } catch (e) {
    CherryToast.error(
      title: Text(
        e.toString(),
        style: Theme.of(context)
            .textTheme
            .labelSmall!
            .copyWith(color: Theme.of(context).colorScheme.surface),
      ),
    ).show(context);
  }

  return null;
}
