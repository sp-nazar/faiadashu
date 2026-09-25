import 'dart:convert';

import 'package:faiadashu/questionnaires/model/item/answer/src/answer_model.dart';
import 'package:faiadashu/questionnaires/model/src/rendering_string.dart';
import 'package:fhir/r4.dart';

class AttachmentAnswerModel extends AnswerModel<Attachment, Attachment> {
  AttachmentAnswerModel(super.responseItemModel);

  @override
  RenderingString get display {
    final attachment = value;

    if (attachment == null) {
      return RenderingString.nullText;
    }

    final title = attachment.title;

    if (title != null && title.isNotEmpty) {
      return RenderingString.fromText(title);
    }

    final contentType = attachment.contentType?.value;

    if (contentType != null && contentType.isNotEmpty) {
      return RenderingString.fromText(contentType);
    }

    final url = attachment.url?.toString();

    if (url != null && url.isNotEmpty) {
      return RenderingString.fromText(url);
    }

    return RenderingString.fromText('Attachment');
  }

  @override
  QuestionnaireResponseAnswer? createFhirAnswer(
    List<QuestionnaireResponseItem>? items,
  ) {
    final attachment = value;

    if (attachment == null) {
      return null;
    }

    return QuestionnaireResponseAnswer(
      valueAttachment: attachment,
      item: items,
    );
  }

  @override
  bool get isEmpty {
    final attachment = value;

    if (attachment == null) {
      return true;
    }

    return attachment.data == null && attachment.url == null;
  }

  @override
  void populate(QuestionnaireResponseAnswer answer) {
    value = answer.valueAttachment;
  }

  @override
  void populateFromExpression(dynamic evaluationResult) {
    if (evaluationResult == null) {
      value = null;
      return;
    }

    if (evaluationResult is Attachment) {
      value = evaluationResult;
      return;
    }

    if (evaluationResult is Map<String, dynamic>) {
      value = Attachment.fromJson(evaluationResult);
      return;
    }

    throw ArgumentError.value(
      evaluationResult,
      'evaluationResult',
      'Expected Attachment or Attachment JSON.',
    );
  }

  @override
  String? validateInput(Attachment? inputValue) {
    return validateValue(inputValue);
  }

  @override
  String? validateValue(Attachment? inputValue) {
    if (inputValue == null) {
      return null;
    }

    if (inputValue.data != null && inputValue.contentType?.value == null) {
      return 'Attachment content type is required for inline data.';
    }

    return null;
  }
}

class AttachmentFactory {
  const AttachmentFactory._();

  static Attachment fromBytes({
    required List<int> bytes,
    required String contentType,
    String? title,
  }) {
    return Attachment(
      contentType: FhirCode(contentType),
      data: FhirBase64Binary(base64Encode(bytes)),
      size: FhirUnsignedInt(bytes.length),
      title: title,
    );
  }

  static Attachment fromString({
    required String value,
    required String contentType,
    String? title,
  }) {
    return fromBytes(
      bytes: utf8.encode(value),
      contentType: contentType,
      title: title,
    );
  }

  static Attachment fromJson({
    required Map<String, dynamic> value,
    String? title,
  }) {
    return fromString(
      value: jsonEncode(value),
      contentType: 'application/json',
      title: title,
    );
  }
}

extension AttachmentDataExtension on Attachment {
  List<int>? get decodedData {
    final encoded = data?.value;
    if (encoded == null) {
      return null;
    }
    return base64Decode(encoded);
  }

  String? get decodedString {
    final bytes = decodedData;
    if (bytes == null) {
      return null;
    }
    return utf8.decode(bytes);
  }

  Map<String, dynamic>? get decodedJson {
    if (contentType?.value != 'application/json') {
      return null;
    }

    final string = decodedString;

    if (string == null) {
      return null;
    }

    final decoded = jsonDecode(string);

    return decoded is Map<String, dynamic> ? decoded : null;
  }
}
