import 'package:faiadashu/fhir_types/fhir_types.dart';
import 'package:faiadashu/l10n/l10n.dart';
import 'package:faiadashu/questionnaires/view/view.dart';
import 'package:fhir/r4.dart' show Questionnaire;
import 'package:flutter/material.dart';

/// Show a dialog containing a [QuestionnaireInformationTile].
Future<void> showQuestionnaireInfo(
  BuildContext context,
  Locale locale,
  Questionnaire questionnaire,
  void Function(BuildContext context)? onClose,
) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Localizations.override(
          context: context,
          locale: locale,
          child: Builder(
            builder: (context) => Text(
              MaterialLocalizations.of(context).aboutListTileTitle(
                localizedFhirText(
                  questionnaire.title ??
                      FDashLocalizations.of(context).questionnaireGenericTitle,
                  questionnaire.titleElement?.extension_,
                  locale,
                ),
              ),
            ),
          ),
        ),
        content: QuestionnaireInformationTile(questionnaire, locale: locale),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => onClose?.call(context),
            child: Localizations.override(
              context: context,
              locale: locale,
              child: Builder(
                builder: (context) => Text(
                  MaterialLocalizations.of(context).closeButtonLabel,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
