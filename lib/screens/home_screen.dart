import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:letsworkwearableapp/screens/acercade_screen.dart';
import 'package:letsworkwearableapp/screens/tareas_screen.dart';
import 'login_screen.dart';
import 'notificaciones_screen.dart';

class Home extends StatefulWidget {
  String userNameG = "";
  String familyCode = "";
  Home(String username) {
    this.userNameG = username;
    try {
      FirebaseFirestore.instance
          .collection('users')
          .where('userName', isEqualTo: username.toString())
          .limit(1)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          //Verificacion de familia
          querySnapshot.docs.forEach((doc) {
            this.familyCode = doc["familyCode"];
          });
        }
      });
    } on FirebaseException catch (e) {
      print("ERROR" + e.toString());
    }
  }

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF006064),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Card(
                color: Color(0xFF0097A7),
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
                        Icon(Icons.notification_important, color: Colors.yellow)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Notificaciones",
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => {
                                  if (this.widget.familyCode == "vacio")
                                    {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "No cuentas con una familia asignada aún"),
                                              backgroundColor: Colors.red))
                                    }
                                  else
                                    {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Notificaciones(
                                                      this.widget.userNameG,
                                                      this.widget.familyCode)))
                                    }
                                },
                            child: Text('Ir'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green)),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xFF0097A7),
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
                        Icon(Icons.task_alt, color: Colors.orange)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Tareas", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Tareas(
                                              this.widget.userNameG,
                                              this.widget.familyCode)))
                                },
                            child: Text('Ir'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green)),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xFF0097A7),
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
                      children: <Widget>[Icon(Icons.info, color: Colors.white)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Acerca de", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Acercade(this.widget.userNameG)))
                                },
                            child: Text('Ir'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green)),
                      ],
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xFF0097A7),
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
                        Icon(Icons.exit_to_app, color: Colors.red)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Salir", style: TextStyle(color: Colors.white))
                      ],
                    ),
                    // Usamos una fila para ordenar los botones del card
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () => {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(builder: (context) {
                                    return Login();
                                  }), (Route<dynamic> route) => false)
                                },
                            child: Text('Salir'),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.red)),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
