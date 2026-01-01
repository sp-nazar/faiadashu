# Migration from fhir_0.12.0 branch

## Upgrade checklist

1. Replace `fhir` and `fhir_path` dependencies to `fhir_r4` and `fhir_r4_path` and update imports.
2. Import `package:faiadashu/fhir_types/fhir_types.dart` (or `questionnaires.dart`) to pick up compatibility extensions for primitive values.
3. Audit custom code that calls expression evaluators, validation, or enablement APIs and make those call sites asynchronous.
4. Ensure any custom FHIRPath environments provide `FhirBase` values instead of plain JSON.
5. Re-test questionnaires that rely on enableWhen, initialExpression, or calculatedExpression logic to confirm behavior with the async pipeline.

## Dependencies and imports

- The package now depends on `fhir_r4` and `fhir_r4_path` instead of the legacy `fhir` and `fhir_path` packages. Update `pubspec.yaml` and your imports to reference `package:fhir_r4/fhir_r4.dart` and `package:fhir_r4_path/fhir_r4_path.dart`.
- `package:faiadashu/questionnaires/questionnaires.dart` now re-exports the `fhir_types` helpers so downstream code can access compatibility extensions without additional imports.

## FHIR primitive compatibility

- Legacy accessors (`value`, `isValid`) for primitives are provided through `lib/fhir_types/src/fhir_r4_compat.dart`. Import `package:faiadashu/fhir_types/fhir_types.dart` (or the re-export) to keep existing code working while you migrate to the new `valueString`/`valueNum` accessors from `fhir_r4`.
- Coding, CodeableConcept, and Identifier handling now read display and code values via `FhirString` fields. Adjust any direct access to `display`/`text` to read `valueString`.

## Expression and validation flow is asynchronous

- Expression evaluation now returns `Future` values (`ExpressionEvaluator.evaluate` and all FHIRPath evaluators). Any custom evaluators or callers must `await` these calls.
- Questionnaire lifecycle hooks—initial value population, calculated expressions, enablement checks, and constraint validation—now run asynchronously. Update integrations that previously assumed synchronous execution to `await`:
  - `QuestionItemModel.populateInitialValue` and `updateCalculatedExpression`
  - `FillerItemModel.updateEnabled` and enable-when expression evaluation
  - `ResponseItemModel.validate` and `QuestionnaireResponseModel.validate/updateEnabledItems`
- UI triggers such as `QuestionnaireCompleteButton` now `await` validation before toggling completion status.

## FHIRPath execution changes

- FHIRPath parsing/execution is routed through `fhir_r4_path` helpers in `fhir_r4_path_compat.dart`, which expect `FhirBase` objects (not raw JSON) for context and environment values. When providing environment variables to expressions, supply `FhirBase` instances or coerce primitives with the provided helpers.
- Legacy `FhirExpressionLanguage` values are mapped in `fhir_r4_path_compat.dart`; use these enums when constructing expressions to maintain compatibility.
