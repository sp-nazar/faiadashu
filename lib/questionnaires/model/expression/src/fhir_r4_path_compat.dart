import 'package:fhir_r4/fhir_r4.dart';
import 'package:fhir_r4_path/fhir_r4_path.dart' as r4path;

typedef ParserList = r4path.ExpressionNode;

Future<ParserList> parseFhirPath(String pathExpression) =>
    r4path.parseFhirPath(pathExpression);

Future<List<FhirBase>> executeFhirPath({
  required FhirBase? context,
  required ParserList parsedFhirPath,
  required String pathExpression,
  FhirBase? resource,
  FhirBase? rootResource,
  Map<String, dynamic>? environment,
}) =>
    r4path.executeFhirPath(
      context: context,
      parsedFhirPath: parsedFhirPath,
      pathExpression: pathExpression,
      resource: resource,
      rootResource: rootResource,
      environment: environment,
    );

/// Legacy names for expression languages.
class FhirExpressionLanguage {
  static ExpressionLanguage get text_fhirpath =>
      ExpressionLanguage.textFhirpath;
  static ExpressionLanguage get application_x_fhir_query =>
      ExpressionLanguage.applicationXFhirQuery;
  static ExpressionLanguage get text_cql => ExpressionLanguage.textCql;
  static ExpressionLanguage get unknown => ExpressionLanguage.textCql;
}
