import 'package:campo_minado_app/core/models/board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Board', () {
    test('Win game', () {
      Board board = Board(
        rows: 2,
        columns: 2,
        minesCount: 0,
      );

      board.fields[0].mine();
      board.fields[3].mine();

      board.fields[1].open();

      board.fields[0].toggleMark();
      board.fields[3].toggleMark();

      board.fields[2].open();

      expect(board.finished, isTrue);
    });

    test('Lose game', () {
      Board board = Board(
        rows: 2,
        columns: 2,
        minesCount: 0,
      );

      board.fields[0].mine();
      board.fields[3].mine();

      expect(board.fields[0].open, throwsException);
    });
  });
}
