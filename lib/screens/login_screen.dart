import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = true;

  //Cerebro de la lógica de las animaciones
  StateMachineController? controller;

  // SMI: State Machine Input
  SMIBool? isChecking; //Activa el modo "chismoso"
  SMIBool? isHandsUp; //Baja las manos
  SMITrigger? trigSuccess; //Animación de éxito
  SMITrigger? trigFail; //Animación de fallo

  @override
  Widget build(BuildContext context) {
    //para obtener el tamaño de la pantallla del disp
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  //Al iniciarse
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    //Verificar si es conrtolador inció bien
                    if (controller == null) return;
                    artboard.addController(controller!);
                    //Asignar las variables
                    isChecking = controller!.findSMI("isChecking");
                    isHandsUp = controller!.findSMI("isHandsUp");
                    trigSuccess = controller!.findSMI("trigSuccess");
                    trigFail = controller!.findSMI("trigFail");
                  },
                ),
              ),
              //Espacio entre el oso y el texto medio
              const SizedBox(height: 10),
              //Campo de texto del email
              TextField(
                onChanged: (value) {
                  if (isHandsUp != null) {
                    //No tapar los ojos
                    isHandsUp!.change(false);
                  }
                  if (isChecking == null) return;
                  //Activa el modo chismoso
                  isChecking!.change(true);
                },
                //para que el teclado sepa que es email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10),
              //Campo para la contraseña
              TextField(
                onChanged: (value) {
                  if (isChecking != null) {
                    //No tapar los ojos
                    isChecking!.change(false);
                  }
                  if (isHandsUp == null) return;
                  //Activa el modo chismoso
                  isHandsUp!.change(true);
                },
                //para que el teclado sepa que es password
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: const Text(
                  'Forgot Password?',
                  //Alinear a la derecha
                  textAlign: TextAlign.right,
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              //Botón de Login
              const SizedBox(height: 10),
              //Botón estilo Android
              MaterialButton(
                minWidth: size.width,
                height: 50,
                color: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () {},

                //TODO
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: size.width,
                child: Row(
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
