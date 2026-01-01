import 'package:fhir_r4/fhir_r4.dart';

/// Compatibility helpers to ease migration from the `fhir` package to
/// `fhir_r4`. The new primitives expose their raw value as `valueString` or
/// type-specific getters (e.g., `valueDateTime`). These extensions recreate the
/// legacy `value` and `isValid` getters that the rest of the codebase expects.
extension FhirPrimitiveValueCompat on PrimitiveType {
  dynamic get value {
    if (this is FhirNumber) {
      return (this as FhirNumber).valueNum;
    }
    if (this is FhirBoolean) {
      return (this as FhirBoolean).valueBoolean;
    }
    if (this is FhirDateTime) {
      return (this as FhirDateTime).valueDateTime ??
          (this as FhirDateTime).valueString;
    }
    if (this is FhirDate) {
      return (this as FhirDate).valueDateTime ??
          (this as FhirDate).valueString;
    }
    return primitiveValue;
  }
}

extension FhirBooleanCompat on FhirBoolean {
  bool get isValid => valueString != null;
}

extension FhirTimeCompat on FhirTime {
  bool get isValid => valueString != null;
}

extension FhirDateTimeCompat on FhirDateTime {
  bool get isValid => (valueDateTime ?? valueString) != null;
}

extension FhirNumberCompat on FhirNumber {
  bool get isValid => valueString != null;
}

extension FhirCodeEnumCompat on FhirCodeEnum {
  String? get value => valueString;
}

extension FhirStringValueCompat on FhirString {
  String? get value => valueString;
}

extension FhirDecimalValueCompat on FhirDecimal {
  num? get value => valueNum;
}

extension FhirIntegerValueCompat on FhirInteger {
  num? get value => valueNum;
}

extension FhirBase64Compat on FhirBase64Binary {
  String? get value => valueString;
}

extension FhirUriCompat on FhirUri {
  String? get value => valueString;
}

extension CodingCompat on Coding {
  FhirString? get displayElement => display;
}

extension QuestionnaireCompat on Questionnaire {
  FhirString? get titleElement => title;
  FhirString? get publisherElement => publisher;
}
