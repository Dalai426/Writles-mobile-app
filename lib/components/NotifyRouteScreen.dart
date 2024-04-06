import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writles/providers/generalProvider.dart';

import 'entity/ScreenArguments.dart';

class RouteNotify extends StatefulWidget {
  const RouteNotify({super.key});
  @override
  State<RouteNotify> createState() => _RouteNotify();
}

class _RouteNotify extends State<RouteNotify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: GestureDetector(
                    onTap: () {
                      final ScreenArgumentsFromNot args = ModalRoute.of(context)?.settings.arguments as ScreenArgumentsFromNot;

                      if (args!=null) {
                        context.read<GeneralProvider>().garchig.text=args.title;
                        context.read<GeneralProvider>().eh.text=args.text;
                        context.read<GeneralProvider>().selectedIndex=3;
                      }
                      Navigator.pushNamed(context,'/home');

                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Цээж бичгээ хийх ",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .copyWith(color: Colors.white),
                        ))))));
  }
}
