import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writles/NotificationScreen.dart';
import 'package:writles/providers/generalProvider.dart';

class FromTextPage extends StatefulWidget {
  const FromTextPage({super.key, required this.title});

  final String title;

  @override
  State<FromTextPage> createState() => _FromTextPage();
}

class _FromTextPage extends State<FromTextPage> {


  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height - 57,
        child:SingleChildScrollView(
          child:Stack(alignment: Alignment.center, children: [
          Positioned(
            bottom: 200,
            right: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 100,
                      spreadRadius: 100,
                      color: const Color(0xFFFFDBC5).withOpacity(0.3))
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: 100,
                      spreadRadius: 100,
                      color: const Color(0xFFFFDBC5).withOpacity(0.3))
                ],
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Цээж бичгийн түвшин :",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.surface),
                      ),
                      Text(
                        "Түвшин ${context.read<GeneralProvider>().userLevel.toInt()}",
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .copyWith(
                                color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Slider(
                    inactiveColor: Theme.of(context).colorScheme.surface,
                    min: 1,
                    value: context.watch<GeneralProvider>().userLevel,
                    max: 5,
                    divisions: 4,
                    label: context.read<GeneralProvider>().userLevel.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        context.read<GeneralProvider>().changeLevel(value);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height/3,
                    padding: const EdgeInsets.only(
                        top: 20, left: 15, right: 15, bottom: 10),
                    constraints: const BoxConstraints(minHeight: 500),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: const Offset(0, -3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 25,
                              width: 4,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Гарчиг",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: context.read<GeneralProvider>().garchig,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                            border: const OutlineInputBorder(),
                            hintText: 'Цээж бичгийн гарчгийг оруулна',
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              height: 25,
                              width: 4,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text("Эх",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: context.read<GeneralProvider>().eh,
                          textAlign: TextAlign.justify,
                          minLines: 14,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.surface),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface),
                            border: const OutlineInputBorder(),
                            hintText: 'Цээж бичгийн эхийг энд оруулна',
                          ),
                        ),
                      ],
                    )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(builder:(context)=>NotificatierScreen(garchig:context.read<GeneralProvider>().garchig.text,
                          eh:context.read<GeneralProvider>().eh.text
                      )));
                    },
                      child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: const Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Цээж бичиг сануулах",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                        ),
                        Icon(
                          Icons.notifications_active,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                  )),
                ],
              ))
        ]
        )));
  }
}
