import 'package:faiadashu/faiadashu.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(QuestionnaireExampleApp());
}

class QuestionnaireExampleApp extends StatelessWidget {
  QuestionnaireExampleApp({super.key});

  final _fhirResourceProvider = AssetResourceProvider.singleton(
    questionnaireResourceUri,
    'assets/questionnaires/phq-4.json',
  );

  final _launchContext = LaunchContext(
    patient: Patient(
      id: Id('example'),
      name: [
        HumanName(
          text: 'Example Patient',
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PHQ-4 Questionnaire',
      localizationsDelegates: FDashLocalizations.localizationsDelegates,
      supportedLocales: FDashLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: QuestionnaireScrollerPage(
        fhirResourceProvider: _fhirResourceProvider,
        launchContext: _launchContext,
        locale: const Locale('en'),
      ),
    );
  }
}
