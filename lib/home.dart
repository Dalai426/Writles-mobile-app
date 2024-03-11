import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writless/Components/tabs.dart';
import 'package:writless/providers/generalProvider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
            onTap: () async {
              context.read<GeneralProvider>().changeNavigatorIndex(4, context);
            },
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 35, bottom: 10),
              padding: const EdgeInsets.only(top: 5, left: 20, bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 190),
                        child: Text(
                            "Та ${context.read<GeneralProvider>().userLevel.toInt()} дүгээр түвшин тийм биз ??",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                      ),
                      const Image(image: AssetImage("img/training.png"), width: 150)
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                  ),
                  Container(
                    child: Row(
                      children: [
                        const Image(image: AssetImage("img/arrow.png"), width: 60),
                        const SizedBox(width: 15),
                        Text("Хэрэглэгчийн мэдээлэл",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline))
                      ],
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(right: 20, left: 20),
                  )
                ],
              ),
            )),
        Text(
          "Цээж бичиг бичих",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Theme.of(context).colorScheme.primary),
        ),
        Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
          child: const Tabs(title: 'tabs'),
        )
      ],
    );
  }
}
