import 'package:faiadashu/faiadashu.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PHQ-4 Questionnaire',
      localizationsDelegates: FDashLocalizations.localizationsDelegates,
      supportedLocales: FDashLocalizations.supportedLocales,
      home: const StepperPage(),
    );
  }
}

class StepperPage extends StatelessWidget {
  const StepperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestionnaireStepperPage(
      fhirResourceProvider: AssetResourceProvider.singleton(
        questionnaireResourceUri,
        'assets/questionnaires/phq-4.json',
      ),
      launchContext: LaunchContext(),
      locale: const Locale('en'),
    );
  }
}
