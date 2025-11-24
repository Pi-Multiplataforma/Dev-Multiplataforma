import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'base_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'dart:typed_data';
import 'dart:io' show File;




class AuthController extends GetxController {
  final createAccountUrl = Uri.parse('$baseUrl/api/users/createaccount');
  final signInUrl = Uri.parse('$baseUrl/api/users/sign-in');
  final addImageUrl = Uri.parse('$baseUrl/api/users/add-image');
  final userDataUrl = Uri.parse('$baseUrl/api/users/me');
  final addToGalleryUrl = Uri.parse('$baseUrl/api/users/add-to-gallery');
  final galleryUrl = Uri.parse('$baseUrl/api/users/gallery');


  RxBool isSignedIn = false.obs;
  RxString token = ''.obs;
  RxString signedInEmail = ''.obs;


  RxMap<String, dynamic> user = <String, dynamic>{}.obs;

  RxList<Map<String, dynamic>> galeria = <Map<String, dynamic>>[].obs;

Future<void> carregarGaleria() async {
  final imagens = await fetchGallery();
  galeria.value = imagens;
}



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


Future<Map<String, dynamic>> editImage(
  String prompt, {
  String? filename,
}) async {
  final url = Uri.parse('$baseUrl/api/users/edit-image');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({
        'prompt': prompt,
        if (filename != null) 'filename': filename, 
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      
      final imageUrl = data['url'] ??
          '$baseUrl/public/${data['filename']}'; 

      return {
        'success': true,
        'url': imageUrl,
        'prompt': data['prompt'],
        'createdAt': DateTime.now().toString(),
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



Future<bool> addImageToGallery(String filename, String key) async {
  final url = Uri.parse('$baseUrl/api/users/add-to-gallery');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
      body: jsonEncode({'filename': filename, 'key': key}),
    );

    if (response.statusCode == 200) {
      await fetchUserData();
      return true;
    } else {
      print('Erro ao adicionar à galeria: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exceção ao adicionar à galeria: $e');
    return false;
  }
}


Future<List<Map<String, dynamic>>> fetchGallery() async {
  try {
    final response = await http.get(
      galleryUrl,
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token.value,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => {
        'key': item['key'],   
        'name': item['name'],
        'url': item['url'],
      }).toList();
    } else {
      print('Erro ao buscar galeria: ${response.body}');
      return [];
    }
  } catch (e) {
    print('Exceção ao buscar galeria: $e');
    return [];
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