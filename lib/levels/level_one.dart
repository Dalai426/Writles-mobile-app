
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


class Level_one extends Levels{

  Map<int,List<File?>> level_one_wavs=new Map();
  List<File?> wavs=[];
  var logger = Logger();


  Level_one();

  void init(String text, int level, {String? title}) async {

    List<String> strings = text.trim().split(RegExp(r'\s+'));
    String NUM_API = dotenv.get("NLP_NUM_API", fallback: "");


    count_text=strings.length;

    String dir = (await getApplicationDocumentsDirectory()).path+"/wavs";


    if(!await Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }


    Map<int, List<String>> map_vye=spilitWithVye(strings);


    map_vye.entries.forEach((e) async {


      final files = await Future.wait(e.value.asMap().entries.map((w) async {
          final Map<String, String> queryParams = {
            'voice': '3',
            'text': '${w.value}',
          };
          var uri = await Uri.http(NUM_API, 'nlp-web-demo/tts',queryParams);
          http.Response response=await http.get(uri);
          if (response.statusCode == 200) {
            File file = File('${dir}/vye_${e.key}_${w.key}_wav.wav');
            file.writeAsBytes(response.bodyBytes);
            return file;
          }else{
            return null;
          }

        }).toList());


        level_one_wavs[e.key]=files;
    });


    final  resp=await Future.wait(strings.asMap().entries.map((entry) async {
      int index = entry.key;
      String word = entry.value;
      final Map<String, String> queryParams = {
        'voice': '3',
        'text': '${word}',
      };
      var uri = await Uri.http(NUM_API, 'nlp-web-demo/tts',queryParams);
      http.Response response=await http.get(uri);
      if (response.statusCode == 200) {
        File file = File('${dir}/${index}_wav.wav');
        file.writeAsBytes(response.bodyBytes);
        return file;
      }else{
        return null;
      }
    }).toList());

    wavs.addAll(resp);
  }




  Future<RetValAudio?> nextWav(BuildContext context, Function function) async {

    File? ret;
    List<File?>? semis;

    cancelDelay();

    try {
      if (reading_wav_index >= count_text) {
        reading_wav_index = count_text;
        ret = wavs.elementAt(count_text - 1);
        semis =level_one_wavs[count_text - 1];
      } else {
        ret = wavs.elementAt(reading_wav_index);
        semis = level_one_wavs[reading_wav_index];
        reading_wav_index++;
      }


      AudioPlayer p1 = new AudioPlayer();
      int i = 0;
      int count=1;
      bool ex=false;

      StreamSubscription streamSubscription=p1.onPlayerComplete.listen((event) async {
        logger.t(i);

        if(ex){
          delayTimer=Timer(Duration(milliseconds: 8000), () async {
            p1.stop();
            function();
          });
        }else{
          if (semis!=null && semis.elementAtOrNull(i) != null) {
            int second=1000;
            if(i==0){
              second=5000;
            }
            delayTimer=Timer(Duration(milliseconds: second),()async{
              if(p1.state!=PlayerState.disposed) {
                await p1.play(DeviceFileSource(semis!.elementAt(i)!.path));
                i++;
              }
            });
          } else {
            count++;
            if(count<2){
              i=1;
              delayTimer=Timer(Duration(milliseconds: 5000),() async {
                if(p1.state!=PlayerState.disposed) {
                  await p1.play(DeviceFileSource(semis!.elementAt(0)!.path));
                }
              });
            }else{
              delayTimer=Timer(Duration(milliseconds: 5000),() async {
                if(p1.state!=PlayerState.disposed) {
                  ex = true;
                  await p1.play(DeviceFileSource(ret!.path));
                }
              });
            }
          }
        }
      });


        delayTimer=Timer(Duration(milliseconds: 1000),() async {
          if(p1.state!=PlayerState.disposed) {
            await p1.play(DeviceFileSource(ret!.path));
          }
        });
        return RetValAudio(palyer: p1, streamSubscription: streamSubscription);



    }catch(e){
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

  }

  void prevWav() async {

    cancelDelay();
    if(reading_wav_index<=1){
      reading_wav_index=0;
    }else{
      reading_wav_index--;
    }
  }


  Map<int,List<String>> spilitWithVye(List<String> _strings){


    Map<int, List<String>> map=Map();

    for(int val=0; val<_strings.length; val++){

      _strings[val] = _strings[val].replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');

      List<String> vye=[];
      String stack="";
      for (int i = 0; i < _strings[val].length; i++) {
        if(checkEgshig(_strings[val][i])){
          stack+=_strings[val][i];
        }else{
          if(i!=0 && stack.isNotEmpty){
            if(i!=_strings[val].length-1){

              if(!checkEgshig(_strings[val][i+1])){

                // todo boljmor beltgev
                if(i+1==_strings[val].length-1){
                  // 2 giigvvlegch daraalj orson ch 2 deh giigvvlegch ni vgiin tugsguld baih bol
                  stack+=_strings[val][i];
                  stack+=_strings[val][i+1];
                  vye.add(stack);
                  stack="";
                  break;
                }else{
                  // 2 giigvvlegch daraallaj orson bol
                  stack+=_strings[val][i];
                }
              }else{
                // giigvvlegchiin araas egshig orson bol
                vye.add(stack);
                stack="";
                stack+=_strings[val][i];
                continue;
              }


            }else{
              // svvliin vseg bol
              stack+=_strings[val][i];
              vye.add(stack);
              stack="";
              continue;
            }
          }else{
            stack+=_strings[val][i];
          }
        }
      }

      if(stack.isNotEmpty){
        vye.add(stack);
      }

      logger.t(vye.toString());

      map[val]=vye;
    }

    return map;
  }




}
