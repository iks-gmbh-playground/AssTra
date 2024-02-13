
import 'package:asstra/6.about/text.about.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../common/asstra.constants.dart';
import '../common/utils/asstra.util.string.dart';

enum FaqDisplayType {first, middle, last}

class AssTraAboutView extends StatefulWidget {
  final TextStyle faqStyle = const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue);

  int faqNumber;
  BuildContext? context;

  AssTraAboutView({required this.faqNumber, super.key});

  @override
  State<AssTraAboutView> createState() => _AssTraAboutViewState();
}

class _AssTraAboutViewState extends State<AssTraAboutView> {
  _AssTraAboutViewState();

  @override
  Widget build(BuildContext context) {
    String lineSeparator = '----------------';
    widget.context = context;

    List<Widget> content;
    if (widget.faqNumber == 1) {
      content = createFAQContent(textAboutFAQ_1_Title, textAboutFAQ_1_Text, FaqDisplayType.first);
    } else if (widget.faqNumber == 2) {
        content = createFAQContent(textAboutFAQ_2_Title, textAboutFAQ_2_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 3) {
      content = createFAQContent(textAboutFAQ_3_Title, textAboutFAQ_3_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 4) {
      content = createFAQContent(textAboutFAQ_4_Title, textAboutFAQ_4_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 5) {
      content = createFAQContent(textAboutFAQ_5_Title, textAboutFAQ_5_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 6) {
      content = createFAQContent(textAboutFAQ_6_Title, textAboutFAQ_6_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 7) {
      content = createFAQContent(textAboutFAQ_7_Title, textAboutFAQ_7_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 8) {
      content = createFAQContent(textAboutFAQ_8_Title, textAboutFAQ_8_Text, FaqDisplayType.middle);
    } else if (widget.faqNumber == 9) {
      content = createFAQContent(textAboutFAQ_9_Title, textAboutFAQ_9_Text, FaqDisplayType.last);
    } else {
      content = [
        assTraLogo,
        AssTraStringUtil.markdownStringToSizedText16(textAboutPreText),
        const SizedBox(height: 30),
        AssTraStringUtil.markdownStringToSizedText22(textAboutTitle),
        AssTraStringUtil.markdownStringToSizedText22(textAboutVersion),
        const SizedBox(height: 15),
        AssTraStringUtil.markdownStringToSizedText18(textAboutDescription),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(1), child: Text(textAboutFAQ_1_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(2), child: Text(textAboutFAQ_2_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(3), child: Text(textAboutFAQ_3_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(3), child: Text(textAboutFAQ_4_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(4), child: Text(textAboutFAQ_5_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(5), child: Text(textAboutFAQ_6_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(6), child: Text(textAboutFAQ_7_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(7), child: Text(textAboutFAQ_8_Title, style: widget.faqStyle))),
        AssTraStringUtil.markdownStringToSizedText16(lineSeparator),
        Align(alignment: Alignment.centerLeft, child: InkWell(onTap: () => goTo(8), child: Text(textAboutFAQ_9_Title, style: widget.faqStyle))),
        const SizedBox(height: 50),
        AssTraStringUtil.markdownStringToSizedText18(textPoweredBy),
        iksLogo
      ];
    }

    ScrollController scrollController = ScrollController();
    if (widget.faqNumber == -1) {
      WidgetsBinding.instance
          .addPostFrameCallback((_){
        scrollController.animateTo(scrollController.position.maxScrollExtent-120,
            duration: const Duration(milliseconds: 100),
            curve: Curves.ease);
      });
    }

    return Scaffold(
      appBar:  AssTraAppBar(mainTitle: '', subTitle: textAboutTitle, subTitleSubLine: '', withFlowControlIcon: true),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(10),
        child: Container(
            alignment: Alignment.topLeft,
            child: Column(children: content)
        )
      )
    );
  }

  List<Widget> createFAQContent(String title, String text, FaqDisplayType type) {
    return [
      Align(alignment: Alignment.topLeft, child: AssTraStringUtil.markdownStringToSizedText22("*$title*")),
      const SizedBox(height: 15),
      Align(alignment: Alignment.topLeft, child: AssTraStringUtil.markdownStringToSizedText22(text)),
      const SizedBox(height: 15),
      Row(children: [
        ElevatedButton(onPressed: type != FaqDisplayType.first ? () => goTo(widget.faqNumber-1) : null,
                       style: okButtonStyle,
                       child: const Text(textAboutPreviousButton)
        ),
        const Spacer(),
        ElevatedButton(onPressed: () => goTo(-1),
            style: okButtonStyle,
            child: const Text(textAboutBackButton)
         ),
        const Spacer(),
        ElevatedButton(onPressed: type != FaqDisplayType.last ? () => goTo(widget.faqNumber+1) : null,
                style: okButtonStyle,
                child: const Text(textAboutNextButton)
        )
      ])
    ];
  }

  goTo(int faqNumber) {
    widget.faqNumber = faqNumber;
    setState(() {});
  }


}

