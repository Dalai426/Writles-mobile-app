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

class LevelOne extends Levels {
  List<List<String>> level_one_wavs = [];
  List<String> wavs = [];
  var logger = Logger();

  LevelOne();

  void init(String text, int level, {String? title}) async {

    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");


    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }
    final Map<String, String> queryParams = {
      'level': '1',
      'text': text,
      'voice': 'female3'
    };

    if(title!=null && title.isNotEmpty) {
      hasTitle=true;
      queryParams["title"]=title;
    }


    var uri = Uri.http(apiflask, 'tts/extract-full', queryParams);
    final client = http.Client();

    try {
      var request = http.Request('GET', uri);
      final response = await client.send(request);
      int wordKey=0;
      int vyeKey=0;
      bool towavs=false;
      List<String> word=[];
      List<int> audio=[];

      await for (var chunk in response.stream) {
        int len=chunk.length;
        if(len==1){
          wordKey++;
          vyeKey=0;
          level_one_wavs.add(List.of(word));
          word.clear();
        }else if(len==2){
          towavs=true;
          vyeKey=0;
        }else if(len==3){
          if(towavs==false) {
            File file = File('$dir/${wordKey}_${vyeKey}_wav.wav');
            await file.writeAsBytes(audio);
            word.add(file.path);
          }else{
            File file = File('$dir/${vyeKey}_wav.wav');
            await file.writeAsBytes(audio);
            wavs.add(file.path);
          }
          vyeKey++;
          audio.clear();
        }else{
          audio.addAll(List.of(chunk));
        }
      }
    }  finally {
      client.close();
    }
    count_text = wavs.length;
  }

  Future<StreamSubscription?> nextWav(BuildContext context, Function function) async {
    String ret;
    List<String> semis;
    StreamSubscription? streamSubscription;

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        ret = wavs.elementAt(count_text - 1);
        semis = level_one_wavs[count_text - 1];
      } else {
        ret = wavs.elementAt(reading_wav_index);
        semis = level_one_wavs[reading_wav_index];
        reading_wav_index++;
      }

      int i = -1;
      int count = hasTitle == true ? 0 : 1;
      bool bell=false;

      streamSubscription = p1.onPlayerComplete.listen((event){
        i++;
        print(i);
        if(semis.elementAtOrNull(i) != null){
          int second= i==0?5000:1000;
          delayTimer = Timer(Duration(milliseconds: second), ()  {
            p1.play(DeviceFileSource(semis.elementAt(i)));
          });
        }else{
          if(count<2){
            delayTimer = Timer(const Duration(milliseconds: 4000), ()  {
              p1.play(DeviceFileSource(ret));
            });
          }else{
            if(bell==false){
              bell=true;
              delayTimer = Timer(const Duration(milliseconds: 5000), ()  {
                p1.play(AssetSource("audios/bell.wav"));
              });
            }else {
              delayTimer = Timer(const Duration(milliseconds: 3000), () {
                function();
              });
            }
          }
          count++;
        }
      });

      if(hasTitle == true && reading_wav_index == 1){
        p1.play(AssetSource("audios/garchig.wav"));
      }else {
        p1.play(DeviceFileSource(ret));
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
  // Map<int, List<String>> spilitWithVye(List<String> _strings) {
  //   Map<int, List<String>> map = Map();
  //
  //   for (int val = 0; val < _strings.length; val++) {
  //     _strings[val] = _strings[val]
  //         .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');
  //
  //     List<String> vye = [];
  //     String stack = "";
  //     for (int i = 0; i < _strings[val].length; i++) {
  //       if (checkEgshig(_strings[val][i])) {
  //         stack += _strings[val][i];
  //       } else {
  //         if (i != 0 && stack.isNotEmpty) {
  //           if (i != _strings[val].length - 1) {
  //             if (!checkEgshig(_strings[val][i + 1])) {
  //               // todo boljmor beltgev
  //               if (i + 1 == _strings[val].length - 1) {
  //                 // 2 giigvvlegch daraalj orson ch 2 deh giigvvlegch ni vgiin tugsguld baih bol
  //                 stack += _strings[val][i];
  //                 stack += _strings[val][i + 1];
  //                 vye.add(stack);
  //                 stack = "";
  //                 break;
  //               } else {
  //                 // 2 giigvvlegch daraallaj orson bol
  //                 stack += _strings[val][i];
  //               }
  //             } else {
  //               // giigvvlegchiin araas egshig orson bol
  //               vye.add(stack);
  //               stack = "";
  //               stack += _strings[val][i];
  //               continue;
  //             }
  //           } else {
  //             // svvliin vseg bol
  //             stack += _strings[val][i];
  //             vye.add(stack);
  //             stack = "";
  //             continue;
  //           }
  //         } else {
  //           stack += _strings[val][i];
  //         }
  //       }
  //     }
  //
  //     if (stack.isNotEmpty) {
  //       vye.add(stack);
  //     }
  //
  //     logger.t(vye.toString());
  //
  //     map[val] = vye;
  //   }
  //
  //   return map;
  // }
}
