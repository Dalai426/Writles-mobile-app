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
  List<List<File?>>? wavs;
  var logger = Logger();

  LevelThree();

  void init(String text, int level, {String? title}) async {
    List<List<String>> strings = spilitSetences(text.trim());
    count_text = strings.length;

    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
    final Map<String, String> header = {"X-API-KEY": flaskapikey};

    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }


    wavs = await Future.wait(strings.asMap().entries.map((subList) async {
      int index = subList.key;
      return Future.wait(subList.value.asMap().entries.map((el) async {
        String word = el.value;
        final Map<String, String> queryParams = {
          'voice': 'female3',
          'text': word,
        };

        var uri = Uri.http(apiflask, 'tts/extract', queryParams);
        http.Response response = await http.get(uri, headers: header);
        if (response.statusCode == 200) {
          File file = File('$dir/${index}_${el.key}_wav.wav');
          file.writeAsBytes(response.bodyBytes);
          return file;
        } else {
          return null;
        }
      }).toList());
    }).toList());


  }

  Future<StreamSubscription?> nextWav(BuildContext context, Function function) async {

    List<File?>? listPerReading;
    StreamSubscription? streamSubscription;

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        listPerReading = wavs!.elementAt(count_text - 1);
      } else {
        listPerReading = wavs!.elementAt(reading_wav_index);
        reading_wav_index++;
      }


      int length = listPerReading.length;
      int i = 1;
      int count = 0;

      streamSubscription = p1.onPlayerComplete.listen((event) async {
        int second = 1000;
        if (i == length) {
          second = 4000;
        }
        if (i < length) {
          delayTimer = Timer(Duration(milliseconds: second), () async {
              await p1.play(DeviceFileSource(listPerReading!.elementAt(i)!.path));
              i++;
          });
        } else {
          if (count < 2) {
            i=1;
            count++;
            delayTimer=Timer(const Duration(milliseconds: 4000),() async {
                await p1.play(DeviceFileSource(listPerReading!.elementAt(0)!.path));
            });

          } else {
            delayTimer = Timer(const Duration(milliseconds: 6000), () async {
              await function();
            });
          }
        }
      });

      if (0 < length) {

        await p1.play(DeviceFileSource(listPerReading!.elementAt(0)!.path));

        return streamSubscription;
      }
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
    return streamSubscription;
  }

  void prevWav() async {
    cancelDelay();
    if (reading_wav_index <= 1) {
      reading_wav_index = 0;
    } else {
      reading_wav_index--;
    }
  }

  List<List<String>> spilitSetences(String string) {
    List<List<String>> list = [];

    List<String> sentences = string
        .split(RegExp(r'[.!?]'))
        .where((part) => part.isNotEmpty)
        .toList();

    sentences.forEach((sentence) {

      sentence = sentence.replaceAll(RegExp('\\s+,'), ",");
      sentence = sentence.replaceAllMapped(RegExp(r',(\S)'), (match) {
        return ', ${match.group(1)}';
      });

      sentence = sentence.replaceAll(RegExp('\\s+"'), '"');
      sentence = sentence.replaceAllMapped(RegExp(r'"(\S)'), (match) {
        return '" ${match.group(1)}';
      });

      List<String> words = sentence.trim().split(RegExp(r'\s+'));
      List<String> per_wavs = [];


      int i = 0;
      if (words.length % 2 != 0) {
        List<String> first = [];
        i = 1;
        first.add(words[0]);
        list.add(first);
      }
      // Би бор морь, унав
      // Би бор морь , унав

      String str = "";
      int count_per_wav = 0;
      for (i; i < words.length; i++) {
        if (count_per_wav <= 1) {

          if (RegExp(r'[",|()-]').hasMatch(words[i])) {
            List<String> stop = words[i]
                .split(RegExp(r'[,|"()]'))
                .where((part) => part.isNotEmpty)
                .toList();
            for (int j = 0; j < stop.length; j++) {
              if (j == 0) {
                if (str.isNotEmpty) {
                  str += " ";
                }
                str += stop[j];
                per_wavs.add(str);
              } else {
                per_wavs.add(stop[j]);
              }
              str = "";
            }
          } else {
            if (str.isNotEmpty) {
              str += " ";
            }
            str += words[i];
          }

          count_per_wav += 1;
        } else {
          per_wavs.add(str);
          list.add(List.from(per_wavs));
          per_wavs.clear();
          str = "";
          if (RegExp(r'[",|()-]').hasMatch(words[i])) {


            List<String> stop = words[i]
                .split(RegExp(r'[,|"()]'))
                .where((part) => part.isNotEmpty)
                .toList();

            for (int j = 0; j < stop.length; j++) {
              if (j == 0) {
                if (str.isNotEmpty) {
                  str += " ";
                }
                str += stop[j];
                per_wavs.add(str);
              } else {
                per_wavs.add(stop[j]);
              }
              str = "";
            }
          } else {
            str = words[i];
          }

          count_per_wav = 0;
        }
      }

      if (str.isNotEmpty) {
        per_wavs.add(str);
        list.add(List.from(per_wavs));
        per_wavs.clear();
      }
    });

    logger.t(list);
    return list;
  }
}
