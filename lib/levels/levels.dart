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
