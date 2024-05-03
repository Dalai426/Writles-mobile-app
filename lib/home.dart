import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:writles/Components/tabs.dart';
import 'package:writles/providers/generalProvider.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
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
              margin: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
              padding: const EdgeInsets.only(top: 5, left: 20, bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        constraints: const BoxConstraints(maxWidth: 190),
                        child: Text(
                            context.watch<GeneralProvider>().username.text.isEmpty?
                            "Та ${context.watch<GeneralProvider>().userLevel.toInt()} дүгээр түвшин тийм биз ??":
                            "${context.watch<GeneralProvider>().username.text} , та ${context.watch<GeneralProvider>().userLevel.toInt()} дүгээр түвшин тийм биз ??",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                      ),
                      const Image(image: AssetImage("img/training.png"), width: 150)
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                    ),
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
