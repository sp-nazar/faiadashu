import 'package:faiadashu/fhir_types/fhir_types.dart';
import 'package:faiadashu/l10n/l10n.dart';
import 'package:faiadashu/questionnaires/model/model.dart';
import 'package:fhir_r4/fhir_r4.dart'
    show
        FhirDate,
        FhirDateTime,
        FhirTime,
        QuestionnaireResponseAnswer,
        QuestionnaireResponseItem;

class DateTimeAnswerModel extends AnswerModel<FhirDateTime, FhirDateTime> {
  DateTimeAnswerModel(super.responseModel);

  @override
  RenderingString get display => (value != null)
      ? RenderingString.fromText(
          value!.format(locale, defaultText: AnswerModel.nullText),
        )
      : RenderingString.nullText;

  @override
  QuestionnaireResponseAnswer? createFhirAnswer(
    List<QuestionnaireResponseItem>? items,
  ) {
    final itemType = qi.type;

    final value = this.value;
    if (value == null) {
      return null;
    }

    if (itemType.value == 'date') {
      final dateValue = value?.valueDateTime ?? value?.value;
      return QuestionnaireResponseAnswer(
        valueDate:
            dateValue is DateTime ? FhirDate.fromDateTime(dateValue) : null,
        item: items,
      );
    } else if (itemType.value == 'datetime') {
      return QuestionnaireResponseAnswer(
        valueDateTime: value,
        item: items,
      );
    } else if (itemType.value == 'time') {
      final timeValue = value?.valueDateTime ?? value?.value;
      return QuestionnaireResponseAnswer(
        valueTime: FhirTime(
          timeValue is DateTime
              ? timeValue.toIso8601String().substring('yyyy-MM-ddT'.length)
              : '',
        ),
        item: items,
      );
    } else {
      throw StateError('Unexpected itemType: $itemType');
    }
  }

  @override
  String? validateInput(FhirDateTime? inValue) {
    return validateValue(inValue);
  }

  @override
  String? validateValue(FhirDateTime? inValue) {
    return inValue == null || inValue.isValid
        ? null
        : lookupFDashLocalizations(locale).validatorDateTime;
  }

  @override
  bool get isEmpty => value == null;

  @override
  void populateFromExpression(dynamic evaluationResult) {
    if (evaluationResult == null) {
      value = null;

      return;
    }

    if (evaluationResult is FhirDateTime) {
      value = evaluationResult;
    } else if (evaluationResult is FhirDate) {
      value = FhirDateTime.fromDateTime(
        evaluationResult.valueDateTime ?? DateTime.now(),
      );
    } else if (evaluationResult is DateTime) {
      value = FhirDateTime.fromDateTime(evaluationResult);
    } else if (evaluationResult is String) {
      value = FhirDateTime.fromString(evaluationResult);
    }
  }

  @override
  void populate(QuestionnaireResponseAnswer answer) {
    final dateValue = answer.valueDate?.valueDateTime;
    value = answer.valueDateTime ??
        (dateValue != null ? FhirDateTime.fromDateTime(dateValue) : null);
  }
}
