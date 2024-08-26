import 'package:chat_app/views/login_page.dart';
import 'package:chat_app/views/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
   bool toggle = true;

   void isToggle(){
     setState(() {
       toggle = !toggle;
     });
   }
  @override
  Widget build(BuildContext context) {
    if (toggle){
      return LoginPage(onTap: isToggle,);

    }else{
      return RegisterPage(onTap: isToggle,);
    }
  }
}
