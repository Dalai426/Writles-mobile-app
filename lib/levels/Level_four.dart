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

  List<List<File?>> wavs=[];
  var logger = Logger();

  LevelFour();

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


    final wavs_future =strings.asMap().entries.map((sub_list) async {
      int index = sub_list.key;
      final future_lis=sub_list.value.asMap().entries.map((el) async {
        String word = el.value;
        final Map<String, String> queryParams = {
          'voice': 'female3',
          'text': word,
        };

        var uri = Uri.http(apiflask, '/tts/extract', queryParams);
        http.Response response = await http.get(uri, headers: header);
        if (response.statusCode == 200) {
          File file = File('${dir}/${index}_${el.key}_wav.wav');
          file.writeAsBytes(response.bodyBytes);
          return file;
        } else {
          return null;
        }
      }).toList();
      return Future.wait(future_lis);
    });

    wavs.addAll(await Future.wait(wavs_future));
  }


  Future<StreamSubscription?> nextWav(BuildContext context, Function function) async {

    List<File?>? list_per_reading;
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
      int i = 1;
      int count = 0;

      streamSubscription = p1.onPlayerComplete.listen((event){
        p1.stop();
        cancelDelay();
        logger.t("$length and $i");

        int second = 1000;
        if (i == length) {
          second = level==4?6000:4000;
        }
        if (i < length) {
          delayTimer = Timer(Duration(milliseconds: second), () {
              p1.play(DeviceFileSource(list_per_reading!.elementAt(i)!.path));
              i++;
          });
        } else {
          if (count < 2) {
            i=1;
            count++;
            delayTimer=Timer(Duration(milliseconds: level==4?6000:4000),()
            {
                p1.play(DeviceFileSource(list_per_reading!.elementAt(0)!.path));
            });
          }else{
            delayTimer = Timer(Duration(milliseconds: level==4?11000:9000), () {
              function();
            });
          }
        }
      });

      if (0 < length) {
        await p1.play(DeviceFileSource(list_per_reading.elementAt(0)!.path));
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

    sentences.forEach((sentence){

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
          first.add(words[0]);
          list.add(first);
        }else{
          if (RegExp(r'[",|()-]').hasMatch(words[0])) {
            List<String> first = [];
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
