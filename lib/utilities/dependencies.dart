import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('$baseUrl/api/users/createaccount');
  final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');
  final addImageUrl = Uri.parse('$baseUrl/api/users/add-image');
  final userDataUrl = Uri.parse('$baseUrl/api/users/me');


  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;


  RxMap<String, dynamic> user = <String, dynamic>{}.obs;


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
        await fetchUserData();
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
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
  Get.offNamed('/');
}

Future<Map<String, dynamic>> generateImage(String prompt) async {
  final url = Uri.parse('$baseUrl/api/users/generate-image');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'success': true,
        'url': data['url'],
        'prompt': data['prompt'],
        'createdAt': data['createdAt'] ?? DateTime.now().toString(),
      };
    } else {
      return {
        'success': false,
        'error': response.body.toString(),
      };
    }
  } catch (e) {
    return {
      'success': false,
      'error': e.toString(),
    };
  }
}

Future<bool> addImageToUser(String key, String imageUrl) async {
  final url = Uri.parse('$baseUrl/api/users/add-image');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({
        'key': key,
        'url': imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      await fetchUserData(); 
      return true;
    } else {
      print('Erro: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exceção: $e');
    return false;
  }
}

Future<bool> deleteImageFromUser(String key) async {
  final url = Uri.parse('$baseUrl/api/users/delete-image');

  try {
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({'key': key}),
    );

    if (response.statusCode == 200) {
      await fetchUserData(); 
      return true;
    } else {
      print('Erro: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exceção: $e');
    return false;
  }
}




Future<void> fetchUserData() async {
    try {
      final response = await http.get(
        userDataUrl,
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token.value,
        },
      );
      if (response.statusCode == 200) {
        user.value = jsonDecode(response.body);
      } else {
        print('Erro ao buscar usuário: ${response.body}');
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
    }
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