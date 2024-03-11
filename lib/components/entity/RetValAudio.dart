import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

class RetValAudio{

  late AudioPlayer palyer;
  late StreamSubscription streamSubscription;

  RetValAudio({required this.palyer, required this.streamSubscription});

}
