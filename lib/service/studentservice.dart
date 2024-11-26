import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/student.dart';

Future<List<dynamic>> getAllStudent() async {
  Response response =
  await http.get(Uri.parse("http://192.168.56.1:8081/etudiant/all"));
  return List<dynamic>.from(jsonDecode(response.body));
}

Future deleteStudent(int id) {
  return http
      .delete(Uri.parse("http://192.168.56.1:8081/etudiant/delete?id=$id"));
}
Future<List> fetchStudentsByDate(String date) async {
  // Replace with your backend endpoint
  final response = await http.get(Uri.parse('http://192.168.56.1:8081/etudiant/byDateNais?date=$date'));
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception("Failed to load students by date");
  }
}

Future addStudent(Student student) async {
  print(student.dateNais);
  Response response =
  await http.post(Uri.parse("http://192.168.56.1:8081/etudiant/add"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(<String, String>{
        "nom": student.nom,
        "prenom": student.prenom,
        "dateNais": DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(student.dateNais))
      }));
  return response.body;
}

Future updateStudent(Student student) async {
  Response response =
  await http.put(Uri.parse("http://192.168.56.1:8081/etudiant/update"),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode(<String, dynamic>{
        "id": student.id,
        "nom": student.nom,
        "prenom": student.prenom,
        "dateNais": DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(student.dateNais))
      }));
  return response.body;
}

Future<List<dynamic>> fetchStudentsByClass(String? classId) async {
  final url = classId == null
      ? "http://192.168.56.1:8081/etudiant/all"
      : "http://192.168.56.1:8081/etudiant/byClass?classeId=$classId";
  final response = await http.get(Uri.parse(url));
  return List<dynamic>.from(jsonDecode(response.body));
}

Future<List<dynamic>> getAllClasses() async {
  final response =
  await http.get(Uri.parse("http://192.168.56.1:8081/class/all"));

  // Affichez la réponse brute pour vérifier son format
  print("Réponse brute : ${response.body}");

  final data = jsonDecode(response.body);

  // Si la réponse est une liste directement, retournez-la
  if (data is List) {
    return List<dynamic>.from(data);
  } else {
    throw Exception("Format de réponse incorrect pour les classes");
  }

}