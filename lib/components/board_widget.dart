import 'package:campo_minado_app/components/field_widget.dart';
import 'package:campo_minado_app/core/models/board.dart';
import 'package:campo_minado_app/core/models/field.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final void Function(Field) onOpen;
  final void Function(Field) onToggleMark;
  final GlobalKey tutorialFieldKey;

  const BoardWidget({
    required this.board,
    required this.onOpen,
    required this.onToggleMark,
    required this.tutorialFieldKey,
    super.key,
  });

  // Criando uma chave global para o campo do meio

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: board.columns,
      children: board.fields.asMap().entries.map((entry) {
        final index = entry.key;
        final field = entry.value;

        return FieldWidget(
          key: index == (board.columns * board.rows / 2).floor()
              ? tutorialFieldKey
              : null,
          field: field,
          onOpen: onOpen,
          onToggleMark: onToggleMark,
        );
      }).toList(),
    );
  }
}
