import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkwearableapp/Models/notificaciones_model.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Notificaciones extends StatefulWidget {
  String userNameG = "";
  String familyCodeG = "";
  Notificaciones(String username, String familyCode) {
    this.userNameG = username;
    this.familyCodeG = familyCode;
  }

  @override
  _NotificacionesState createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {
  List<Notificacion> _notificacionesList = [];

  _showSnackBarExito(message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.green));
    _notificacionesList = [];
    Navigator.pop(context);
    loadNotificaciones();
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
    loadNotificaciones();
  }

  void anadirNotificacion(Notificacion notificacion) {
    _notificacionesList.add(notificacion);
  }

  loadNotificaciones() {
    try {
      FirebaseFirestore.instance
          .collection('notificaciones')
          .where('familyCode', isEqualTo: this.widget.familyCodeG.toString())
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            Notificacion notificacionL = new Notificacion();
            notificacionL.notificacionID = doc.id;
            notificacionL.categoriaNotificacion = doc["categoriaNotificacion"];
            notificacionL.contenidoNotificacion = doc["contenidoNotificacion"];
            notificacionL.familyCode = doc["familyCode"];
            anadirNotificacion(notificacionL);
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
                  itemCount: _notificacionesList.length,
                  itemBuilder: (context, int index) {
                    return Card(
                      color: Colors.orange[400],
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
                                Icons.notification_important,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                  _notificacionesList[index]
                                      .categoriaNotificacion,
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15))
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                _notificacionesList[index]
                                    .contenidoNotificacion,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10),
                              )
                            ],
                          ),
                          // Usamos una fila para ordenar los botones del card
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ), //Que
                                onPressed: () async {
                                  try {
                                    //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
                                    CollectionReference users =
                                        FirebaseFirestore.instance
                                            .collection('notificaciones');
                                    users
                                        .doc(_notificacionesList[index]
                                            .notificacionID)
                                        .delete()
                                        .then((value) => _showSnackBarExito(
                                            "Notificacion eliminada para todos."));
                                  } on FirebaseException catch (e) {
                                    _showSnackBarFallo("Error verifiquelo");
                                  }
                                },
                              ),
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

  _deleteNotificacionDialog(BuildContext context, notificacionID) {
    //Dialogo para borrar un elemento
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            // Se genera a partir de sus partes
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Se coloca estilo para mejorar la experiencia
                  primary: Colors.green, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancelar'),
              ),
              IconButton(
                // Tanto el botón de editar y borrar mostrarán un cuadro de dialogo
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ), //Que
                onPressed: () async {
                  try {
                    //FALTAN LAS PRUEBAS PARA LAS VALIDACIONES DE QUE EL CODIGO DE LA FAMILIA SEA CORRECTO
                    CollectionReference users =
                        FirebaseFirestore.instance.collection('notificaciones');
                    users.doc(notificacionID).delete().then((value) =>
                        _showSnackBarExito(
                            "Notificacion eliminada para todos."));
                  } on FirebaseException catch (e) {
                    _showSnackBarFallo("Error verifiquelo");
                  }
                },
              ),
            ],
            title: Text(
                "¿Estas seguro que deseas eliminar esta notificacion para todos?"),
          );
        });
  }
}
