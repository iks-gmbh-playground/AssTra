import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:flutter/material.dart';


class AssTraAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String mainTitle;
  final String subTitle;
  final String subTitleSubLine;
  final bool withFlowControlIcon;

  double height = 0;
  VoidCallback? backFunction;

  AssTraAppBar({required this.mainTitle,
                required this.subTitle,
                required this.subTitleSubLine,
                required this.withFlowControlIcon,
                this.backFunction,
                super.key}) {
    if (mainTitle != '') {
      height = 60.0;
    } else if (subTitleSubLine == '') {
      height = 50.0;
    } else {
      height = 80.0;
    }
  }


  @override
  Widget build(BuildContext context) {
    if (mainTitle != '') {
      return AppBar(
            automaticallyImplyLeading: withFlowControlIcon ? true : false,
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Center(
                child: Text(mainTitle)
            )
        );
      }

      if (subTitleSubLine == '') {
        return AppBar(
            automaticallyImplyLeading: withFlowControlIcon ? true : false,
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .secondary,
            title: Align(
              alignment: Alignment.topCenter,
              child: AssTraStringUtil.markdownStringToSizedText22('*$subTitle*')
            )
        );
      }

      return AppBar(
        leading: backFunction != null ? BackButton(onPressed: backFunction) : null,
          automaticallyImplyLeading: withFlowControlIcon ? true : false,
          toolbarHeight: 80,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: Column(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: AssTraStringUtil.markdownStringToSizedText22('*$subTitle*')
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: AssTraStringUtil.markdownStringToSizedText22(subTitleSubLine),
                ),
              ]
          )
      );
  }

  @override
  Size get preferredSize =>  Size.fromHeight(height);
}