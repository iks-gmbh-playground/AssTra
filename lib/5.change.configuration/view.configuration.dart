import 'package:asstra/5.change.configuration/text.configuration.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/main.dart';
import 'package:asstra/common/widgets/IntegerInput.dart';
import 'package:flutter/material.dart';
import '../common/widgets/AssTraAppBar.dart';
import 'do.configuration.dart';

class AssTraConfigView extends StatefulWidget {

  final AssTraConfig appConfigData;

  const AssTraConfigView(this.appConfigData, {super.key});

  @override
  State<AssTraConfigView> createState() => _AssTraConfigViewState();
}

class _AssTraConfigViewState extends State<AssTraConfigView> {
  _AssTraConfigViewState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textConfigTitle, subTitleSubLine: '', withFlowControlIcon: false),
        body: getInternalScaffold()
    );
  }

  getInternalScaffold() {
    const buttonColor = Colors.grey;
    IntegerInput millisToWaitInput = IntegerInput(magnitude: 2,
                                                  initValue: widget.appConfigData.getMillisToWaitForNewQuest(),
                                                  buttonColor: buttonColor,
                                                  minValue: 100,
                                                  maxValue: 9000);
    IntegerInput learnLimitInput = IntegerInput(magnitude: 1,
                                                initValue: widget.appConfigData.getNumberOfCorrectAnswersToJudgeLearned(),
                                                buttonColor: buttonColor,
                                                minValue: 1,
                                                maxValue: 9);

    return Scaffold(body:
      Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(child: Column(
          children: [
            Center(child: AssTraStringUtil.markdownStringToSizedText18(textConfigMillisToWait)),
            millisToWaitInput,
            const SizedBox(height: 15),
            Center(child: AssTraStringUtil.markdownStringToSizedText18(textConfigLearnedLimit)),
            learnLimitInput,
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(onPressed: () => onPressSave(millisToWaitInput, learnLimitInput),
                  style: okButtonStyle,
                  child: const Text(textConfigSaveButton)
              ),
            )
          ],
        ))
      )
    );
  }

  onPressSave(IntegerInput millisToWaitInput,
              IntegerInput learnLimitInput) {
    widget.appConfigData.setMillisToWaitForNewQuest(millisToWaitInput.getValue());
    widget.appConfigData.setNumberOfCorrectAnswersToJudgeLearned(learnLimitInput.getValue());
    appRuntimeData.saveConfig(widget.appConfigData);

    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage())
    );
  }
}