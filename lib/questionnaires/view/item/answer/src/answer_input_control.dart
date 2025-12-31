import 'package:faiadashu/questionnaires/model/model.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

abstract class AnswerInputControl<A extends AnswerModel>
    extends StatelessWidget {
  final A answerModel;
  final FocusNode? focusNode;

  QuestionnaireItem get qi =>
      answerModel.questionnaireItemModel.questionnaireItem;
  Locale get locale =>
      answerModel.responseItemModel.questionnaireResponseModel.locale;
  QuestionnaireItemModel get itemModel => answerModel.questionnaireItemModel;

  const AnswerInputControl(
    this.answerModel, {
    this.focusNode,
    super.key,
  });
}
