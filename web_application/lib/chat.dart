import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(const ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poliedro • Chat de Imagens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE6FAFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF26A5AE),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const ChatPage(),
    );
  }
}

class ChatMessage {
  final bool isUser;
  final String? text;
  final String? image;

  ChatMessage.user(this.text)
      : isUser = true,
        image = null;

  ChatMessage.ai({this.text, this.image}) : isUser = false;
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messages = <ChatMessage>[];  // Lista de mensagens do chat
  final _input = TextEditingController();  // Controlador do campo de input
  bool _sending = false;  // Verifica se uma imagem está sendo gerada

  // Função que chama o servidor para gerar a imagem
  Future<String?> _generateImage(String prompt) async {
    try {
      final res = await http.post(
        Uri.parse('http://localhost:4001/generate-image'),  // Endereço do backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),  // Envia o prompt para o backend
      );
      if (res.statusCode != 200) return null;  // Se o código não for 200, retorna null
      final data = jsonDecode(res.body);  // Decodifica a resposta JSON do backend
      return data['image_url'] as String?;  // Retorna a URL da imagem
    } catch (e) {
      print('Falha de rede: $e');  // Exibe o erro se a rede falhar
      return null;
    }
  }

  // Envia o prompt e recebe a imagem gerada
  Future<void> _onSend() async {
    final text = _input.text.trim();  // Pega o texto do prompt
    if (text.isEmpty || _sending) return;  // Verifica se o texto está vazio ou se está gerando a imagem

    setState(() {
      _messages.add(ChatMessage.user(text));  // Exibe o texto do usuário
      _sending = true;
      _input.clear();
    });

    final url = await _generateImage(text);  // Chama o backend para gerar a imagem

    setState(() {
      if (url == null) {
        _messages.add(ChatMessage.ai(text: 'Não encontrei imagem para: "$text"'));  // Caso não tenha imagem
      } else {
        _messages.add(ChatMessage.ai(image: url));  // Exibe a imagem gerada
      }
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 78,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 12),
            Icon(Icons.image_outlined, color: Colors.white, size: 28),  // Ícone no lugar da logo
            SizedBox(width: 10),
            SizedBox(width: 2, height: 18, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white70))),
          ],
        ),
        title: const Text(''),  // Mantém o alinhamento do título
        actions: const [
          _TopLink(text: 'Minha galeria'),
          _DividerDot(),
          _TopLink(text: 'Sair'),
          SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _ChatBubble(_messages[i]),  // Exibe o balão da mensagem
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    onSubmitted: (_) => _onSend(),  // Quando o usuário apertar Enter
                    decoration: const InputDecoration(
                      hintText: 'Descreva a imagem',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sending ? null : _onSend,  // Desabilita o botão enquanto está enviando
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A5AE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  child: _sending
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))  // Mostra o carregamento
                      : const Icon(Icons.send, size: 18),  // Ícone do botão de envio
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar a mensagem com imagem ou texto
class _ChatBubble extends StatelessWidget {
  final ChatMessage msg;
  const _ChatBubble(this.msg);

  @override
  Widget build(BuildContext context) {
    final isUser = msg.isUser;
    final bubbleColor = isUser ? Colors.white : const Color(0xFFE0F7FA);
    final border = isUser ? const Color(0xFF26A5AE) : const Color(0xFF22B8C8);

    Widget content;
    if (msg.image != null) {
      content = Container(
        width: 280,
        height: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF21B4C7), width: 10),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 12,
              offset: const Offset(2, 5),
            )
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          msg.image!,  // Exibe a imagem gerada
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Text('Falha ao carregar imagem')),  // Mensagem de erro
        ),
      );
    } else {
      content = Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1.6),
        ),
        child: Text(msg.text ?? '', style: const TextStyle(color: Color(0xFF11646C))),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8, msg.image != null ? 10 : 6, 8, 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) const SizedBox(width: 8),
          content,
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}

// Link superior
class _TopLink extends StatelessWidget {
  final String text;
  const _TopLink({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},  // Link ainda não tem ação
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// Separador de link
class _DividerDot extends StatelessWidget {
  const _DividerDot({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Text('|', style: TextStyle(color: Colors.white70)),
    );
  }
}
