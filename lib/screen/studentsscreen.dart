import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:tp70/entities/student.dart';
import 'package:tp70/service/studentservice.dart';
import 'package:tp70/template/navbar.dart';

import '../template/dialog/studentdialog.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final double _currentFontSize = 0;
  String? selectedClass; // Selected class
  String? searchDate; // Search date in string format
  List<dynamic> classes = []; // List of available classes
  Future<List>? studentsFuture; // Future for students

  final TextEditingController dateController = TextEditingController(); // Controller for the date input

  @override
  void initState() {
    super.initState();
    fetchClasses(); // Load classes on init
    studentsFuture = getAllStudent(); // Load all students by default
    selectedClass = "3";
  }

  // Fetch classes from the service
  void fetchClasses() async {
    classes = await getAllClasses();
    setState(() {});
  }

  // Refresh the students list based on selected class or search date
  void refreshStudents() {
    if (searchDate != null && searchDate!.isNotEmpty) {
      studentsFuture = fetchStudentsByDate(searchDate!); // Fetch by date
    } else {
      studentsFuture = fetchStudentsByClass(selectedClass); // Fetch by class
    }
    setState(() {});
  }
  void showDatePickerDialog() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest date selectable
      lastDate: DateTime(2100), // Latest date selectable
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // Customize calendar theme here
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      // Update the dateController and searchDate with the selected date
      setState(() {
        searchDate = DateFormat('dd-MM-yyyy').format(selectedDate);
        dateController.text = searchDate!;
      });

      refreshStudents(); // Trigger the search function
    }
  }

  // Clear the search and reload students by class
  void clearSearch() {
    setState(() {
      searchDate = null;
      dateController.clear();
      refreshStudents(); // Reload students without filters
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Etudiant'),
      body: Column(
        children: [
          // Search field for date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Rechercher par date (dd-MM-yyyy)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      searchDate = value; // Update search date
                    },
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: refreshStudents,
                  child: const Text("Rechercher"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: clearSearch,
                  child: const Text("Effacer"),
                ),
              ],
            ),
          ),

          // Dropdown for classes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              hint: const Text("Sélectionnez une classe"),
              value: selectedClass,
              items: classes.map<DropdownMenuItem<String>>((classItem) {
                return DropdownMenuItem<String>(
                  value: classItem['codClass'].toString(),
                  child: Text(
                      classItem['nomClass']), // Display the class name
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
                refreshStudents(); // Refresh students
              },
              isExpanded: true,
            ),
          ),

          // Students list
          Expanded(
            child: FutureBuilder(
              future: studentsFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        key: Key((snapshot.data[index]['id']).toString()),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AddStudentDialog(
                                        notifyParent: refreshStudents,
                                        student: Student(
                                            snapshot.data[index]['dateNais'],
                                            snapshot.data[index]['nom'],
                                            snapshot.data[index]['prenom'],
                                            snapshot.data[index]['id']),
                                      );
                                    });
                              },
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          dismissible: DismissiblePane(onDismissed: () async {
                            await deleteStudent(snapshot.data[index]['id']);
                            setState(() {
                              snapshot.data.removeAt(index);
                            });
                          }),
                          children: [Container()],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40,
                              margin: const EdgeInsets.only(bottom: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text("Nom et Prénom : "),
                                      Text(
                                        snapshot.data[index]['nom'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(snapshot.data[index]['prenom']),
                                    ],
                                  ),
                                  Text(
                                    'Date de Naissance :${DateFormat("dd-MM-yyyy").format(
                                        DateTime.parse(snapshot.data[index]
                                        ['dateNais']))}',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Aucun étudiant trouvé."));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddStudentDialog(
                  notifyParent: refreshStudents,
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
