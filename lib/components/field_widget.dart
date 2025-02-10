import 'package:campo_minado_app/core/models/field.dart';
import 'package:flutter/material.dart';

class FieldWidget extends StatelessWidget {
  final Field field;
  final void Function(Field) onOpen;
  final void Function(Field) onToggleMark;

  const FieldWidget({
    required this.field,
    required this.onOpen,
    required this.onToggleMark,
    super.key,
  });

  Widget _getImage() {
    int mines = field.minedNeighborsCount;

    // Campo aberto e minado e explodido
    if (field.opened && field.mined && field.exploded) {
      return Image.asset('assets/images/bomba_0.jpeg');
    }
    // Campo aberto e minado e não explodido
    else if (field.opened && field.mined) {
      return Image.asset('assets/images/bomba_1.jpeg');
    }
    // Campo aberto COM ou SEM minas visinhas
    else if (field.opened) {
      return Image.asset('assets/images/aberto_$mines.jpeg');
    }
    // Campo marcado
    else if (field.marked) {
      return Image.asset('assets/images/bandeira.jpeg');
    }
    // Campo fechado
    else {
      return Image.asset('assets/images/fechado.jpeg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onOpen(field),
      onLongPress: () => onToggleMark(field),
      child: _getImage(),
    );
  }
}
