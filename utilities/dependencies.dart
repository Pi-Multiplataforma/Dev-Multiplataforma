import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('$baseUrl/api/users/createaccount');
  final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');


  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;

  Future<String> createAccount(
    String name,
    String email,
    String password,
  ) async{
    try{
      var createAccountData = await http.post(
        createAccountUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        })
      );
      if(createAccountData.statusCode == 200){
        return 'sucess';
      } else{
        return createAccountData.toString();
      }
    } catch(error){
      return '$error';
    }
  }

  Future<String> signIn(
    String email,
    String password,
  ) async{
    try{
      var signInData = await http.post(
        signInUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            'email': email, 
            'password': password,
          },
        ),
      );
      if(signInData.statusCode == 200){
        final jsonSignInData = jsonDecode(signInData.body);
        isSignedIn.value = true;
        token.value = jsonSignInData['token'];
        signedInEmail.value = jsonSignInData['email'];
        return 'sucess';
      }else{
        return signInData.body.toString();
      }
    } catch(error){
      return '$error';
    }
  }

  void signOut() {
  token.value = '';
  isSignedIn.value = false;
  signedInEmail.value = '';
  Get.snackbar('Sessão encerrada', 'Você saiu com sucesso.',
    backgroundColor: Colors.blue,
    colorText: Colors.white,
  );
  Get.offNamed('/');
}
}

class InitialBindings extends Bindings{
  @override
  void dependencies(){
    Get.put<AuthController>(
      AuthController(),
    );  
  }
}