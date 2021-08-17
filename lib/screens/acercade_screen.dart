import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:letsworkwearableapp/Models/notificaciones_model.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class Acercade extends StatefulWidget {
  String userNameG = "";
  Acercade(String username) {
    this.userNameG = username;
  }

  @override
  _AcercadeState createState() => _AcercadeState();
}

class _AcercadeState extends State<Acercade> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF006064),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

            // Con esta propiedad agregamos margen a nuestro Card
            // El margen es la separación entre widgets o entre los bordes del widget padre e hijo
            margin: EdgeInsets.all(10),

            // Con esta propiedad agregamos elevación a nuestro card
            // La sombra que tiene el Card aumentará
            elevation: 10,
            color: Color(0xFF0097A7),
            child: Column(
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
                  title: Text(
                    "LetsWorkWearableApp",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                  subtitle: Text(
                    "\n ° Nombre de la aplicación: \n -Lets Work at Home App- \n \n" +
                        "° Nombre del Autor: \n -Carlos Joel Rodriguez Mares- \n\n ° Grupo: \n -GDGS1091-E- \n\n ° Asignatura: \n -Desarrollo para Dispositivos Inteligentes- \n\n" +
                        "° Institución: \n -Universidad Tecnologica del Norte de Guanajuato-\n",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 7,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  height: 60,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Color(0xFF0097A7),
                    elevation: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(this.widget.userNameG)));
                            },
                            child: Icon(Icons.home, color: Colors.black),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.white)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
