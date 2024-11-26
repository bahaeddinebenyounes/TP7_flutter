import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tp70/service/matiereservice.dart';
import 'package:tp70/template/dialog/matieredialog.dart'; // Importer le Dialog de Matière
import 'package:tp70/template/navbar.dart';

import '../entities/matiere.dart';

class MatiereScreen extends StatefulWidget {
  const MatiereScreen({super.key});

  @override
  _MatiereScreenState createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar('Matières'), // NavBar personnalisée
      body: FutureBuilder(
        future: getAllMatieres(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return Slidable(
                  key: Key((snapshot.data[index]['codMat'])
                      .toString()), // Identifiant unique de chaque matière
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MatiereDialog(
                                  notifyParent:
                                  refresh, // Rafraîchir après modification
                                  matiere: Matiere(
                                      snapshot.data[index]['codMat'],
                                      snapshot.data[index]['intMat'],
                                      snapshot.data[index]['description']),
                                );
                              });
                        },
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Modifier',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await deleteMatiere(snapshot.data[index]
                      ['codMat']); // Supprimer la matière
                      setState(() {
                        snapshot.data.removeAt(
                            index); // Supprimer la matière de la liste
                      });
                    }),
                    children: [Container()],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Matière : "),
                                Text(
                                  snapshot.data[index]['intMat'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                                "Description : ${snapshot.data[index]['description']}"),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
                child:
                CircularProgressIndicator()); // Indicateur de chargement
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return MatiereDialog(
                  notifyParent: refresh, // Rafraîchir après ajout
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}