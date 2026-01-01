# Faiadashu FHIRDash Copilot Instructions

## Project Overview
Faiadashu is a Flutter library for building healthcare applications using the HL7 FHIR standard. It provides UI components for FHIR Questionnaires, formatted clinical observations, and FHIR data handling with full localization support.

## Architecture
- **Core Components**: `questionnaires/` (model/view for questionnaire filling), `observations/` (display formatted clinical data), `fhir_types/` (FHIR data utilities and formatting), `resource_provider/` (abstraction for FHIR resource access).
- **Data Flow**: `QuestionnaireModel` wraps FHIR `Questionnaire`, `QuestionnaireResponseModel` manages responses and dynamic behavior. Use `FhirResourceProvider` implementations (e.g., `AssetResourceProvider`, `RegistryFhirResourceProvider`) for resource loading.
- **UI Pattern**: `QuestionnaireResponseFiller` widget creates `QuestionnaireResponseModel` asynchronously in `initState`, uses `InheritedWidget` (`QuestionnaireFillerData`) for context sharing.

## Key Conventions
- **Logging**: Use `Logger(Type)` or `Logger.tag('string')` for consistent logging with 'fdash.' prefix. Levels: error, warn, info, debug, trace.
- **FHIR Extensions**: Extend FHIR types (e.g., `FhirDateTime`) with formatting methods using `intl` package, special handling for Japanese locale.
- **Exceptions**: Throw `QuestionnaireFormatException` for invalid FHIR data.
- **Localization**: Use `FDashLocalizations` for strings, generate with `flutter gen-l10n` (see `tool/generate_localizations.sh`).
- **Code Style**: Follow `analysis_options.yaml` (lint + dart_code_metrics), exclude `*.g.dart` files, prefer single widget per file.

## Developer Workflows
- **Setup**: `flutter pub get` to fetch dependencies.
- **Migration**: To migrate from 'fhir' to 'fhir_r4' and 'fhir_path' to 'fhir_r4_path', update `pubspec.yaml` dependencies and change imports from `package:fhir/` to `package:fhir_r4/` and `package:fhir_path/` to `package:fhir_r4_path/`.
- **Localization**: Run `tool/generate_localizations.sh` after editing ARB files in `lib/l10n/arb/`.
- **Formatting**: `dart format --fix lib` after generation.
- **Analysis**: `flutter analyze` respects custom rules (e.g., max cyclomatic complexity 20).
- **Testing**: No existing tests; add to `test/` directory using Flutter test framework.

## Integration Points
- **Dependencies**: Relies on `fhir_r4` for FHIR models, `intl` for formatting, `flutter_localizations` for i18n.
- **Resource Providers**: Implement `FhirResourceProvider` for custom FHIR data sources (e.g., servers, local storage).
- **Launch Context**: Pass `LaunchContext` for questionnaire initialization with external data.

## Examples
- Main questionnaire filler: `QuestionnaireResponseFiller` in `lib/questionnaires/view/src/questionnaire_filler.dart`.
- Model creation: `QuestionnaireModel.fromFhirResourceBundle()` requires `FhirResourceProvider`.
- Logging: `static final _logger = Logger(MyClass); _logger.debug('message');`
- Formatting: `fhirDateTime.format(locale)` for localized output.