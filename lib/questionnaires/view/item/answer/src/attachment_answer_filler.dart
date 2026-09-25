import 'dart:async';

import 'package:faiadashu/questionnaires/model/item/answer/src/attachment_answer_model.dart';
import 'package:faiadashu/questionnaires/view/item/answer/src/questionnaire_answer_filler.dart';
import 'package:fhir/r4.dart';
import 'package:flutter/material.dart';

typedef AttachmentPicker = Future<Attachment?> Function(
  BuildContext context,
  Attachment? currentValue,
);

typedef AttachmentOpener = FutureOr<void> Function(
  BuildContext context,
  Attachment attachment,
);

class AttachmentAnswerFiller extends QuestionnaireAnswerFiller {
  AttachmentAnswerFiller(
    super.answerModel, {
    required this.pickAttachment,
    this.openAttachment,
    this.addLabel = 'Add attachment',
    this.replaceLabel = 'Replace',
    this.removeLabel = 'Remove',
    super.key,
  });

  final AttachmentPicker pickAttachment;
  final AttachmentOpener? openAttachment;

  final String addLabel;
  final String replaceLabel;
  final String removeLabel;

  @override
  State<AttachmentAnswerFiller> createState() => _AttachmentAnswerFillerState();
}

class _AttachmentAnswerFillerState extends QuestionnaireAnswerFillerState<
    Attachment, AttachmentAnswerFiller, AttachmentAnswerModel> {
  bool _isPicking = false;

  @override
  void postInitState() {}

  Future<void> _pickAttachment() async {
    if (_isPicking || !answerModel.isControlEnabled) {
      return;
    }

    setState(() {
      _isPicking = true;
    });

    try {
      final attachment = await widget.pickAttachment(
        context,
        answerModel.value,
      );

      if (!mounted || attachment == null) {
        return;
      }

      final validationError = answerModel.validateInput(attachment);

      if (validationError != null) {
        answerModel.errorText = validationError;
        return;
      }

      answerModel.value = attachment;
      answerModel.errorText = null;
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  void _removeAttachment() {
    if (!answerModel.isControlEnabled) {
      return;
    }

    answerModel.value = null;
    answerModel.errorText = null;
  }

  Future<void> _openAttachment() async {
    final attachment = answerModel.value;
    final opener = widget.openAttachment;

    if (attachment == null || opener == null) {
      return;
    }

    await opener(context, attachment);
  }

  @override
  Widget createInputControl() {
    final attachment = answerModel.value;

    if (attachment == null) {
      return _buildEmpty();
    }

    return _buildAttachment(attachment);
  }

  Widget _buildEmpty() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: OutlinedButton.icon(
          focusNode: firstFocusNode,
          onPressed: answerModel.isControlEnabled && !_isPicking
              ? _pickAttachment
              : null,
          icon: _isPicking
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.attach_file),
          label: Text(widget.addLabel),
        ),
      ),
    );
  }

  Widget _buildAttachment(Attachment attachment) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                _iconForContentType(
                  attachment.contentType?.value,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _AttachmentInfo(
                  attachment: attachment,
                  onTap: widget.openAttachment != null ? _openAttachment : null,
                ),
              ),
              if (answerModel.isControlEnabled) ...[
                const SizedBox(width: 8),
                IconButton(
                  tooltip: widget.replaceLabel,
                  onPressed: _isPicking ? null : _pickAttachment,
                  icon: _isPicking
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.refresh),
                ),
                IconButton(
                  tooltip: widget.removeLabel,
                  onPressed: _isPicking ? null : _removeAttachment,
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForContentType(String? contentType) {
    if (contentType == null) {
      return Icons.attach_file;
    }

    if (contentType.startsWith('image/')) {
      return Icons.image_outlined;
    }

    if (contentType.startsWith('video/')) {
      return Icons.video_file_outlined;
    }

    if (contentType.startsWith('audio/')) {
      return Icons.audio_file_outlined;
    }

    if (contentType == 'application/pdf') {
      return Icons.picture_as_pdf_outlined;
    }

    if (contentType == 'application/json') {
      return Icons.data_object;
    }

    if (contentType.startsWith('text/')) {
      return Icons.description_outlined;
    }

    return Icons.insert_drive_file_outlined;
  }
}

class _AttachmentInfo extends StatelessWidget {
  const _AttachmentInfo({
    required this.attachment,
    this.onTap,
  });

  final Attachment attachment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final title = attachment.title;
    final contentType = attachment.contentType?.value;
    final size = attachment.size?.value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title?.isNotEmpty == true ? title! : 'Attachment',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (contentType != null || size != null) ...[
              const SizedBox(height: 2),
              Text(
                [
                  if (contentType != null) contentType,
                  if (size != null) _formatBytes(size),
                ].join(' • '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  static String _formatBytes(num bytes) {
    final value = bytes.toDouble();

    if (value < 1024) {
      return '${value.round()} B';
    }

    if (value < 1024 * 1024) {
      return '${(value / 1024).toStringAsFixed(1)} KB';
    }

    return '${(value / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
