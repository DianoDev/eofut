import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/validators.dart';
import 'package:eofut/presentation/pages/auth/injection_container.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_event.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_state.dart';

class RegisterProfessorPage extends StatefulWidget {
  const RegisterProfessorPage({super.key});

  @override
  State<RegisterProfessorPage> createState() => _RegisterProfessorPageState();
}

class _RegisterProfessorPageState extends State<RegisterProfessorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _valorHoraController = TextEditingController();
  final _experienciaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedEstado;
  final List<String> _certificacoesSelecionadas = [];
  final List<String> _especialidadesSelecionadas = [];
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _estados = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

  final List<String> _certificacoesDisponiveis = [
    'CBV - Confederação Brasileira de Vôlei',
    'CREF - Educação Física',
    'Técnico de Futevôlei',
    'Personal Trainer',
    'Outros',
  ];

  final List<String> _especialidadesDisponiveis = [
    'Iniciantes',
    'Intermediário',
    'Avançado',
    'Fundamentos',
    'Saque',
    'Defesa',
    'Ataque',
    'Preparação Física',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
    _valorHoraController.dispose();
    _experienciaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != _passwordController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  void _handleRegister(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      double? valorHora;
      int? experiencia;

      if (_valorHoraController.text.isNotEmpty) {
        valorHora = double.tryParse(_valorHoraController.text);
      }
      if (_experienciaController.text.isNotEmpty) {
        experiencia = int.tryParse(_experienciaController.text);
      }

      context.read<AuthBloc>().add(
            RegisterProfessorEvent(
              nome: _nomeController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              telefone: _telefoneController.text.trim(),
              certificacoes: _certificacoesSelecionadas.isEmpty ? null : _certificacoesSelecionadas,
              especialidades: _especialidadesSelecionadas.isEmpty ? null : _especialidadesSelecionadas,
              valorHoraAula: valorHora,
              experienciaAnos: experiencia,
              cidade: _cidadeController.text.trim().isEmpty ? null : _cidadeController.text.trim(),
              estado: _selectedEstado,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Professor'),
        ),
        body: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              } else if (state is Authenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Professor cadastrado com sucesso!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                  ),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(Icons.school, size: 80, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      'Cadastro de Professor',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Nome
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo *',
                        prefixIcon: Icon(Icons.person_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 16),

                    // Telefone
                    TextFormField(
                      controller: _telefoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Telefone *',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Telefone é obrigatório' : null,
                    ),
                    const SizedBox(height: 16),

                    // Cidade
                    TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estado
                    DropdownButtonFormField<String>(
                      value: _selectedEstado,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      items: _estados.map((estado) => DropdownMenuItem(value: estado, child: Text(estado))).toList(),
                      onChanged: (value) => setState(() => _selectedEstado = value),
                    ),
                    const SizedBox(height: 16),

                    // Valor Hora/Aula
                    TextFormField(
                      controller: _valorHoraController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Valor por Hora/Aula (R\$)',
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Experiência
                    TextFormField(
                      controller: _experienciaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Anos de Experiência',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Certificações
                    Text('Certificações', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _certificacoesDisponiveis.map((cert) {
                        final isSelected = _certificacoesSelecionadas.contains(cert);
                        return FilterChip(
                          label: Text(cert),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _certificacoesSelecionadas.add(cert);
                              } else {
                                _certificacoesSelecionadas.remove(cert);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Especialidades
                    Text('Especialidades', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _especialidadesDisponiveis.map((esp) {
                        final isSelected = _especialidadesSelecionadas.contains(esp);
                        return FilterChip(
                          label: Text(esp),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _especialidadesSelecionadas.add(esp);
                              } else {
                                _especialidadesSelecionadas.remove(esp);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha *',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),

                    // Confirmar Senha
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirmar senha *',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                      validator: _validateConfirmPassword,
                    ),
                    const SizedBox(height: 32),

                    // Botão Registrar
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return ElevatedButton(
                          onPressed: isLoading ? null : () => _handleRegister(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text('Cadastrar Professor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '* Campos obrigatórios',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
