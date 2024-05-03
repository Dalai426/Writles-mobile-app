import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> connectiveCheck(BuildContext context)async{
  bool arg= await InternetConnectionChecker().hasConnection;
  if(!arg){
    showCupertinoDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=>
            CupertinoAlertDialog(
              title: const Text("Интернет холболт",  style: TextStyle(
                  color: const Color(0xFF213150)
              )),
              content: const Text("Интернет холболтоо шалгана уу !!!", style: TextStyle(
                  color: const Color(0xFF213150)
              ),),
              actions:<Widget>[
                TextButton(onPressed:(){
                  Navigator.pop(context,false);
                }, child: Text("Ok", style: TextStyle(
                    color: const Color(0xFF213150)
                ),))
              ],
            )
    );
  }
  return arg;
}
