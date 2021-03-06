import 'package:flutter/material.dart';

import 'package:appuntes/Modelos/Modelo_comunidades.dart';
import 'package:appuntes/Modelos/Modelo_notificacion.dart';

import '../mis_datos.dart';

class CompartirRecurso extends StatefulWidget{
  final Comunidad comunidad;
  final String tituloDialogo;
  final Notificar notificacion;

  CompartirRecurso({
    this.comunidad,
    this.tituloDialogo,
    this.notificacion
  });

  @override
  State<StatefulWidget> createState() => _CompartirRecursoState();
}

class _CompartirRecursoState extends State<CompartirRecurso>{

  TextEditingController nickname;
  TextEditingController comentario;
  FocusNode focusNickname;
  FocusNode focusComentario;
  List<Notificacion> notificacion;

  @override
  void initState() { 
    super.initState();

    if(widget.notificacion != Notificar.solicitud) {
      nickname = TextEditingController();
      focusNickname   = FocusNode();
    }

    comentario = TextEditingController();
    focusComentario = FocusNode();
  }

  @override
  void dispose() {
    if(widget.notificacion != Notificar.solicitud) {
      nickname.dispose();
      focusNickname.dispose();
    }

    comentario.dispose();
    focusComentario.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        focusComentario.unfocus();
        if(widget.notificacion != Notificar.solicitud) focusNickname.unfocus();
      },
      child: SimpleDialog(
        titlePadding: EdgeInsets.only(top: 15),
        contentPadding: EdgeInsets.fromLTRB(15, 0, 15, 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          widget.tituloDialogo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
          )
        ),

        children: widget.notificacion != Notificar.solicitud? enviarRecurso() : enviarSolicitud()
      )
    );
  }

  List<Widget> enviarRecurso(){
    return [
      TextField(
        controller: nickname,
        focusNode: focusNickname,
        minLines: 1, maxLines: 2,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          icon: Icon(Icons.send),
          hintText: 'Ingresa nick',
        ),
        onEditingComplete: () => FocusScope.of(context).requestFocus(focusComentario)
      ),

      SizedBox(height: 20),

      Text('Deja un mensaje (opcional) :'),

      SizedBox(height: 15),

      TextField(
        controller: comentario,
        focusNode: focusComentario,
        minLines: 3, maxLines: 10,
        decoration: InputDecoration(
          hintText: 'Comentario...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
        )  
      ),

      SizedBox(height: 5),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: TextButton(
          child: Text(
            'Enviar', 
            style: TextStyle(fontSize: 16)
          ),
          onPressed: (){

            notificacion.first = Notificacion.comunidad(
              tipo         : widget.notificacion,
              emisor       : misDatos,
              destinatario : nickname.text,
              comunidad    : widget.comunidad,
              comentario   : comentario.text
            );
            
            Navigator.pop(context, true);
          }
        )
      )
    ];
  }

  List<Widget> enviarSolicitud() {
    return [
      TextField(
        controller: comentario,
        focusNode: focusComentario,
        minLines: 3, maxLines: 10,
        decoration: InputDecoration(
          hintText: 'Comentario...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
        )  
      ),

      SizedBox(height: 5),

      Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: TextButton(
          child: Text(
            'Enviar', 
            style: TextStyle(fontSize: 16)
          ),
          onPressed: (){

            notificacion = List.generate(
              widget.comunidad.administradores.length,
              (i) => Notificacion.comunidad(
                tipo         : widget.notificacion,
                emisor       : misDatos,
                destinatario : widget.comunidad.administradores[i].nick,
                comunidad    : widget.comunidad,
                comentario   : comentario.text
              )
            ); 
            
            
            Navigator.pop(context, true);
          }
        )
      )
    ];
  }

}