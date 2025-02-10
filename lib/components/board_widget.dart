import 'package:campo_minado_app/components/field_widget.dart';
import 'package:campo_minado_app/core/models/board.dart';
import 'package:campo_minado_app/core/models/field.dart';
import 'package:flutter/material.dart';

class BoardWidget extends StatelessWidget {
  final Board board;
  final void Function(Field) onOpen;
  final void Function(Field) onToggleMark;

  const BoardWidget({
    required this.board,
    required this.onOpen,
    required this.onToggleMark,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: board.columns,
      children: board.fields.map((field) {
        return FieldWidget(
          field: field,
          onOpen: onOpen,
          onToggleMark: onToggleMark,
        );
      }).toList(),
    );
  }
}
