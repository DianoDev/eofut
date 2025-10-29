import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/validators.dart';
import 'package:eofut/presentation/pages/auth/injection_container.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_event.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_state.dart';

class RegisterJogadorPage extends StatefulWidget {
  const RegisterJogadorPage({super.key});

  @override
  State<RegisterJogadorPage> createState() => _RegisterJogadorPageState();
}

class _RegisterJogadorPageState extends State<RegisterJogadorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedEstado;
  String? _selectedNivelJogo;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _estados = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

  final List<String> _niveisJogo = [
    'Iniciante',
    'Intermediário',
    'Avançado',
    'Profissional',
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cidadeController.dispose();
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
      context.read<AuthBloc>().add(
            RegisterJogadorEvent(
              nome: _nomeController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              telefone: _telefoneController.text.trim(),
              cidade: _cidadeController.text.trim().isEmpty ? null : _cidadeController.text.trim(),
              estado: _selectedEstado,
              nivelJogo: _selectedNivelJogo?.toLowerCase(),
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
          title: const Text('Cadastro de Jogador'),
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
                  SnackBar(
                    content: Text('Conta criada com sucesso! Bem-vindo, ${state.user.nome}!'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 3),
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
                    // Ícone
                    Icon(
                      Icons.sports_volleyball,
                      size: 80,
                      color: Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Cadastro de Jogador',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                        hintText: 'seu@email.com',
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
                        hintText: '(00) 00000-0000',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telefone é obrigatório';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Cidade
                    TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        hintText: 'Digite sua cidade',
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
                      items: _estados.map((String estado) {
                        return DropdownMenuItem(
                          value: estado,
                          child: Text(estado),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedEstado = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Nível de Jogo
                    DropdownButtonFormField<String>(
                      value: _selectedNivelJogo,
                      decoration: const InputDecoration(
                        labelText: 'Nível de Jogo',
                        prefixIcon: Icon(Icons.bar_chart_outlined),
                      ),
                      items: _niveisJogo.map((String nivel) {
                        return DropdownMenuItem(
                          value: nivel,
                          child: Text(nivel),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedNivelJogo = newValue;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Senha
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Senha *',
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
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
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
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
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
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
                              : const Text(
                                  'Criar Conta',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Texto de campos obrigatórios
                    Text(
                      '* Campos obrigatórios',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
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
