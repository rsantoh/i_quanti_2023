

// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:i_quanti_2023/screems/widgets/login/card_container.dart';
import 'package:provider/provider.dart';

import '../../providers/login_form_provider.dart';
import '../../ui/input_decorations.dart';
import '../widgets/login/auth_background.dart';






class ForgotScreen extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        //Me permite hacer scrooll si los hijos sobrepasan el tamaño de la pantalla
        child: SingleChildScrollView(
          child: Column(
            children:[
             //Poner espacio para que los hijos parezcan unpñoco más abajo
             SizedBox(height: 250),
             CardContainer(
               child: Column(
                 children: [
                   SizedBox(height: 10),
                   Text('Recuperar contraseña', style: Theme.of(context).textTheme.headline6,),
                   SizedBox(height: 30),

                  //Crea instancia de loginFormPovider que puede redibujar cuando sea necesario y solo funcionara en login form
                   ChangeNotifierProvider(
                     create: (_) => LoginFormProvider(),
                     child: _LoginForm(),
                   ),
                   

                 ],
               )
             ),
             SizedBox(height: 50),
              TextButton(
               onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
               style: ButtonStyle(
                 overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1) ),
                 shape: MaterialStateProperty.all(StadiumBorder())
               ),
               child: Text('¿Ya tienes una cuenta?', style: TextStyle(fontSize: 18, color: Colors.black87)),
               
               ),
             SizedBox(height: 50),
            ]
          )

        )
      ),
    );
  }
}

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        //Me permite hacer scrooll si los hijos sobrepasan el tamaño de la pantalla
        child: SingleChildScrollView(
          child: Column(
            children:[
             //Poner espacio para que los hijos parezcan unpñoco más abajo
             SizedBox(height: 250),
             CardContainer(
               child: Column(
                 children: [
                   SizedBox(height: 10),
                   Text('Recuperar contraseña', style: Theme.of(context).textTheme.headline6,),
                   SizedBox(height: 30),

                 ],
               )
             ),
             SizedBox(height: 50),
              TextButton(
               onPressed: () => Navigator.pushReplacementNamed(context, 'login'), 
               style: ButtonStyle(
                 overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1) ),
                 shape: MaterialStateProperty.all(StadiumBorder())
               ),
               child: Text('¿Ya tienes una cuenta?', style: TextStyle(fontSize: 18, color: Colors.black87)),
               
               ),
             SizedBox(height: 50),
            ]
          )

        )
      ),
    );
  }


class _LoginForm extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    //con este login form ahora tengo acceso a todo lo que esta clase me ofrece
    final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(//Hace una referencia al widget interno
      
        key: loginForm.formKey,

        autovalidateMode: AutovalidateMode.onUserInteraction,

        child: Column(
          children:[
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,//para poner teclado con @
              decoration: InputDecorations.authInputDecoration(
                hintText: 'usuario',
                labelText: 'Email o nombre de usuario',
                prefixIcon: Icons.perm_identity
              ),//Consumimos el imput
              //Asignar valores a los providers
              onChanged: (value) => loginForm.email = value,
              validator: (value) {
                  
                  return (value != null && value.length >= 5) //siempre se ejecuta la primer condicion value != null y si se cumple se ejecuta value.length >= 6
                  ? null
                  : 'Usuario incorrecto';  
              },
            ),
            
            SizedBox(height: 30,),

            
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              elevation: 0,
              color: Colors.deepPurple,
              //botón
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginForm.isLoading
                    ? 'Espere'
                    : 'Recuperar',
                  style: TextStyle(color: Colors.white)
                )
              ),
              //para desactivar el botón, si esta cargando regreso un null
              //si esta cargando regreso un null, caso contrario la funcion
              onPressed: loginForm.isLoading ? null : () async {
                //Para quitar el teclado
                FocusScope.of(context).unfocus();

               
                if(loginForm.isValidForm())
                {
                  loginForm.isLoading = true;
                  Navigator.pushReplacementNamed(context, 'home');
                  loginForm.isLoading = false;
                  //Si todo es correcto ingreso a otra pantalla y ya no voy a poder regresar aunque quiera
                  
                }
                else
                {
                  return;
                }
              }
              
            )
          ]
          
        )
        ),
    );
  }
}