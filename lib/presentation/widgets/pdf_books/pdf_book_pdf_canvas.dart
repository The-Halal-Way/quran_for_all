import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../../core/localization/l10n_extensions.dart';

class PdfBookPdfCanvas extends StatelessWidget {
  const PdfBookPdfCanvas({
    super.key,
    required this.controller,
    required this.onPageChanged,
    required this.onDocumentLoaded,
    required this.onDocumentError,
  });

  final PdfControllerPinch controller;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<PdfDocument> onDocumentLoaded;
  final ValueChanged<Object> onDocumentError;

  @override
  Widget build(BuildContext context) => PdfViewPinch(
    key: ValueKey(controller),
    controller: controller,
    scrollDirection: Axis.vertical,
    maxScale: 8,
    onPageChanged: onPageChanged,
    onDocumentLoaded: onDocumentLoaded,
    onDocumentError: onDocumentError,
    backgroundDecoration: const BoxDecoration(color: Colors.white),
    builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
      options: const DefaultBuilderOptions(),
      documentLoaderBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
      pageLoaderBuilder: (_) =>
          const Center(child: CircularProgressIndicator()),
      errorBuilder: (context, _) => Center(
        child: Text(
          context.l10n.pdfBookReaderError,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
