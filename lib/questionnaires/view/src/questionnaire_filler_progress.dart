import 'package:faiadashu/questionnaires/model/model.dart';
import 'package:flutter/material.dart';

/// Display a progress bar for the filling of a [QuestionnaireModel].
class QuestionnaireFillerProgress extends StatefulWidget {
  final QuestionnaireItemModel questionnaireItemModel;
  final double? height;
  final Color? answeredColor;
  final Color? unansweredColor;

  const QuestionnaireFillerProgress(this.questionnaireItemModel,
      {this.height, this.answeredColor, this.unansweredColor, Key? key})
      : super(key: key);

  @override
  _QuestionnaireFillerProgressState createState() =>
      _QuestionnaireFillerProgressState();
}

class _QuestionnaireFillerProgressState
    extends State<QuestionnaireFillerProgress> {
  @override
  void initState() {
    super.initState();
    widget.questionnaireItemModel.questionnaireModel
        .addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.questionnaireItemModel.questionnaireModel
        .removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    if (mounted) {
      setState(() {
        // Just rebuild.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.questionnaireItemModel
          .orderedQuestionnaireItemModels()
          .where((qim) => qim.isAnswerable)
          .map<Widget>((qim) {
        final theme = Theme.of(context);
        final height = widget.height ?? 4.0;
        final box = (qim.isAnswered)
            ? Container(
                height: height,
                color: widget.answeredColor ?? theme.accentColor)
            : Container(
                foregroundDecoration: BoxDecoration(
                    border: Border.all(color: theme.disabledColor, width: 0.5)),
                height: height,
                color: widget.unansweredColor,
              );
        return Expanded(child: box);
      }).toList(growable: false),
    );
  }
}
