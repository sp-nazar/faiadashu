import 'package:faiadashu/faiadashu.dart';

class FhirQueryExpressionEvaluator extends FhirExpressionEvaluator {
  FhirQueryExpressionEvaluator(
    super.fhirExpression,
    super.upstreamExpressions, {
    super.debugLabel,
  });

  @override
  Future<dynamic> evaluate({int? generation}) async {
    // TODO: implement evaluate
    return [];
  }
}
