import 'dart:math';

import 'package:campo_minado_app/core/models/field.dart';

class Board {
  final int rows;
  final int columns;
  final int minesCount;
  bool _gameStarted = false;

  final List<Field> _fields = [];

  Board({
    required this.rows,
    required this.columns,
    required this.minesCount,
  }) {
    _createFields();
    _connectNeighbors();
    _sortMines();
  }

  List<Field> get fields => _fields;

  bool get gameStarted => _gameStarted;

  void start() {
    _gameStarted = true;
  }

  void _createFields() {
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        _fields.add(Field(row: row, column: column));
      }
    }
  }

  void _connectNeighbors() {
    for (var field in _fields) {
      for (var neighbor in _fields) {
        field.addNeighbor(neighbor);
      }
    }
  }

  void _sortMines() {
    int sortedMines = 0;

    if (minesCount > rows * columns) {
      return;
    }

    while (sortedMines < minesCount) {
      final int i = Random().nextInt(_fields.length);

      if (!_fields[i].mined) {
        sortedMines++;
        _fields[i].mine();
      }
    }
  }

  void revealMines() {
    for (var field in _fields) {
      if (field.mined) {
        field.revealMine();
      }
    }
  }

  bool get finished {
    return _fields.every((field) => field.finished);
  }

  void restart() {
    for (var field in _fields) {
      field.reset();
    }

    _gameStarted = false;

    _sortMines();
  }
}
