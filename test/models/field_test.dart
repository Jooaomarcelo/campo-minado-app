import 'package:campo_minado_app/core/models/field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Field', () {
    test('Open Field WITH Explosion', () {
      final field = Field(row: 0, column: 0);
      field.mine();
      expect(field.open, throwsException);
    });

    test('Open Field WITHOUT Explosion', () {
      final field = Field(row: 0, column: 0);
      field.open();
      expect(field.opened, isTrue);
    });

    test('Add NON Neighbor', () {
      Field c1 = Field(row: 0, column: 0);
      Field c2 = Field(row: 1, column: 3);

      c1.addNeighbor(c2);

      expect(c1.neighbors.isEmpty, isTrue);
    });

    test('Add Neighbor', () {
      final field1 = Field(row: 0, column: 0);
      final field2 = Field(row: 1, column: 0);
      final field3 = Field(row: 1, column: 1);
      final field4 = Field(row: 0, column: 1);

      field1.addNeighbor(field2);
      field1.addNeighbor(field3);
      field1.addNeighbor(field4);

      expect(field1.neighbors.length, 3);
    });

    test('Mines in Neighborhood', () {
      final field1 = Field(row: 0, column: 0);
      final field2 = Field(row: 1, column: 0);

      final field3 = Field(row: 1, column: 1);
      final field4 = Field(row: 0, column: 1);

      field2.mine();
      field3.mine();

      field1.addNeighbor(field2);
      field1.addNeighbor(field3);
      field1.addNeighbor(field4);

      expect(field1.minedNeighborsCount, 2);
    });
  });
}
