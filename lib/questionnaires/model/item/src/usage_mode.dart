import 'package:faiadashu/fhir_types/fhir_types.dart';
import 'package:fhir_r4/fhir_r4.dart';

final usageModeExtensionUrl =
    FhirUri('http://hl7.org/fhir/StructureDefinition/questionnaire-usageMode');

final usageModeSystem =
    FhirUri('http://hl7.org/fhir/ValueSet/questionnaire-usage-mode');

/// Render the item regardless of usage mode.
final usageModeCaptureDisplay = Coding(
  code: usageModeCaptureDisplayCode,
  display: 'Capture & Display'.toFhirString,
  system: usageModeSystem,
);

final usageModeCaptureDisplayCode = FhirCode('capture-display');

/// Render the item only when capturing data.
final usageModeCapture = Coding(
  code: usageModeCaptureCode,
  display: 'Capture Only'.toFhirString,
  system: usageModeSystem,
);

final usageModeCaptureCode = FhirCode('capture');

/// Render the item only when displaying data.
final usageModeDisplay = Coding(
  code: usageModeDisplayCode,
  display: 'Display Only'.toFhirString,
  system: usageModeSystem,
);

final usageModeDisplayCode = FhirCode('display');

/// Render the item only when displaying a completed form and the item has been answered (or has child items that have been answered).
final usageModeDisplayNonEmpty = Coding(
  code: usageModeDisplayNonEmptyCode,
  display: 'Display when Answered'.toFhirString,
  system: usageModeSystem,
);

final usageModeDisplayNonEmptyCode = FhirCode('display-non-empty');

/// Render the item when capturing data or when displaying a completed form and the item has been answered (or has child items that have been answered).
final usageModeCaptureDisplayNonEmpty = Coding(
  code: usageModeCaptureDisplayNonEmptyCode,
  display: 'Capture or, if answered, Display'.toFhirString,
  system: usageModeSystem,
);

final usageModeCaptureDisplayNonEmptyCode =
    FhirCode('capture-display-non-empty');

extension UsageModeExtension on List<FhirExtension> {
  FhirCode? get usageMode {
    return extensionOrNull(usageModeExtensionUrl)?.valueCode;
  }
}
