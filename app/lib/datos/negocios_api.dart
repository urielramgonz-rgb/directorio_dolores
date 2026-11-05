import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dominio/negocio.dart';
import '../dominio/excepciones.dart';

class NegociosApi {
  final http.Client cliente;
  final String baseUrl;

  NegociosApi(this.cliente, this.baseUrl);

  Future<List<Negocio>> listar({String? busqueda}) async {
    try {
      final uri = Uri.parse('$baseUrl/negocios').replace(
        queryParameters: busqueda == null || busqueda.isEmpty
            ? null
            : {'q': busqueda},
      );

      final respuesta = await cliente.get(uri);

      if (respuesta.statusCode != 200) {
        throw ErrorServidorException(respuesta.statusCode);
      }

      final datos = jsonDecode(respuesta.body);

      if (datos is! List) {
        throw RespuestaInvalidaException();
      }

      return datos
          .map((elemento) => Negocio.desdeJson(elemento))
          .toList();
    } on ErrorServidorException {
      rethrow;
    } on RespuestaInvalidaException {
      rethrow;
    } catch (_) {
      throw SinConexionException();
    }
  }

  Future<Negocio> crear(Negocio negocio) async {
    try {
      final respuesta = await cliente.post(
        Uri.parse('$baseUrl/negocios'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(negocio.aJson()),
      );

      if (respuesta.statusCode != 201) {
        throw ErrorServidorException(respuesta.statusCode);
      }

      return Negocio.desdeJson(jsonDecode(respuesta.body));
    } on ErrorServidorException {
      rethrow;
    } catch (_) {
      throw SinConexionException();
    }
  }

  Future<Negocio> actualizar(Negocio negocio) async {
    try {
      final respuesta = await cliente.put(
        Uri.parse('$baseUrl/negocios/${negocio.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(negocio.aJson()),
      );

      if (respuesta.statusCode != 200) {
        throw ErrorServidorException(respuesta.statusCode);
      }

      return Negocio.desdeJson(jsonDecode(respuesta.body));
    } on ErrorServidorException {
      rethrow;
    } catch (_) {
      throw SinConexionException();
    }
  }

  Future<void> eliminar(int id) async {
    try {
      final respuesta = await cliente.delete(
        Uri.parse('$baseUrl/negocios/$id'),
      );

      if (respuesta.statusCode != 200) {
        throw ErrorServidorException(respuesta.statusCode);
      }
    } on ErrorServidorException {
      rethrow;
    } catch (_) {
      throw SinConexionException();
    }
  }
}