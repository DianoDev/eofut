import 'package:flutter/material.dart';
import 'register_jogador_page.dart';
import 'register_arena_page.dart';
import 'register_professor_page.dart';

class SelectAccountTypePage extends StatelessWidget {
  const SelectAccountTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Text(
                'Escolha o tipo de conta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              Text(
                'Selecione a opção que melhor se adequa a você',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Card: Jogador
              _AccountTypeCard(
                icon: Icons.sports_volleyball,
                title: 'Jogador',
                description: 'Encontre parceiros, reserve quadras e participe de rachas',
                color: Colors.blue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterJogadorPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Card: Arena
              _AccountTypeCard(
                icon: Icons.stadium,
                title: 'Arena',
                description: 'Cadastre sua arena, gerencie reservas e crie eventos',
                color: Colors.green,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterArenaPage(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Card: Professor
              _AccountTypeCard(
                icon: Icons.school,
                title: 'Professor',
                description: 'Ofereça aulas, crie eventos e encontre alunos',
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterProfessorPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _AccountTypeCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              // Ícone
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),

              const SizedBox(width: 16),

              // Textos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),

              // Seta
              Icon(
                Icons.arrow_forward_ios,
                color: color,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
