import 'package:flutter/material.dart';

class FinishPage extends StatefulWidget {
  const FinishPage({super.key, required this.title});

  final String title;

  @override
  State<FinishPage> createState() => _FinishPage();
}
class _FinishPage extends State<FinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children:[
                Transform.rotate(
                  angle: -1.4,
                  child:Container(width: MediaQuery.of(context).size.width/1.3,
                    height: MediaQuery.of(context).size.height,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                const Image(
                  image: AssetImage("img/Thankyou.png"),
                )
            ])
          )
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child:FloatingActionButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(Icons.home_rounded,
              color: Theme.of(context).colorScheme.outline, size: 40),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/'));
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked
    );
  }
}
