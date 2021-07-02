import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
 
  List<String> tabviewsString = [
    "Home Here",
    " this is Setting",
  ];
  late TabController tabCtl;
  void initState() {
    super.initState();
    tabCtl = new TabController(length: tabviewsString.length, vsync: this)
      ..addListener(() {
        setState(() {
          print("Current Tab index is : ${tabCtl.index}");
        });
      });
  }

  void dispose() {
    super.dispose();
    tabCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          TabBar(
            isScrollable: true,
            indicatorColor: Colors.transparent,
            tabs: [
              CustomTab(
                index: 0,
                title: " Home ",
                tabCtl: tabCtl,
                iconData: Icons.home,
              ),
              CustomTab(
                index: 1,
                title: " Setting ",
                tabCtl: tabCtl,
                iconData: Icons.settings,
              ), 
            ],
            controller: tabCtl,
          ),
          Expanded(
            child: TabBarView(
              children: tabviews(),
              controller: tabCtl,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> tabviews() {
    return tabviewsString
        .map((e) => Center(
              child: Text(e),
            ))
        .toList();
  }
}

class CustomTab extends StatefulWidget {
  final String title;
  final int index;
  final TabController tabCtl;
  final IconData iconData;
  CustomTab(
      {required this.title,
      required this.index,
      required this.tabCtl,
      required this.iconData});
  CustomTabState createState() => CustomTabState(
      title: title, index: index, tabCtl: tabCtl, iconData: iconData);
}

class CustomTabState extends State<CustomTab>
    with SingleTickerProviderStateMixin {
  String title;
  int index;
  late TabController tabCtl;
  IconData iconData;
  late AnimationController controller;
  late Animation<double> iconFadeTranstion;
  CustomTabState(
      {required this.title,
      required this.index,
      required this.tabCtl,
      required this.iconData});

  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    iconFadeTranstion = controller.drive(Tween<double>(begin: .6, end: 1.0));
    if (tabCtl.index == index) {
      controller.forward();
    } else {
      controller.reverse();
    }
  }

  void didUpdateWidget(CustomTab w) {
    if (tabCtl.index == index) {
      controller.forward();
    } else {
      controller.reverse();
    }
    super.didUpdateWidget(w);
  }

  void dispose() {
    super.dispose();
    controller.dispose();
    tabCtl.dispose();
  }

  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    print("${tabCtl.index}");
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 50,
      width: tabCtl.index == index ? (w / 100) * 75 : 20,
      child: tabCtl.index == index
          ? FadeTransition(
              opacity: controller,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.teal, fontSize: 20),
                ),
              ),
            )
          : FadeTransition(
              opacity: iconFadeTranstion,
              child: Icon(
                iconData,
                color: Colors.teal,
                size: 30,
              ),
            ),
    );
  }
}
