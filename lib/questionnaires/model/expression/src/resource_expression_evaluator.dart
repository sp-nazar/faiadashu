import 'package:faiadashu/questionnaires/model/expression/expression.dart';
import 'package:fhir_r4/fhir_r4.dart';

class ResourceExpressionEvaluator extends ExpressionEvaluator {
  final Resource? Function() resourceBuilder;

  @override
  Future<dynamic> evaluate({int? generation}) async {
    final resource = resourceBuilder.call();

    return resource != null ? [resource] : <Resource>[];
  }

  ResourceExpressionEvaluator(
    String name,
    this.resourceBuilder, {
    String? debugLabel,
  }) : super(
          name,
          [],
          debugLabel: debugLabel,
        );
}
