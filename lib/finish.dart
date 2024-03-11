import 'package:flutter/cupertino.dart';
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
                Image(
                  image: AssetImage("img/Thankyou.png"),
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      SizedBox(height: 80,),
                      GestureDetector(
                          onTap: () async {
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: Theme.of(context).colorScheme.secondary,
                                          width: 1)),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15)),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Image(
                                    image: AssetImage("img/ig.png"),
                                    width: 30,
                                  ),
                                  Text(
                                    "ЗУРГААР ШАЛГАХ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium!
                                        .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  Image(
                                    image: AssetImage("img/ig.png"),
                                    width: 30,
                                  ),
                                ],
                              )
                          ))
                    ],
                  ),
                )
            ])
          )
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
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
