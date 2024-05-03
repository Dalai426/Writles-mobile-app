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
  List<List<File?>> level_one_wavs = [];
  List<File?> wavs = [];
  var logger = Logger();

  LevelOne();

  void init(String text, int level, {String? title}) async {
    List<String> strings = text.trim().split(RegExp(r'\s+'));
    String apiflask = dotenv.get("API_FLASK", fallback: "");
    String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
    final Map<String, String> header = {"X-API-KEY": flaskapikey};

    if(title!=null) {
      strings.insert(0,title);
      hasTitle=true;
    }

    count_text = strings.length;

    String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";

    if (!Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }
    var dalai = spilitWithVye(strings).entries.map((e) async {
      final List<Future<File?>> downloadFutures =
      e.value.asMap().entries.map((w) async {
        final Map<String, String> queryParams = {
          'voice': 'female3',
          'text': w.value,
        };
        var uri = Uri.http(apiflask, 'tts/extract', queryParams);
        http.Response response = await http.get(uri, headers: header);
        if (response.statusCode == 200) {
          File file = File('${dir}/vye_${e.key}_${w.key}_wav.wav');
          file.writeAsBytes(response.bodyBytes);
          return file;
        } else {
          return null;
        }
      }).toList();
      final List<File?> files = await Future.wait(downloadFutures);
      return files;
    });

    final resp = strings.asMap().entries.map((entry) async {
      int index = entry.key;
      String word = entry.value;
      final Map<String, String> queryParams = {
        'voice': 'female3',
        'text': word,
      };
      var uri = Uri.http(apiflask, 'tts/extract', queryParams);
      http.Response response = await http.get(uri, headers: header);
      if (response.statusCode == 200) {
        File file = File('${dir}/${index}_wav.wav');
        file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        return null;
      }
    });

    level_one_wavs.addAll(await Future.wait(dalai));
    wavs.addAll(await Future.wait(resp));
  }

  Future<StreamSubscription?> nextWav(BuildContext context, Function function) async {

    File? ret;
    List<File?>? semis;
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

      int i = 0;
      int count = 1;
      bool ex = false;
      bool bell=false;

      streamSubscription = p1.onPlayerComplete.listen((event){
        delayTimer = Timer(const Duration(milliseconds: 200), ()  {
        });
        p1.stop();
        if (ex) {
          if(bell==false){
            bell=true;
            delayTimer = Timer(const Duration(milliseconds: 6000), ()  {
               p1.play(AssetSource("audios/bell.wav"));
            });
          }else {
            delayTimer = Timer(const Duration(milliseconds: 2000), () {
               function();
            });
          }
        } else {
          if (semis != null && semis.elementAtOrNull(i) != null) {
            int second = 1000;
            if (i == 0) {
              second = 3000;
            }
            delayTimer = Timer(Duration(milliseconds: second), ()  {
              p1.play(DeviceFileSource(semis!.elementAt(i)!.path));
              i++;
            });
          } else {
            count++;
            if (count < 2) {
              i = 1;
              delayTimer = Timer(const Duration(milliseconds: 4000), ()  {
                   p1.play(DeviceFileSource(semis!.elementAt(0)!.path));
              });
            } else {
              delayTimer = Timer(const Duration(milliseconds: 4000), ()  {
                  ex = true;
                  p1.play(DeviceFileSource(ret!.path));
              });
            }
          }
        }
      });


      if(hasTitle == true && reading_wav_index == 1){
        p1.play(AssetSource("audios/garchig.wav"));
      }else {
        p1.play(DeviceFileSource(ret!.path));
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

  Map<int, List<String>> spilitWithVye(List<String> _strings) {
    Map<int, List<String>> map = Map();

    for (int val = 0; val < _strings.length; val++) {
      _strings[val] = _strings[val]
          .replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');

      List<String> vye = [];
      String stack = "";
      for (int i = 0; i < _strings[val].length; i++) {
        if (checkEgshig(_strings[val][i])) {
          stack += _strings[val][i];
        } else {
          if (i != 0 && stack.isNotEmpty) {
            if (i != _strings[val].length - 1) {
              if (!checkEgshig(_strings[val][i + 1])) {
                // todo boljmor beltgev
                if (i + 1 == _strings[val].length - 1) {
                  // 2 giigvvlegch daraalj orson ch 2 deh giigvvlegch ni vgiin tugsguld baih bol
                  stack += _strings[val][i];
                  stack += _strings[val][i + 1];
                  vye.add(stack);
                  stack = "";
                  break;
                } else {
                  // 2 giigvvlegch daraallaj orson bol
                  stack += _strings[val][i];
                }
              } else {
                // giigvvlegchiin araas egshig orson bol
                vye.add(stack);
                stack = "";
                stack += _strings[val][i];
                continue;
              }
            } else {
              // svvliin vseg bol
              stack += _strings[val][i];
              vye.add(stack);
              stack = "";
              continue;
            }
          } else {
            stack += _strings[val][i];
          }
        }
      }

      if (stack.isNotEmpty) {
        vye.add(stack);
      }

      logger.t(vye.toString());

      map[val] = vye;
    }

    return map;
  }
}
