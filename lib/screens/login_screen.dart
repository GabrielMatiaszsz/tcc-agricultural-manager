import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD0F3CC),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo com imagem agrícola + leve overlay
          DecoratedBox(
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/images/login_bg.jpeg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.08),
                    Colors.black.withOpacity(0.08),
                  ],
                ),
              ),
            ),
          ),

          // Conteúdo central
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 860),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _LoginCard(
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onLogin: () {
                    Navigator.pushReplacementNamed(context, '/dashboard');
                  },
                  onSignUp: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sign up (demo)')),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const _LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo + marca
          Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F8B3A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(Icons.grass, color: Colors.white, size: 34),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Gerenciador Agrícola ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F8B3A),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Faça o login abaixo',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),

          // Inputs
          _InputField(
            controller: emailController,
            label: 'Email',
            hint: 'Enter email',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 12),
          _InputField(
            controller: passwordController,
            label: 'Password',
            hint: 'Enter password',
            obscure: true,
          ),

          const SizedBox(height: 18),

          // Botão verde principal
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2FA34A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: onLogin,
              child: const Text(
                'Log in',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Botões sociais pretos
          _SocialButton.google(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Google sign-in (demo)')),
              );
            },
          ),
          const SizedBox(height: 10),
          _SocialButton.apple(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Apple sign-in (demo)')),
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2FA34A), width: 1.3),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget leading;
  final String label;
  final VoidCallback? onPressed;

  const _SocialButton._({
    required this.leading,
    required this.label,
    required this.onPressed,
  });

  factory _SocialButton.google({VoidCallback? onPressed}) {
    return _SocialButton._(
      onPressed: onPressed,
      leading: const _GoogleIcon(),
      label: 'Faça login com sua conta Google',
    );
  }

  factory _SocialButton.apple({VoidCallback? onPressed}) {
    return _SocialButton._(
      onPressed: onPressed,
      leading: const Icon(Icons.apple, color: Colors.white, size: 22),
      label: 'Faça login com sua conta Apple',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// Logo do Google ou fallback "G"
class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Image.asset(
        'assets/images/google_logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, _, __) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              'G',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
          );
        },
      ),
    );
  }
}
