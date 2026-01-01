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
enum FhirExpressionLanguage {
  textFhirpath(ExpressionLanguage.textFhirpath),
  applicationXFhirQuery(ExpressionLanguage.applicationXFhirQuery),
  textCql(ExpressionLanguage.textCql),
  unknown(ExpressionLanguage.textCql);

  const FhirExpressionLanguage(this.value);

  final ExpressionLanguage value;
}
