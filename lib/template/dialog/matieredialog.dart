import 'package:flutter/material.dart';
import 'package:tp70/entities/matiere.dart';
import 'package:tp70/service/matiereservice.dart';

class MatiereDialog extends StatefulWidget {
  final Function()? notifyParent;
  final Matiere? matiere;

  const MatiereDialog({Key? key, this.notifyParent, this.matiere}) : super(key: key);

  @override
  _MatiereDialogState createState() => _MatiereDialogState();
}

class _MatiereDialogState extends State<MatiereDialog> {
  TextEditingController intituleCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();

  String title = "Ajouter Matière";
  bool modif = false;
  late int idMatiere;

  @override
  void initState() {
    super.initState();
    if (widget.matiere != null) {
      modif = true;
      title = "Modifier Matière";
      intituleCtrl.text = widget.matiere!.intMat;
      descriptionCtrl.text = widget.matiere!.description;
      idMatiere = widget.matiere!.codMat;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            TextFormField(
              controller: intituleCtrl,
              validator: (value) =>
              value!.isEmpty ? "Champs obligatoire" : null,
              decoration: const InputDecoration(labelText: "Intitulé"),
            ),
            TextFormField(
              controller: descriptionCtrl,
              validator: (value) =>
              value!.isEmpty ? "Champs obligatoire" : null,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!modif) {
                  await addMatiere(
                      Matiere(0, intituleCtrl.text, descriptionCtrl.text));
                } else {
                  await updateMatiere(Matiere(
                      idMatiere, intituleCtrl.text, descriptionCtrl.text));
                }
                widget.notifyParent?.call();
                Navigator.pop(context);
              },
              child: Text(modif ? "Modifier" : "Ajouter"),
            ),
          ],
        ),
      ),
    );
  }
}