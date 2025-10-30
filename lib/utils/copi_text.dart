
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopiText extends StatefulWidget {
  final String label;
  final String value;
  final bool showIconAndAnimation;

  const CopiText({
    super.key,
    required this.label,
    required this.value,
    this.showIconAndAnimation = false,
  });

  @override
  State<CopiText> createState() => _CopiTextState();
}

class _CopiTextState extends State<CopiText> {
  bool _copiado = false;

  void _copiar() {
    Clipboard.setData(ClipboardData(text: widget.value));

    if (widget.showIconAndAnimation) {
      setState(() => _copiado = true);
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) setState(() => _copiado = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textWidget = Flexible(
      child: RichText(
        maxLines: 1, // solo una línea
        overflow: TextOverflow.ellipsis, // agrega "..."
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: '${widget.label}: ',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: widget.value,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );

    if (!widget.showIconAndAnimation) {
      return InkWell(
        onTap: widget.showIconAndAnimation == false ? null :  _copiar,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            textWidget,
          ],
        ),
      );
    }

    return InkWell(
      onTap: widget.showIconAndAnimation == false ? null : _copiar,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          textWidget,
          const SizedBox(width: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _copiado
                ? const Icon(Icons.check, key: ValueKey('check'), size: 18, color: Colors.green)
                : const Icon(Icons.copy, key: ValueKey('copy'), size: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
