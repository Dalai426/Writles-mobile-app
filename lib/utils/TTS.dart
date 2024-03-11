import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class TTS {

  int count_text=0;
  var wavs = <File?>{};
  File? wav_title;
  int reading_wav_index=0;
  var logger = Logger();
  Map<int,Set<File?>>?level_one_wavs;

  TTS();



  void init(String text, int level, {String? title}) async {
    List<String> strings = text.trim().split(RegExp(r'\s+'));



    String NUM_API = dotenv.get("NLP_NUM_API", fallback: "");

    count_text=strings.length;


    String dir = (await getApplicationDocumentsDirectory()).path+"/wavs";
    if(!await Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }


    print(dir);

    if(level==1){
      Map<int, List<String>> map_vye=spilitWithVye(strings);

      level_one_wavs=new Map();

      map_vye.entries.forEach((e){

        var files = <File?>{};

        Future.wait(e.value.asMap().entries.map((w) async {
          final Map<String, String> queryParams = {
            'voice': '2',
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

        }).toList()).then((va) => files.addAll(va));
        level_one_wavs![e.key]=files;
      });
    }




    Future.wait(strings.asMap().entries.map((entry) async {
      int index = entry.key;
      String word = entry.value;
      final Map<String, String> queryParams = {
        'voice': '2',
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
    }).toList()).then((value) => wavs.addAll(value));



  }



  void wavToTitle(String title) async{

    String NUM_API = dotenv.get("NLP_NUM_API", fallback: "");

    String dir = (await getApplicationDocumentsDirectory()).path+"/wavs";
    if(!await Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }

    final Map<String, String> queryParams = {
      'voice': '3',
      'text': '${title}',
    };
    var uri = await Uri.http(NUM_API, 'nlp-web-demo/tts',queryParams);
    http.Response response=await http.get(uri);
    if (response.statusCode == 200) {
      wav_title = File('${dir}/garchig_wav.wav');
      wav_title?.writeAsBytes(response.bodyBytes);
    }
  }

  void dispose() async {
    final dir = Directory((await getApplicationDocumentsDirectory()).path + "/wavs");

    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
    }

  }

  Future<File?> nextWav() async {

    File? ret;

    if(reading_wav_index>=count_text){
      reading_wav_index=count_text;
      ret=wavs.elementAt(count_text-1);
    }else{
      ret=wavs.elementAt(reading_wav_index);
      reading_wav_index++;
    }

    return ret;
  }

  void prevWav() async {
    if(reading_wav_index<=1){
      reading_wav_index=0;
    }else{
      reading_wav_index--;
    }
  }


  bool checkEgshig(String char){
    List<String> egshigList = ['а', 'и', 'о', 'э', 'ө', 'ү','й','ы'
      ,'я','ю','ё','е'];

    if (egshigList.contains(char)) {
      return true;
    } else {
      return false;
    }
  }

  Map<int,List<String>> spilitWithVye(List<String> _strings){


    Map<int, List<String>> map=Map();

    for(int val=0; val<_strings.length; val++){


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
