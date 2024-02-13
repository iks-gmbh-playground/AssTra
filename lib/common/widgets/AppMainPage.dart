
import 'package:asstra/common/widgets/WaitStateWidget.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../asstra.constants.dart';
import '../utils/asstra.util.string.dart';
import 'AssTraAppBar.dart';

class AppMainPage extends StatefulWidget {
  final String title;
  final String mainMenuTitle;
  final Future<List<Widget>> appPagesFuture;
  final List<String> mainMenuNames;
  Image? waitStateImage;
  List<Widget> pages = List.empty(growable: true);
  bool firstTime = true;
  int _selectedIndex = 0;

  AppMainPage({required this.title, required this.appPagesFuture,
               required this.mainMenuTitle, required this.mainMenuNames,
               this.waitStateImage, super.key});

  @override State<AppMainPage> createState() => _AppMainPageState();

  AppMainPage getDefaultPage() {
    _selectedIndex = 0;
    return this;
  }
}


class _AppMainPageState extends State<AppMainPage> {

  @override Widget build(BuildContext context) {

    if (widget.firstTime) {
      widget.firstTime = false;
      widget.appPagesFuture.then((value)  {
        widget.pages.addAll(value);
        setState(() {});
      });
    }

    return WaitStateWidget(future: widget.appPagesFuture,
                           targetWidget: createContentPage(context, widget.pages),
                           aWaitStateText: appStartWaitStateText,
                           anErrorText: appStartErrorStateText,
                           aWaitStateImage: widget.waitStateImage);
  }

  Widget createContentPage(BuildContext context, List<Widget> pages) {
    Widget currentTargetWidget;
    if (pages.isNotEmpty) {
      if (appRuntimeData.firstAppStart) {
        widget._selectedIndex = 5;
        appRuntimeData.firstAppStart = false;
      }
      currentTargetWidget = pages.elementAt(widget._selectedIndex);
    } else {
      if (widget.waitStateImage == null) {
        return WaitStateWidget.createWaitStateScaffold(noImage, appStartWaitStateText, Colors.green);
      }
      return WaitStateWidget.createWaitStateScaffold(widget.waitStateImage!, appStartWaitStateText, Colors.green);
    }

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: widget.title, subTitle: '', subTitleSubLine: '', withFlowControlIcon: true),
        body: Center(
          child: currentTargetWidget,
        ),
        drawer: createMainMenu()
    );
  }

  void onTabMenuItem(int index) {
    setState(() {
      widget._selectedIndex = index;
    });
  }

  Drawer createMainMenu() {
      const double margin = 15;
      return Drawer(child: SingleChildScrollView(
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero, // Important: Remove any padding from the ListView.
          children: [
            SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Row(children: [AssTraStringUtil.markdownStringToSizedText22(widget.mainMenuTitle),
                                        const Spacer(),
                                        assTraLogo]),
                )
            ),
            ListView.builder(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.mainMenuNames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Container(
                      padding: const EdgeInsets.all(margin),
                      color: Colors.grey.shade300,
                      child: AssTraStringUtil.markdownStringToSizedText22(widget.mainMenuNames.elementAt(index))),
                  selected: widget._selectedIndex == index,
                  onTap: () {
                    onTabMenuItem(index); // Update the state of the app
                    Navigator.pop(context); // close the drawer
                  });
            }),
            const  SizedBox(height: 30),
            const  SizedBox(height: 30, child: iksLogoOhneSchrift),
            const  SizedBox(height: 30)
      ])));
    }
 }
