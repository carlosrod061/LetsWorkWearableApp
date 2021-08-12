import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkwearableapp/Models/tarea_model.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Tareas extends StatefulWidget {
  String userNameG = "";
  String familyCodeG = "";
  Tareas(String username, String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _TareasState createState() => _TareasState();
}

class _TareasState extends State<Tareas> {
  List<Tarea> _tareasList = [];

  _showSnackBarExito(message, String tituloTarea, String accion) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _tareasList = [];
    Navigator.pop(context);
    loadTareas();
    _insertarNotificacion(
        this.widget.userNameG, tituloTarea, this.widget.familyCodeG, accion);
  }

  _insertarNotificacion(
      String userName, String tituloTarea, String familyCode, String accion) {
    String mensaje = "";
    switch (accion) {
      case 'Modificacion':
        mensaje = tituloTarea + " fue modificada por " + userName;
        break;
      case 'Creacion':
        mensaje = tituloTarea + " fue creada por " + userName;
        break;
      case 'Completada':
        mensaje = tituloTarea + " fue completada por " + userName;
        break;
      default:
        mensaje = "";
        break;
    }

    try {
      CollectionReference notificaciones =
          FirebaseFirestore.instance.collection('notificaciones');
      notificaciones.add({
        'categoriaNotificacion': 'Tareas',
        'contenidoNotificacion': mensaje,
        'familyCode': familyCode,
      });
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error al registrarse");
    }
  }

  _showSnackBarFallo(message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ));
  }

  @override
  void initState() {
    super.initState();
    loadTareas();
  }

  void anadirTarea(Tarea tarea) {
    _tareasList.add(tarea);
  }

  loadTareas() {
    try {
      FirebaseFirestore.instance
          .collection('tareas')
          .where('familyCode', isEqualTo: this.widget.familyCodeG.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            Tarea tareaL = new Tarea();
            tareaL.tituloTarea = doc["tituloTarea"];
            tareaL.descripcionTarea = doc["descripcionTarea"];
            tareaL.fechaVencimiento = doc["fechaVencimiento"];
            tareaL.categoriaTarea = doc["categoriaTarea"];
            tareaL.creadorTarea = doc["creadorTarea"];
            tareaL.familyCode = doc["familyCode"];
            tareaL.finalizadaTarea = doc["finalizadaTarea"];
            if (tareaL.finalizadaTarea == "No") {
              anadirTarea(tareaL);
            }
          });
          setState(() {});
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF006064),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _tareasList.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      color: Colors.purple,
                      // Con esta propiedad modificamos la forma de nuestro card
                      // Aqui utilizo RoundedRectangleBorder para proporcionarle esquinas circulares al Card
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),

                      // Con esta propiedad agregamos margen a nuestro Card
                      // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
                      margin: EdgeInsets.all(10),

                      // Con esta propiedad agregamos elevación a nuestro card
                      // La sombra que tiene el Card aumentará
                      elevation: 10,

                      // La propiedad child anida un widget en su interior
                      // Usamos columna para ordenar un ListTile y una fila con botones
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.task,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_tareasList[index].tituloTarea,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_tareasList[index].descripcionTarea,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(_tareasList[index].fechaVencimiento,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10))
                            ],
                          ),
                          // Usamos una fila para ordenar los botones del card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ), //Que contienen los botones para cancelar o realizar la operación
                                  onPressed: () {
                                    try {
                                      FirebaseFirestore.instance
                                          .collection('tareas')
                                          .where('tituloTarea',
                                              isEqualTo: _tareasList[index]
                                                  .tituloTarea)
                                          .limit(1)
                                          .get()
                                          .then((QuerySnapshot querySnapshot) {
                                        if (querySnapshot.size > 0) {
                                          //Verificacion de familia
                                          querySnapshot.docs.forEach((doc) {
                                            actualizarTarea(
                                                doc.id,
                                                _tareasList[index].tituloTarea,
                                                _tareasList[index]
                                                    .descripcionTarea,
                                                _tareasList[index]
                                                    .categoriaTarea,
                                                _tareasList[index]
                                                    .fechaVencimiento,
                                                "Si",
                                                doc["familyCode"],
                                                doc["creadorTarea"],
                                                "Tarea Finalizada");
                                          });
                                        }
                                      });
                                    } on FirebaseException catch (e) {
                                      print("ERROR" + e.toString());
                                    }
                                  }),
                            ],
                          )
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ));
  }

  actualizarTarea(
      String tareaID,
      String tituloTarea,
      String descripcionTarea,
      String categoriaTarea,
      String fechaTarea,
      String tareaFinalizada,
      String familyCode,
      String creadorTarea,
      String mensaje) {
    String accion = "";
    if (tareaFinalizada == "Si") {
      accion = "Completada";
    } else {
      accion = "Modificacion";
    }

    try {
      //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
      CollectionReference tareas =
          FirebaseFirestore.instance.collection('tareas');
      tareas.doc(tareaID).set({
        'categoriaTarea': categoriaTarea,
        'creadorTarea': creadorTarea,
        'descripcionTarea': descripcionTarea,
        'familyCode': familyCode,
        'fechaVencimiento': fechaTarea,
        'finalizadaTarea': tareaFinalizada,
        'tituloTarea': tituloTarea,
      }).then((value) => _showSnackBarExito(mensaje, tituloTarea, accion));
    } on FirebaseException catch (e) {
      _showSnackBarFallo("Error verifiquelo");
    }
  }
}
