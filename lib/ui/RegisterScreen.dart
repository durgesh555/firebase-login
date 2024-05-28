import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_task/services/usermodel.dart';
import 'package:flutter_demo_task/ui/LoginScreen.dart';
import 'package:flutter_demo_task/utils/utils.dart';
import 'package:flutter_demo_task/widget/round_button.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final passwordTextEditingController = TextEditingController();
  final contactTextEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase dbRef = FirebaseDatabase.instance;


  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
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
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: "Name",
                        helperText: "enter your name",
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'enter name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),

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
                    const SizedBox(height: 10,),

                    TextFormField(
                      controller: contactTextEditingController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        hintText: "Phone",
                        helperText: "enter your phone",
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return 'enter phone';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10,),

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
                    const SizedBox(height: 10,),
                  ],
                ),
              ),

              const SizedBox(height: 30,),
              RoundButton(
                title: "Sign Up",
                loading: loading,
                onTap: (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading = true;
                  });
                  signUpUser();
                }
              },
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) =>
                        const LoginScreen()
                        ));
                  }, child: const Text("Login"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUpUser() async{
    await _auth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text..trim().toString(),
        password: passwordTextEditingController.text.trim().toString()
    ).then((value) {
      dbRef.ref("users")
          .child((FirebaseAuth.instance.currentUser!.uid).toString()).set({
        "name" : nameTextEditingController.text.trim().toString(),
        "email" :emailTextEditingController.text.trim().toString(),
        "phone" :contactTextEditingController.text.trim().toString(),
        "password" : passwordTextEditingController.text.trim().toString(),
      }).then((value) {
            Utils().toastMessage("Registered");
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        debugPrint(error.toString());
      });
      setState(() {
        loading = false;
      });
      Utils().toastMessage("User SignUp Successfully");
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }
}
