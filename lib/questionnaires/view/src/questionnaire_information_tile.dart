import 'package:faiadashu/l10n/l10n.dart';
import 'package:faiadashu/questionnaires/view/view.dart' show Xhtml;
import 'package:fhir_r4/fhir_r4.dart' show Questionnaire;
import 'package:flutter/material.dart';

/// Informational tile about a [Questionnaire].
///
/// Contains information such as title and publisher.
class QuestionnaireInformationTile extends StatelessWidget {
  final Questionnaire questionnaire;
  const QuestionnaireInformationTile(this.questionnaire, {super.key});

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = Theme.of(context).textTheme.titleMedium;

    return Column(
      children: [
        Xhtml.fromPlainTextAndExtensions(
          context,
          questionnaire.title?.value ??
              FDashLocalizations.of(context).questionnaireUnknownTitle,
          extensions: questionnaire.titleElement?.extension_,
          defaultTextStyle: defaultTextStyle,
        ),
        const Divider(),
        Xhtml.fromPlainTextAndExtensions(
          context,
          questionnaire.publisher?.value ??
              FDashLocalizations.of(context).questionnaireUnknownPublisher,
          extensions: questionnaire.publisherElement?.extension_,
          defaultTextStyle: defaultTextStyle,
        ),
      ],
    );
  }
}
