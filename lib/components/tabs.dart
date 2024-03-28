import 'package:flutter/material.dart';
import 'package:writles/Components/tabs/tabwithphoto.dart';
import 'package:writles/Components/tabs/tabwithtext.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key, required this.title});

  final String title;

  @override
  State<Tabs> createState() => _Tabs();
}

class _Tabs extends State<Tabs> with SingleTickerProviderStateMixin {

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TabBar(
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            splashBorderRadius: BorderRadius.circular(20),
            indicator: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: Theme.of(context).textTheme.labelMedium,
            tabs: const [
              SizedBox(
                height: 40,
                child: Tab(text: 'Зургаас оруулах'),
              ),
              SizedBox(
                height: 30,
                child: Tab(text: 'Хуулж оруулах'),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          height: MediaQuery.of(context).size.height/2.15,

          child: TabBarView(
            controller: tabController,
            children: const [tabwithphoto(title: "txt"), tabwithtext(title: "txt")],
          ),
        )
      ],
    );
  }
}
