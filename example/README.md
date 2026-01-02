# Questionnaire display example

This Flutter sample shows how to render the Patient Health Questionnaire (PHQ-4) with the `faiadashu` package.
The questionnaire JSON is bundled as an asset at `assets/questionnaires/phq-4.json`.

## Running the demo
1. From the repository root, change into the example directory:
   ```bash
   cd example
   ```
2. Install dependencies and run the app on an attached device or emulator:
   ```bash
   flutter pub get
   flutter run -d <device_id>
   ```

## How it works
The example wires `questionnaireResourceUri` to the bundled PHQ-4 asset through `AssetResourceProvider` and
passes that provider, along with a basic `LaunchContext`, into `QuestionnaireScrollerPage`.
`FDashLocalizations.localizationsDelegates` and `FDashLocalizations.supportedLocales` enable the
localizations shipped with the package.
