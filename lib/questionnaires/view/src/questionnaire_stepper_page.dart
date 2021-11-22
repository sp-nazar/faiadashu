import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../resource_provider/resource_provider.dart';
import '../../questionnaires.dart';
import '../view.dart';

/// A page, incl. a [Scaffold], that presents a questionnaire in the style of a wizard.
///
/// see [QuestionnaireStepper]
/// see [QuestionnaireScrollerPage]
class QuestionnaireStepperPage extends QuestionnaireStepper {
  const QuestionnaireStepperPage({
    Locale? locale,
    required FhirResourceProvider fhirResourceProvider,
    required LaunchContext launchContext,
    QuestionnaireTheme questionnaireTheme = const QuestionnaireTheme(),
    QuestionnaireModelDefaults questionnaireModelDefaults = const QuestionnaireModelDefaults(),
    Key? key,
  }) : super(
          locale: locale,
          scaffoldBuilder: const DefaultQuestionnairePageScaffoldBuilder(),
          fhirResourceProvider: fhirResourceProvider,
          launchContext: launchContext,
          questionnaireTheme: questionnaireTheme,
          questionnaireModelDefaults: questionnaireModelDefaults,
          key: key,
        );

  @override
  State<StatefulWidget> createState() => QuestionnaireStepperState();
}
