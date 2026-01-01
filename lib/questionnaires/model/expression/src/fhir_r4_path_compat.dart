import 'package:fhir_r4/fhir_r4.dart';

/// Minimal compatibility layer to mimic the synchronous API provided by the old
/// `fhir_path` package. The new `fhir_r4_path` API is asynchronous and uses a
/// different set of types, so for now we provide lightweight stand-ins that
/// preserve the existing call sites. The implementation can be expanded to use
/// the full `fhir_r4_path` engine as needed.
typedef ParserList = String;

ParserList parseFhirPath(String pathExpression) => pathExpression;

List<FhirBase> executeFhirPath({
  required dynamic context,
  required ParserList parsedFhirPath,
  required String pathExpression,
  Map<String, dynamic>? environment,
}) {
  // TODO: Integrate with the asynchronous engine from `fhir_r4_path`.
  return <FhirBase>[];
}

/// Legacy names for expression languages.
class FhirExpressionLanguage {
  static ExpressionLanguage get text_fhirpath =>
      ExpressionLanguage.textFhirpath;
  static ExpressionLanguage get application_x_fhir_query =>
      ExpressionLanguage.applicationXFhirQuery;
  static ExpressionLanguage get text_cql => ExpressionLanguage.textCql;
  static ExpressionLanguage get unknown => ExpressionLanguage.textCql;
}
