import 'dart:convert';

import 'package:directorio_dolores/datos/negocios_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

NegociosApi apiCon(MockClient c) =>
    NegociosApi(c, 'http://prueba');

void main() {
  test('listar convierte el JSON en objetos Negocio', () async {
    final api = apiCon(MockClient((req) async {
      expect(req.method, 'GET');
      expect(req.url.path, '/negocios');

      return http.Response(
        jsonEncode([
          {'id': 1, 'nombre': 'A', 'categoria': 'X'},
          {'id': 2, 'nombre': 'B', 'categoria': 'Y'},
        ]),
        200,
      );
    }));

    final lista = await api.listar();

    expect(lista.length, 2);
    expect(lista.first.nombre, 'A');
  });
}