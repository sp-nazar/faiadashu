import 'dart:async';

import 'package:faiadashu/fhir_types/fhir_types.dart';
import 'package:faiadashu/logging/logging.dart';
import 'package:faiadashu/questionnaires/model/expression/expression.dart';
import 'package:faiadashu/questionnaires/model/expression/src/fhir_r4_path_compat.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:flutter/foundation.dart';

class FhirPathExpressionEvaluator extends FhirExpressionEvaluator {
  static final _logger = Logger(FhirPathExpressionEvaluator);

  final Resource? Function()? resourceBuilder;
  final FhirBase? Function()? contextBuilder;
  final String fhirPath;
  final FhirBase? Function()? jsonBuilder;

  late final Future<ParserList> _parsedFhirPath;

  int? _generation;
  dynamic _cachedResult;

  FhirPathExpressionEvaluator(
    this.resourceBuilder,
    FhirExpression fhirPathExpression,
    Iterable<ExpressionEvaluator> upstreamExpressions, {
    this.contextBuilder,
    this.jsonBuilder,
    String? debugLabel,
  })  : fhirPath = ArgumentError.checkNotNull(fhirPathExpression.expression?.value),
        super(
          fhirPathExpression,
          upstreamExpressions,
          debugLabel: debugLabel,
        ) {
    if (fhirPathExpression.language != FhirExpressionLanguage.textFhirpath.value) {
      throw ArgumentError(
        '$name has wrong language: ${fhirPathExpression.language}',
      );
    }

    _parsedFhirPath = parseFhirPath(fhirPath);
  }

  @override
  Future<dynamic> evaluate({int? generation}) async {
    if (generation != null && _generation == generation) {
      return _cachedResult;
    }

    final upstreamMap = <String, dynamic>{};

    for (final upstreamExpression in upstreamExpressions) {
      final name = ArgumentError.checkNotNull(upstreamExpression.name);
      final evaluationResult =
          await upstreamExpression.evaluate(generation: generation);

      upstreamMap[name] = _coerceToFhirList(evaluationResult);
    }

    final resource = resourceBuilder?.call();
    final context = contextBuilder?.call() ?? jsonBuilder?.call() ?? resource;
    final parsedFhirPath = await _parsedFhirPath;
    final fhirPathResult = await executeFhirPath(
      context: context,
      parsedFhirPath: parsedFhirPath,
      pathExpression: fhirPath,
      resource: resource,
      rootResource: resource,
      environment: upstreamMap,
    );

    _logger.debug('${toStringShort()} $fhirPath: $fhirPathResult');

    if (generation != null) {
      _cachedResult = fhirPathResult;
      _generation = generation;
    }

    return fhirPathResult;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      StringProperty('FHIRPath', fhirPath),
    );
  }

  /// Evaluates a FHIRPath expression and interprets the result as a [bool].
  ///
  /// Proper behavior is undefined: http://jira.hl7.org/browse/FHIR-33295
  /// Using singleton collection evaluation: https://hl7.org/fhirpath/#singleton-evaluation-of-collections
  Future<bool> fetchBoolValue({
    String? location,
    int? generation,
    required bool unknownValue,
  }) async {
    final fhirPathResult = await evaluate(generation: generation);

    if (fhirPathResult == null) {
      return unknownValue;
    }

    if (fhirPathResult is! List) {
      throw ArgumentError('Expected List', 'fhirPathResult');
    }

    if (fhirPathResult.isEmpty) {
      return unknownValue;
    }

    final firstResult = fhirPathResult.first;

    if (firstResult is FhirBoolean) {
      return (firstResult.value as bool?) ?? unknownValue;
    } else if (firstResult is! bool) {
      _logger.warn(
        'Questionnaire design issue: "$this" at $location results in $fhirPathResult. Expected a bool.',
      );

      return firstResult != null;
    } else {
      return firstResult;
    }
  }

  List<FhirBase> _coerceToFhirList(dynamic evaluationResult) {
    if (evaluationResult is List<FhirBase>) {
      return evaluationResult;
    } else if (evaluationResult is List) {
      return evaluationResult
          .map((value) => _coerceToFhirBase(value))
          .whereType<FhirBase>()
          .toList();
    }

    final coerced = _coerceToFhirBase(evaluationResult);

    return coerced != null ? [coerced] : <FhirBase>[];
  }

  FhirBase? _coerceToFhirBase(dynamic value) {
    if (value is FhirBase) {
      return value;
    }
    if (value is bool) {
      return value.toFhirBoolean;
    }
    if (value is int) {
      return FhirInteger(value);
    }
    if (value is double) {
      return FhirDecimal(value);
    }
    if (value is String) {
      return value.toFhirString;
    }

    return null;
  }
}
