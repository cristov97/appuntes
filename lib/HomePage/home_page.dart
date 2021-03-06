import 'package:flutter/material.dart';

import 'package:appuntes/ListaDeArchivos/lista_archivos.dart';
import '../mis_datos.dart';
import 'Comunidades/lista_comunidades.dart';
import 'Comunidades/personalizar_comunidad.dart';
import 'mis_apuntes_page.dart';
import 'mis_comunidades_page.dart';
import 'notificaciones_page.dart';
import 'search.dart';

class MyHomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{

  int _itemActual = 0;
  MaterialColor itemColor;
  FocusNode _mainPag;

  @override
  void initState() { 
    super.initState();
    _mainPag = FocusNode();
  }

  @override
  void dispose() {
    _mainPag.dispose();
    super.dispose();
  }

  final botones = [
    Archivos(),
    Comunidades()
  ];

  final TextStyle titleStyle = TextStyle(
    color: Colors.white,
    fontSize: 25,
  );

  final Icon _iconFloatingIconButton = Icon(
    Icons.add,
    color: Colors.white
  );

  @override
  Widget build(BuildContext context) {

    final DialogPlusButton dialogPlusButton = DialogPlusButton();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis apuntes',
          style:  titleStyle   
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.white), 
            onPressed: () {
              showSearch(context: context, delegate: BuscadorDelegate());
            }
          )            
        ]
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.account_circle)
              ),
              accountName: Text(misDatos.nick),
              accountEmail: Text(misDatos.correo),
            ),

            ListTile(
              leading: Icon(Icons.face, color: Theme.of(context).primaryColor),
              title  :  Text('Perfil'),
              onTap  : () => Navigator.pushNamed(context, 'perfil')
            ),

            ListTile(
              leading: Icon(Icons.library_books, color: Theme.of(context).primaryColor),
              title  :  Text('Mis apuntes'),
              onTap  : () => Navigator.push(context, MaterialPageRoute(builder: (context) => MisApuntes()))
            ),

            ListTile(
              leading: Icon(Icons.group, color: Theme.of(context).primaryColor),
              title  :  Text('Mis comunidades'),
              onTap  : () => Navigator.push(context, MaterialPageRoute(builder: (context) => MisComunidades()))
            ),

            ListTile(
              leading: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
              title  :  Text('Notificaciones'),
              onTap  : () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificacionesPage()))
            ),

            ListTile(
              leading: Icon(Icons.settings, color: Theme.of(context).primaryColor),
              title  : Text('Ajustes'),
              onTap  : () => Navigator.pushNamed(context, 'ajustes')                
            )
          ]
        )

      ),
 
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(_mainPag),
        child: botones[_itemActual], 
      ),
          
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
          currentIndex: _itemActual,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          items:[
            BottomNavigationBarItem(
              icon: Icon(Icons.library_books), 
              label: 'Apuntes',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.group), 
              label: 'Comunidades',
            )

          ],
      
        onTap: (index) => setState(() => _itemActual = index),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: _iconFloatingIconButton,
        onPressed: (){ 
          showModalBottomSheet<void>(
            context: context,
            builder: (context) => dialogPlusButton.menu(context)
          );
        },
      ),
    );  
  }
}

class DialogPlusButton{

  Widget menu(BuildContext context){
    return Container(
      height: 120,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.upload_file,
              color: Colors.blue,
              size: 25
            ),
            title: Text(
              'Subir archivo',
              style: TextStyle(
                fontSize: 16
              )
            ),
            onTap: () => Navigator.pushNamed(context, 'upload')
          ),

          ListTile(
            leading: Icon(
              Icons.group,
              color: Colors.blue,
              size: 25
            ),
            title: Text(
              'Crear comunidad',
              style: TextStyle(
                fontSize: 16
              )
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonalizarComunidad(nuevaComunidad: true)
              )
            )
          )
        ]
      ),
    );
  }
}