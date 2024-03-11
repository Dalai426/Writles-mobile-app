import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:writless/components/entity/RetValAudio.dart';

import 'levels.dart';
import 'dart:io';
import 'package:logger/logger.dart';

class Level_four extends Levels {
  List<List<File?>>? wavs;
  var logger = Logger();
  Level_four();

  void init(String text, int level, {String? title}) async {
    List<List<String>> strings = spilitSetences(text.trim());
    count_text = strings.length;

    String NUM_API = dotenv.get("NLP_NUM_API", fallback: "");

    String dir = (await getApplicationDocumentsDirectory()).path + "/wavs";

    if (!await Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }


    wavs = await Future.wait(strings.asMap().entries.map((sub_list) async {
      int index = sub_list.key;
      return Future.wait(sub_list.value.asMap().entries.map((el) async {
        String word = el.value;
        final Map<String, String> queryParams = {
          'voice': '3',
          'text': '${word}',
        };

        var uri = await Uri.http(NUM_API, 'nlp-web-demo/tts', queryParams);
        http.Response response = await http.get(uri);
        if (response.statusCode == 200) {
          File file = File('${dir}/${index}_${el.key}_wav.wav');
          file.writeAsBytes(response.bodyBytes);
          return file;
        } else {
          return null;
        }
      }).toList());
    }).toList());
  }

  Future<RetValAudio?> nextWav(BuildContext context, Function function) async {
    if (wavs != null && wavs!.length <= 0) {
      return null;
    }
    List<File?>? list_per_reading;

    cancelDelay();

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        list_per_reading = wavs!.elementAt(count_text - 1);
      } else {
        list_per_reading = wavs!.elementAt(reading_wav_index);
        reading_wav_index++;
      }

      AudioPlayer p1 = new AudioPlayer();

      int length = list_per_reading.length;

      int i = 1;
      int count = 0;

      StreamSubscription streamSubscription =
      p1.onPlayerComplete.listen((event) async {
        logger.t(length.toString() + " and " + i.toString());

        int second = 1000;
        if (i == length) {
          second = level==4?7000:5000;
        }
        if (i < length) {
          delayTimer = Timer(Duration(milliseconds: second), () {
            if (p1.state != PlayerState.disposed) {
              p1.play(DeviceFileSource(list_per_reading!.elementAt(i)!.path));
              i++;
            }
          });
        } else {
          if (count < 2) {
            i=1;
            count++;
            delayTimer=Timer(Duration(milliseconds: level==4?7000:5000),()
            {
              if (p1.state != PlayerState.disposed) {
                p1.play(DeviceFileSource(list_per_reading!.elementAt(0)!.path));
              }
            });

          } else {
            delayTimer = Timer(Duration(milliseconds: level==4?12000:10000), () {
              function();
            });
          }
        }
      });

      if (0 < length) {
        delayTimer = Timer(Duration(milliseconds: 1000), () {
          if (p1.state != PlayerState.disposed) {
            p1.play(DeviceFileSource(list_per_reading!.elementAt(0)!.path));
          }
        });

        return RetValAudio(palyer: p1, streamSubscription: streamSubscription);
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

      return null;
    }
    return null;
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
      if (words.length % 3 != 0) {
        int rem=words.length%3;
        if(rem==1){
          List<String> first = [];
          i = 1;
          words[0]=words[0].replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
          first.add(words[0]);
          list.add(first);
        }else{
          if (RegExp(r'[",|()-]').hasMatch(words[0])) {
            List<String> first = [];
            words[0]=words[0].replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
            words[1]=words[1].replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
            first.add(words[0]);
            first.add(words[1]);
            list.add(first);
          } else {
            String strin=words[0];
            strin+=" ";
            strin+=words[1];
            List<String> first = [];
            first.add(strin);
            list.add(first);
          }
          i=2;
        }
      }
      // Би бор морь, унав
      // Би бор морь , унав


      String str = "";
      int count_per_wav = 0;
      for (i; i < words.length; i++) {
        if (count_per_wav <= 2) {

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
                str=str.replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
                per_wavs.add(str);
              } else {
                stop[j]=stop[j].replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
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
          str=str.replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
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
                str=str.replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
                per_wavs.add(str);
              } else {
                stop[j]=stop[j].replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
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
        str=str.replaceAll(RegExp(r'[^\p{L}\p{N}\s]+', unicode: true), '');
        per_wavs.add(str);
        list.add(List.from(per_wavs));
        per_wavs.clear();
      }
    });

    logger.t(list);
    return list;
  }
}
