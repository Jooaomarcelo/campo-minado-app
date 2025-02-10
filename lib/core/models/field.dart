import 'explosion_exception.dart';

class Field {
  final int row;
  final int column;
  final List<Field> neighbors = [];

  bool _opened = false;
  bool _marked = false;
  bool _mined = false;
  bool _exploded = false;

  Field({
    required this.row,
    required this.column,
  });

  bool get safeNeighborhood => neighbors.every((neighbor) => !neighbor._mined);

  bool get opened => _opened;

  bool get marked => _marked;

  bool get mined => _mined;

  bool get exploded => _exploded;

  void addNeighbor(Field neighbor) {
    final deltaRow = (row - neighbor.row).abs();
    final deltaColumn = (column - neighbor.column).abs();

    if (deltaRow == 0 && deltaColumn == 0) {
      return;
    }

    if (deltaRow <= 1 && deltaColumn <= 1) {
      neighbors.add(neighbor);
    }
  }

  void open() {
    if (_opened) {
      return;
    }

    _opened = true;

    if (_mined) {
      _exploded = true;
      throw ExplosionException();
    }

    if (safeNeighborhood) {
      for (var neighbor in neighbors) {
        neighbor.open();
      }
    }
  }

  void revealMine() {
    if (_mined) {
      _opened = true;
    }
  }

  void mine() {
    _mined = true;
  }

  void toggleMark() {
    _marked = !_marked;
  }

  bool get finished {
    final minedAndMarked = mined && marked;
    final safeAndOpened = !mined && opened;

    return minedAndMarked || safeAndOpened;
  }

  int get minedNeighborsCount {
    return neighbors.where((neighbor) => neighbor.mined).length;
  }

  void reset() {
    _opened = false;
    _marked = false;
    _mined = false;
    _exploded = false;
  }
}
