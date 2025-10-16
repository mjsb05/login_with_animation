import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
//3.1 Importar librería para timer
import "dart:async";

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

  //Variable de recorrido de mirada
  SMINumber? numLook;

  // 1) FocusNode
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();

  //3.2 Timer para detener la animación al dejar de escribirir
  Timer? _typingDebounce;

  //4.1 Contollers; dice que es lo que el usuario escribió
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //4.2 Errores para mostrar en la UI
  String? emailError;
  String? passwordError;

  //4.3 Validadores de mail y password
  bool isValidEmail(String email) {
    final re = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return re.hasMatch(email);
  }

  bool isValidPassword(String password) {
    final re = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
    );
    return re.hasMatch(password);
  }

  //4.4 Acción al botón
  void _onLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    //Recalcular errores
    final eError = isValidEmail(email) ? null : 'Email no válido';
    final pError = isValidPassword(password)
        ? null
        : 'Mínimo 8 caractéres, una mayúscula, una minúscula, un número y un símbolo';

    //4.5 Para ver si hubo cambio
    setState(() {
      emailError = eError;
      passwordError = pError;
    });

    //4.6 Cerrar el teclado y  bajar }
    FocusScope.of(context).unfocus();
    _typingDebounce?.cancel();
    isChecking?.change(false);
    isHandsUp?.change(false);
    numLook?.value = 50; //Mirada neutra

    //4.7 Activar triggers
    if (eError == null && pError == null) {
      trigSuccess?.fire();
    } else {
      trigFail?.fire();
    }
  }

  //2) Listeners (oyentes/chismoso)
  @override
  void initState() {
    super.initState();
    emailFocus.addListener(() {
      if (emailFocus.hasFocus) {
        //manos abajo
        isHandsUp?.change(false);
        //2.2 mirada neutral al enfocar email
        numLook?.change(50.0);
        isHandsUp?.change(false);
      }
    });
    passwordFocus.addListener(() {
      //Manos arriba en contraseña
      isHandsUp?.change(passwordFocus.hasFocus);
    });
  }

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
                    //2.3 Enlazar variable con la animación
                    numLook = controller!.findSMI("numLook");
                  }, //clamp
                ),
              ),
              //Espacio entre el oso y el texto medio
              const SizedBox(height: 10),

              //Campo de texto del email
              TextField(
                //Llamar al foco
                focusNode: emailFocus,

                //4.8 Enlazar el controlador
                controller: emailController,
                onChanged: (value) {
                  //"Estoy escribiendo"
                  isChecking!.change(true);

                  //Ajuste de límites de 0 a 100
                  //el 90 es como una medida de calibración
                  final look = (value.length / 90 * 100).clamp(0.0, 100.0);
                  numLook?.change(look);

                  //3.3 Debounce si vuelve a teclear, reiniciar el timer
                  _typingDebounce?.cancel();
                  _typingDebounce = Timer(const Duration(seconds: 3), () {
                    if (!mounted) {
                      return; //Si la pantalla se cierra
                    }
                    //Mirada neutra
                    isChecking?.change(false);
                  });

                  if (isChecking == null) return;
                  //Activa el modo chismoso
                  isChecking!.change(true);
                },
                //para que el teclado sepa que es email
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  //4.9 Mostrar error
                  errorText: emailError,
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
                focusNode: passwordFocus,

                //4.8 Enlazar el controlador
                controller: passwordController,
                onChanged: (value) {
                  if (isChecking != null) {
                    //No tapar los ojos
                    //isChecking!.change(false);
                  }
                  if (isHandsUp == null) return;
                  //Activa el modo chismoso
                  isHandsUp!.change(true);
                },
                //para que el teclado sepa que es password
                obscureText: _isPasswordVisible,
                decoration: InputDecoration(
                  //4.9 Mostrar error
                  errorText: passwordError,
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
                onPressed: _onLogin,

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

  // 4) Liberaición de recursos
  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
    _typingDebounce?.cancel();
  }
}
