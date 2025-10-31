import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/presentation/pages/auth/presentation/pages/auth/login_page.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_event.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_state.dart';
import 'package:eofut/presentation/pages/user_jogador/home_jogador_page.dart';
import 'package:eofut/presentation/pages/user_arena/home_arena_page.dart';
import 'package:eofut/presentation/pages/user_professor/home_professor_page.dart';
import 'package:eofut/domain/entities/user.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      context.read<AuthBloc>().add(const CheckAuthStatusEvent());
    }
  }

  void _navigateBasedOnUserType(User user) {
    Widget homePage;

    switch (user.tipoUsuario) {
      case TipoUsuario.jogador:
        homePage = HomeJogadorPage(user: user);
        break;
      case TipoUsuario.arena:
        homePage = HomeArenaPage(user: user);
        break;
      case TipoUsuario.professor:
        homePage = HomeProfessorPage(user: user);
        break;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => homePage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          _navigateBasedOnUserType(state.user);
        } else if (state is Unauthenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginPage()),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF00A86B),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sports_volleyball,
                  size: 60,
                  color: Color(0xFF00A86B),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'FutApp',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Seu app de futevôlei',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
