import 'package:faiadashu/questionnaires/model/expression/expression.dart';
import 'package:faiadashu/questionnaires/model/expression/src/fhir_r4_path_compat.dart';
import 'package:fhir_r4/fhir_r4.dart';

abstract class FhirExpressionEvaluator extends ExpressionEvaluator {
  FhirExpressionEvaluator(
    FhirExpression fhirExpression,
    Iterable<ExpressionEvaluator> upstreamExpressions, {
    String? debugLabel,
  }) : super(
          // Using .value breaks on real-world content with invalid identifiers.
          fhirExpression.name?.toString(),
          upstreamExpressions,
          debugLabel: debugLabel,
        );

  factory FhirExpressionEvaluator.fromExpression(
    Resource? Function()? resourceBuilder,
    FhirExpression fhirExpression,
    Iterable<ExpressionEvaluator> upstreamExpressions, {
    FhirBase? Function()? contextBuilder,
    String? debugLabel,
  }) {
    final language = ArgumentError.checkNotNull(fhirExpression.language);
    if (language == FhirExpressionLanguage.textFhirpath.value) {
      return FhirPathExpressionEvaluator(
        resourceBuilder,
        fhirExpression,
        upstreamExpressions,
        jsonBuilder: contextBuilder,
        contextBuilder: contextBuilder,
        debugLabel: debugLabel,
      );
    } else if (language == FhirExpressionLanguage.applicationXFhirQuery.value) {
      return FhirQueryExpressionEvaluator(
        fhirExpression,
        upstreamExpressions,
        debugLabel: debugLabel,
      );
    } else if (language == FhirExpressionLanguage.textCql.value ||
               language == FhirExpressionLanguage.unknown.value) {
      throw UnsupportedError(
        'Expressions of type ${fhirExpression.language} are unsupported.',
      );
    } else {
      throw UnsupportedError(
        'Expressions of type ${fhirExpression.language} are unsupported.',
      );
    }
  }
}
