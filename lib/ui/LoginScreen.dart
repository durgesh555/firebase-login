import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_task/ui/HomeMapScreen.dart';
import 'package:flutter_demo_task/ui/RegisterScreen.dart';
import 'package:flutter_demo_task/utils/utils.dart';
import 'package:flutter_demo_task/widget/round_button.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked : (didPop){
       SystemNavigator.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: "Email",
                          helperText: "enter your email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'enter email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: passwordTextEditingController,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: "Password",
                          helperText: "enter your password",
                          prefixIcon: Icon(Icons.lock_open),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'enter password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),

                const SizedBox(height: 50,),
               RoundButton(title: "Login",
                 loading: loading,
                 onTap: (){
                 if(_formKey.currentState!.validate()){
                   setState(() {
                     loading = true;
                   });
                   loginUser();
                 }
               },
               ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(onPressed: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>
                          const RegisterScreen()
                      ));
                    }, child: const Text("Sign Up"))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async{
    await _auth.signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim().toString(),
        password: passwordTextEditingController.text.trim().toString()
    ).then((value) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage("User Login Successfully");
      Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeMapScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
    });
  }
}
