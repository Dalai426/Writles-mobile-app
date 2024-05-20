import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'levels.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class LevelThree extends Levels {
  List<List<String>> wavs = [];
  var logger = Logger();

  LevelThree();

  void init(String text, int level, {String? title}) async {
    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");

    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }
    final Map<String, String> queryParams = {
      'level': '3',
      'text': text,
      'voice': 'female3'
    };

    if (title != null && title.isNotEmpty) {
      hasTitle = true;
      queryParams["title"] = title;
    }

    var uri = Uri.http(apiflask, 'tts/extract-full', queryParams);
    final client = http.Client();

    try {
      var request = http.Request('GET', uri);
      final response = await client.send(request);

      int vyeKey = 0;
      List<String> word = [];
      List<int> audio = [];

      await for (var chunk in response.stream) {
        int len = chunk.length;

        if (len == 1) {
          wavs.add(List.of(word));
          word.clear();
        } else if (len == 3) {
          File file = File('$dir/${vyeKey}_wav.wav');
          await file.writeAsBytes(audio);
          word.add(file.path);
          vyeKey++;
          audio.clear();
        } else {
          audio.addAll(List.of(chunk));
        }
      }
    } finally {
      client.close();
    }
    count_text = wavs.length;
  }

  Future<StreamSubscription?> nextWav(
      BuildContext context, Function function) async {
    List<String?>? listPerReading;
    StreamSubscription? streamSubscription;

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        listPerReading = wavs.elementAt(count_text - 1);
      } else {
        listPerReading = wavs.elementAt(reading_wav_index);
        reading_wav_index++;
      }

      int length = listPerReading.length;
      int i = hasTitle == true && reading_wav_index == 1 ? -1 : 0;
      int count = 0;
      bool bell = false;

      streamSubscription = p1.onPlayerComplete.listen((event) async {
        i++;
        int second = 1000;
        if (i == length) {
          second = 5000;
        }
        if (i < length) {
          delayTimer = Timer(Duration(milliseconds: second), () async {
            await p1.play(DeviceFileSource(listPerReading!.elementAt(i)!));
          });
        } else {
          if (count < 2) {
            i = 0;
            count++;
            delayTimer = Timer(const Duration(milliseconds: 5000), () async {
              await p1.play(DeviceFileSource(listPerReading!.elementAt(0)!));
            });
          } else {
            if (bell == false) {
              bell = true;
              delayTimer = Timer(const Duration(milliseconds: 6000), () async {
                await p1.play(AssetSource("audios/bell.wav"));
              });
            } else {
              delayTimer = Timer(const Duration(milliseconds: 2000), () async {
                await function();
              });
            }
          }
        }
      });

      if (hasTitle == true && reading_wav_index == 1) {
        await p1.play(AssetSource("audios/garchig.wav"));
      } else {
        await p1.play(DeviceFileSource(listPerReading.elementAt(0)!));
      }
      return streamSubscription;
    } catch (e) {
      CherryToast.warning(
        title: Text(
          "Өөө, Алдаа гарлаа !!",
          style: Theme.of(context)
              .textTheme
              .labelSmall!
              .copyWith(color: Theme.of(context).colorScheme.surface),
        ),
      ).show(context);

      return streamSubscription;
    }
  }

  void prevWav() async {
    cancelDelay();
    if (reading_wav_index <= 1) {
      reading_wav_index = 0;
    } else {
      reading_wav_index--;
    }
  }
}
