import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:tp70/entities/matiere.dart';

Future getAllMatieres() async {
  Response response =
  await http.get(Uri.parse("http://192.168.56.1:8081/matiere/all"));
  return jsonDecode(response.body);
}

Future<void> addMatiere(Matiere matiere) async {
  await http.post(
    Uri.parse("http://192.168.56.1:8081/matiere/add"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, dynamic>{
      "intMat": matiere.intMat,
      "description": matiere.description,
    }),
  );
}

Future<void> updateMatiere(Matiere matiere) async {
  await http.put(
    Uri.parse("http://192.168.56.1:8081/matiere/update"),
    headers: {
      "Content-Type": "application/json",
    },
    body: jsonEncode(<String, dynamic>{
      "codMat": matiere.codMat,
      "intMat": matiere.intMat,
      "description": matiere.description,
    }),
  );
}

Future<void> deleteMatiere(int id) async {
  await http.delete(Uri.parse("http://192.168.56.1:8081/matiere/delete?id=$id"));
}