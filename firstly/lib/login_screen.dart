import 'package:firstly/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FormScreen extends StatefulWidget {
  
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen>{
  final _formfield = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool passToggle = true;

    final CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child:Padding(
          padding:EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
          child: Form(
            key: _formfield,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/ema_logo.jpeg",
                  height: 200, 
                  width: 200,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Gérer la connexion avec Google
                      },
                      icon: FaIcon(FontAwesomeIcons.google),
                      label: Text("With Google"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red, 
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Gérer la connexion avec Facebook
                      },
                      icon: FaIcon(FontAwesomeIcons.facebook),
                      label: Text("With Facebook"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value){
                    bool emailValid = RegExp(
                            r"^[zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value!);
                    if(value.isEmpty){
                      return "Enter Email";
                    }
                      else if(!emailValid){
                          return "Enter Valid Email";
                        }
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: passController,
                  obscureText: passToggle,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    suffix: InkWell(
                      onTap: (){
                        setState((){
                          passToggle = !passToggle;
                        });
                      },
                      child: Icon(passToggle ? Icons.visibility : Icons.visibility_off),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return "Enter Password";
                    }
                    else if(passController.text.length < 6){
                      return "Password Length schould be more than 6 characters";
                    }
                  },
                ),

                SizedBox(height: 20),
                InkWell(
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if(_formfield.currentState!.validate()){
                            await users.add({
                            'email': emailController.text,
                            'password': passController.text,
                          });
                            print("Data Added Successfully");
                            emailController.clear();
                            passController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomCreateListingScreen(announcements: []),
                              ),
                            );
                          }
                        },
                        child: Center(
                      child: Text("Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      ))
                      ),
                    ), 
                    ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have account?",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {}, 
                      child: Text(
                        "Create a new account",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ),
                  ],
                ),
                
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }
}
