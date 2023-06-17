

// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/login_form_provider.dart';
import '../../providers/ui_re_provider.dart';
import '../../services/login_service.dart';
import '../../ui/input_decorations.dart';
import '../widgets/login/auth_background.dart';
import '../widgets/login/card_container.dart';



class LoginScreen extends StatelessWidget {
 
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
                   Text('Iniciar Sesión', style: Theme.of(context).textTheme.headline4,),
                    Text('V.1.2.0', style: TextStyle(fontSize: 10)),
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
             
            //  TextButton(
            //    onPressed: () => Navigator.pushReplacementNamed(context, 'forgotPassword'), 
            //    style: ButtonStyle(
            //      overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1) ),
            //      shape: MaterialStateProperty.all(StadiumBorder())
            //    ),
            //    child: Text('¿Olvidaste la contraseña?', style: TextStyle(fontSize: 18, color: Colors.black87)),
               
            //    ),

             SizedBox(height: 50),
            ]
          )

        )
      ),
    );
  }
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
              style: TextStyle(
                color: Colors.black
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,//para poner teclado con @
              decoration: InputDecorations.authInputDecoration(
                hintText: 'usuario',
                labelText: 'Usuario',
                prefixIcon: Icons.perm_identity,                
                
              ),//Consumimos el imput
              //Asignar valores a los providers
              onChanged: (value) => loginForm.email = value,
              validator: (value) {   
                               
                  return (value != null && value.length >= 3) //siempre se ejecuta la primer condicion value != null y si se cumple se ejecuta value.length >= 6
                  ? null
                  : 'Usuario incorrecto';                   
                  // String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';	 
	                // RegExp regExp  = new RegExp(pattern);

                  // return regExp.hasMatch(value ?? '')//espera un bool pero recibe un string, pero debe regresar un string o null
                  //   ? null
                  //   : 'El valor ingresado no es un correo';

              },
            ),
            
            SizedBox(height: 30,),

             TextFormField(
               style: TextStyle(
                color: Colors.black
              ),

              autocorrect: false,
              obscureText: true,//para que la persona no pueda ver lo que escribe
              keyboardType: TextInputType.emailAddress,//para poner teclado con @
              decoration: InputDecorations.authInputDecoration(
                hintText: 'password',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline
              ),//Consumimos el imput
              //Asignar valores a los providers
              onChanged: (value) => loginForm.password = value,
               validator: (value) {
                 
                 return (value != null && value.length >= 3) //siempre se ejecuta la primer condicion value != null y si se cumple se ejecuta value.length >= 6
                  ? null
                  : 'La contraseña es muy corta';                 

              },
            ),
            SizedBox(height: 30,),          

             TextFormField(
              style: TextStyle(
                color: Colors.black
              ),
              autocorrect: false,
              keyboardType: TextInputType.text,//para poner teclado con @
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Código Tienda',
                labelText: 'Código Tienda',
                prefixIcon: Icons.inventory,                
                
              ),
              onChanged: (value) => loginForm.bodega = value,
              validator: (value) {                  
                 print(value); 
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
                    : 'Ingresar',
                  style: TextStyle(color: Colors.white)
                )
              ),            
              onPressed: loginForm.isLoading ? null : () async {                
                 FocusScope.of(context).unfocus();
                loginForm.isLoading = true;  
                final authService = Provider.of<AuthService>(context, listen: false);
              
                 final String? id = await authService.singIn(loginForm.email, loginForm.password, loginForm.bodega);
                 
                // final String? user = await authService.singIn(loginForm.email, loginForm.password);
                 if(id != '0' && id != '-0' )
                 {
                   final uiProvider = Provider.of<UiReProvider>(context, listen: false); 
                   uiProvider.readUser();
                   Navigator.pushReplacementNamed(context, 'home'); 
                 }
                 else if(id == '0')
                 {
                    loginForm.isLoading = false;  
                      
                     showDialog(
                      context: context, 
                      builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('Contraseña incorrecta'),
                            content: SingleChildScrollView(child: ListBody(children: [Text('Usuario o contraseña incorrecta')],)),
                            actions: [
                              TextButton(onPressed: () {
                                print('salir');
                                Navigator.of(context).pop();

                              }, child: Text('Cerrar')),
                            ],
                         );
                      }
              );

                    

                 }

                 else if(id == '-0')
                 {
                    loginForm.isLoading = false;  
                      
                     showDialog(
                      context: context, 
                      builder: (BuildContext context){
                          return AlertDialog(
                            title: Text('API ERROR'),
                            content: SingleChildScrollView(child: ListBody(children: [Text('No se pudo obtener información del API')],)),
                            actions: [
                              TextButton(onPressed: () {
                                print('salir');
                                Navigator.of(context).pop();

                              }, child: Text('Cerrar')),
                            ],
                         );
                      }
              );

                    

                 }
                
              }              
            )
          ]
          
        )
        ),
    );
  }
}