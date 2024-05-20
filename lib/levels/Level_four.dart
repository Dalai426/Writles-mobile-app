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

class LevelFour extends Levels {
  List<List<String>> wavs = [];
  var logger = Logger();

  LevelFour();

  void init(String text, int level, {String? title}) async {
    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");

    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }
    final Map<String, String> queryParams = {
      'level': '4',
      'text': text,
      'voice': 'female3'
    };

    if (title != null && title.isNotEmpty) {
      print("dadsandbsahdbja,");
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
    List<String> list_per_reading;
    StreamSubscription? streamSubscription;

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        list_per_reading = wavs.elementAt(count_text - 1);
      } else {
        list_per_reading = wavs.elementAt(reading_wav_index);
        reading_wav_index++;
      }

      int length = list_per_reading.length;
      int i = hasTitle == true && reading_wav_index == 1 ? -1 : 0;
      int count = 0;
      bool bell = false;

      streamSubscription = p1.onPlayerComplete.listen((event) {
        i++;
        int second = 1000;
        if (i == length) {
          second = level == 4 ? 8000 : 5000;
        }
        if (i < length) {
          delayTimer = Timer(Duration(milliseconds: second), () {
            p1.play(DeviceFileSource(list_per_reading.elementAt(i)));
          });
        } else {
          if (count < 2) {
            i = 0;
            count++;
            delayTimer =
                Timer(Duration(milliseconds: level == 4 ? 8000 : 5000), () {
              p1.play(DeviceFileSource(list_per_reading.elementAt(0)));
            });
          } else {
            if (bell == false) {
              bell = true;
              delayTimer = Timer(
                  Duration(milliseconds: level == 4 ? 7000 : 6000), () async {
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
        await p1.play(DeviceFileSource(list_per_reading.elementAt(0)));
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

  // List<List<String>> spilitSetences(String string) {
  //   List<List<String>> list = [];
  //
  //   List<String> sentences = string
  //       .split(RegExp(r'[.!?]'))
  //       .where((part) => part.isNotEmpty)
  //       .toList();
  //
  //   sentences.forEach((sentence){
  //
  //     sentence = sentence.replaceAll(RegExp('\\s+,'), ",");
  //     sentence = sentence.replaceAllMapped(RegExp(r',(\S)'), (match) {
  //       return ', ${match.group(1)}';
  //     });
  //
  //     sentence = sentence.replaceAll(RegExp('\\s+"'), '"');
  //     sentence = sentence.replaceAllMapped(RegExp(r'"(\S)'), (match) {
  //       return '" ${match.group(1)}';
  //     });
  //
  //     List<String> words = sentence.trim().split(RegExp(r'\s+'));
  //     List<String> per_wavs = [];
  //
  //     int i = 0;
  //     if (words.length % 3 != 0) {
  //       int rem=words.length%3;
  //       if(rem==1){
  //         List<String> first = [];
  //         i = 1;
  //         first.add(words[0]);
  //         list.add(first);
  //       }else{
  //         if (RegExp(r'[",|()-]').hasMatch(words[0])) {
  //           List<String> first = [];
  //           first.add(words[0]);
  //           first.add(words[1]);
  //           list.add(first);
  //         } else {
  //           String strin=words[0];
  //           strin+=" ";
  //           strin+=words[1];
  //           List<String> first = [];
  //           first.add(strin);
  //           list.add(first);
  //         }
  //         i=2;
  //       }
  //     }
  //     // Би бор морь, унав
  //     // Би бор морь , унав
  //
  //
  //     String str = "";
  //     int count_per_wav = 0;
  //     for (i; i < words.length; i++) {
  //       if (count_per_wav <= 2) {
  //         if (RegExp(r'[",|()-]').hasMatch(words[i])) {
  //           List<String> stop = words[i]
  //               .split(RegExp(r'[,|"()]'))
  //               .where((part) => part.isNotEmpty)
  //               .toList();
  //           for (int j = 0; j < stop.length; j++) {
  //             if (j == 0) {
  //               if (str.isNotEmpty) {
  //                 str += " ";
  //               }
  //               str += stop[j];
  //               per_wavs.add(str);
  //             } else {
  //               per_wavs.add(stop[j]);
  //             }
  //             str = "";
  //           }
  //         } else {
  //           if (str.isNotEmpty) {
  //             str += " ";
  //           }
  //           str += words[i];
  //         }
  //
  //         count_per_wav += 1;
  //       } else {
  //         per_wavs.add(str);
  //         list.add(List.from(per_wavs));
  //         per_wavs.clear();
  //         str = "";
  //         if (RegExp(r'[",|()-]').hasMatch(words[i])) {
  //
  //
  //           List<String> stop = words[i]
  //               .split(RegExp(r'[,|"()]'))
  //               .where((part) => part.isNotEmpty)
  //               .toList();
  //
  //           for (int j = 0; j < stop.length; j++) {
  //             if (j == 0) {
  //               if (str.isNotEmpty) {
  //                 str += " ";
  //               }
  //               str += stop[j];
  //               per_wavs.add(str);
  //             } else {
  //               per_wavs.add(stop[j]);
  //             }
  //             str = "";
  //           }
  //         } else {
  //           str = words[i];
  //         }
  //
  //         count_per_wav = 0;
  //       }
  //     }
  //
  //     if (str.isNotEmpty) {
  //       per_wavs.add(str);
  //       list.add(List.from(per_wavs));
  //       per_wavs.clear();
  //     }
  //   });
  //
  //   logger.t(list);
  //   return list;
  // }
}
