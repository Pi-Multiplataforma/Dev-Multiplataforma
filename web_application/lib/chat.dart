import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String PEXELS_API_KEY = 'X6y0kJLOW8YMaa75gABhhlnhuMFNHCBcvydaPxxVvMAh6wnTMrDAhZYz';

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
  final bool isUser;     // true = usuário, false = IA
  final String? text;    // texto do prompt ou erro
  final String? image;   // URL da imagem

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
  final _messages = <ChatMessage>[];
  final _input = TextEditingController();
  bool _sending = false;

  // Pega 1 imagem na Pexels com base no prompt
  Future<String?> _generateImage(String prompt) async {
    final uri = Uri.https('api.pexels.com', '/v1/search', {
      'query': prompt,
      'per_page': '1',
      'page': '1',
    });

    final res = await http.get(uri, headers: {'Authorization': PEXELS_API_KEY});

    if (res.statusCode != 200) return null;

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final photos = (data['photos'] as List?) ?? [];
    if (photos.isEmpty) return null;

    final src = photos.first['src'] as Map<String, dynamic>;
    return (src['medium'] as String?) ?? (src['original'] as String?);
  }

  Future<void> _onSend() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(ChatMessage.user(text));
      _sending = true;
      _input.clear();
    });

    final url = await _generateImage(text);

    setState(() {
      if (url == null) {
        _messages.add(ChatMessage.ai(text: 'Não encontrei imagem para: "$text"'));
      } else {
        _messages.add(ChatMessage.ai(image: url));
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
          children: [
            const SizedBox(width: 12),
            // Se a não tiver logo, troca por um ícone
            Image.asset(
              'assets/images/logo_poliedro.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Container(width: 2, height: 18, color: Colors.white70),
          ],
        ),
        title: const Text(''),
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
          // Lista de mensagens
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _ChatBubble(_messages[i]),
            ),
          ),

          // espaço de texto + botão enviar
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    onSubmitted: (_) => _onSend(),
                    decoration: const InputDecoration(
                      hintText: 'Descreva a imagem',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // botão enviar
                ElevatedButton(
                  onPressed: _sending ? null : _onSend,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF26A5AE),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                  child: _sending
                      ? const SizedBox(
                          width: 16, height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.send, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// balão de mensagem
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
      // resposta da API com imagem
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
          msg.image!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Center(child: Text('Falha ao carregar imagem')),
        ),
      );
    } else {
      // Balão de texto
      content = Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border, width: 1.6),
        ),
        child: Text(msg.text ?? '',
            style: const TextStyle(color: Color(0xFF11646C))),
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

//cabeçalho
class _TopLink extends StatelessWidget {
  final String text;
  const _TopLink({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {}, // ligar depois
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
