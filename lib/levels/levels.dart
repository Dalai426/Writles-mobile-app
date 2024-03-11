import 'dart:async';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Levels{

  int count_text=0;
  int reading_wav_index=0;
  int level=0;
  File? wav_title;

  Timer? delayTimer;

  void cancelDelay() {
    if (delayTimer != null && delayTimer!.isActive) {
      delayTimer!.cancel();
    }
  }

  void dispose() async {
    cancelDelay();
    final dir = Directory((await getApplicationDocumentsDirectory()).path + "/wavs");
    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
      print("Directory deleted successfully");
    } else {
      print("Directory does not exist");
    }
  }

  void wavToTitle(String title) async{

    String NUM_API = dotenv.get("NLP_NUM_API", fallback: "");

    String dir = (await getApplicationDocumentsDirectory()).path+"/wavs";
    if(!await Directory(dir).existsSync()) {
      await Directory(dir).create(recursive: true);
    }

    final Map<String, String> queryParams = {
      'voice': '2',
      'text': '${title}',
    };
    var uri = await Uri.http(NUM_API, 'nlp-web-demo/tts',queryParams);
    http.Response response=await http.get(uri);
    if (response.statusCode == 200) {
      wav_title = File('${dir}/garchig_wav.wav');
      wav_title?.writeAsBytes(response.bodyBytes);
    }
  }

  bool checkEgshig(String char){
    List<String> egshigList = ['а', 'и', 'о', 'э', 'ө', 'ү','й','ы','у'
      ,'я','ю','ё','е'];

    if (egshigList.contains(char)) {
      return true;
    } else {
      return false;
    }
  }

}
