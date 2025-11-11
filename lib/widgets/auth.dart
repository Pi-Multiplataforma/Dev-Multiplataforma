import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../mobile_homescreen.dart'; 

// Fundo com as ondas reutilizável
class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: const Color.fromARGB(255, 133, 238, 236)),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(color: const Color.fromARGB(255, 182, 255, 255)),
        ),
        ClipPath(
          clipper: WaveClipper2(),
          child: Container(color: const Color.fromARGB(255, 121, 228, 224)),
        ),
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(color: const Color.fromARGB(255, 89, 219, 217)),
        ),
        SafeArea(child: child),
      ],
    );
  }
}

// Logo Poliedro
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: SvgPicture.asset(
        'assets/images/poliedro_logo.svg',
        fit: BoxFit.contain,
      ),
    );
  }
}

// Campo de texto com borda e visibilidade de senha
class LinedTextField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputAction? textInputAction;

  const LinedTextField({
    super.key,
    required this.label,
    this.controller,
    this.isPassword = false,
    this.textInputAction,
  });

  @override
  State<LinedTextField> createState() => _LinedTextFieldState();
}

class _LinedTextFieldState extends State<LinedTextField> {
  bool _obscure = true;

  OutlineInputBorder get _border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF40AEB0), width: 2),
      );

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium;
    return TextField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscure : false,
      textInputAction: widget.textInputAction,
      style: base?.copyWith(
        color: const Color(0xFF2E6D6C),
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: base?.copyWith(
          color: const Color(0xFF6AAFAE),
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: const Color(0xFFE9FFFF),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: _border,
        focusedBorder: _border,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF40AEB0)),
              )
            : null,
      ),
    );
  }
}

// Botão arredondado padrão
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const PillButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF26C6CF),
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        child: Text(label),
      ),
    );
  }
}
