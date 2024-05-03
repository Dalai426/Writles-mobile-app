import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class Levels{

  int count_text=0;
  int reading_wav_index=0;
  int level=0;

  AudioPlayer p1=AudioPlayer();
  AudioPlayer preplayer=AudioPlayer();
  Timer? delayTimer;
  bool hasTitle=false;

  void cancelDelay() {
    if (delayTimer != null && delayTimer!.isActive) {
      delayTimer!.cancel();
    }
  }

  void dispose() async {
    cancelDelay();
    if (p1.state != PlayerState.disposed) {
      p1.pause();
      p1.dispose();
    }
    final dir = Directory((await getApplicationDocumentsDirectory()).path + "/wavs");
    if (await dir.exists()) {
      dir.deleteSync(recursive: true);
      print("Directory deleted successfully");
    } else {
      print("Directory does not exist");
    }
  }


  // Future<String> loadAsset(String assetPath) async {
  //   // Load the asset file
  //   ByteData data = await rootBundle.load(assetPath);
  //   // Write the data to a temporary file
  //   Directory tempDir = await getTemporaryDirectory();
  //   File tempFile = File('${tempDir.path}/garchig.wav');
  //   await tempFile.writeAsBytes(data.buffer.asUint8List(), flush: true);
  //   return tempFile.path;
  // }
  //
  // Future<File?> wavToTitle(String title) async{
  //   String apiflask = dotenv.get("API_FLASK", fallback: "");
  //   String flaskapikey = dotenv.get("FLASK_API_KEY_VALUE", fallback: "");
  //   final Map<String, String> header = {"X-API-KEY": flaskapikey};
  //
  //   String dir = "${(await getApplicationDocumentsDirectory()).path}/wavs";
  //   if (!Directory(dir).existsSync()) {
  //     await Directory(dir).create(recursive: true);
  //   }
  //   final Map<String, String> queryParams = {
  //     'voice': '2',
  //     'text': title,
  //   };
  //   var uri = Uri.http(apiflask, 'tts/extract', queryParams);
  //   http.Response response=await http.get(uri, headers:header);
  //   if (response.statusCode == 200) {
  //     File wav_title = File('${dir}/garchig_wav.wav');
  //     wav_title.writeAsBytes(response.bodyBytes);
  //     return wav_title;
  //   }else{
  //     return null;
  //   }
  // }

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
