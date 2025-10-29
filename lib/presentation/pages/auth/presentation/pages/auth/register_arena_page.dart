import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/validators.dart';
import 'package:eofut/presentation/pages/auth/injection_container.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_event.dart';
import 'package:eofut/presentation/pages/auth/presentation/bloc/auth/auth_state.dart';

class RegisterArenaPage extends StatefulWidget {
  const RegisterArenaPage({super.key});

  @override
  State<RegisterArenaPage> createState() => _RegisterArenaPageState();
}

class _RegisterArenaPageState extends State<RegisterArenaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeEstabelecimentoController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedEstado;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final List<String> _estados = ['AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'];

  @override
  void dispose() {
    _nomeEstabelecimentoController.dispose();
    _cnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
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
      if (_selectedEstado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecione um estado'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
            RegisterArenaEvent(
              nomeEstabelecimento: _nomeEstabelecimentoController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              telefone: _telefoneController.text.trim(),
              cnpj: _cnpjController.text.trim(),
              enderecoCompleto: _enderecoController.text.trim(),
              cidade: _cidadeController.text.trim(),
              estado: _selectedEstado!,
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
          title: const Text('Cadastro de Arena'),
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
                    content: Text('Arena cadastrada com sucesso!'),
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
                    Icon(Icons.stadium, size: 80, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      'Cadastro de Arena',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Nome do Estabelecimento
                    TextFormField(
                      controller: _nomeEstabelecimentoController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Arena *',
                        prefixIcon: Icon(Icons.business_outlined),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Nome é obrigatório' : null,
                    ),
                    const SizedBox(height: 16),

                    // CNPJ
                    TextFormField(
                      controller: _cnpjController,
                      decoration: const InputDecoration(
                        labelText: 'CNPJ *',
                        hintText: '00.000.000/0000-00',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'CNPJ é obrigatório' : null,
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

                    // Endereço
                    TextFormField(
                      controller: _enderecoController,
                      decoration: const InputDecoration(
                        labelText: 'Endereço Completo *',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Endereço é obrigatório' : null,
                    ),
                    const SizedBox(height: 16),

                    // Cidade
                    TextFormField(
                      controller: _cidadeController,
                      decoration: const InputDecoration(
                        labelText: 'Cidade *',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      validator: (value) => value?.isEmpty ?? true ? 'Cidade é obrigatória' : null,
                    ),
                    const SizedBox(height: 16),

                    // Estado
                    DropdownButtonFormField<String>(
                      value: _selectedEstado,
                      decoration: const InputDecoration(
                        labelText: 'Estado *',
                        prefixIcon: Icon(Icons.map_outlined),
                      ),
                      items: _estados.map((String estado) {
                        return DropdownMenuItem(value: estado, child: Text(estado));
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() => _selectedEstado = newValue);
                      },
                      validator: (value) => value == null ? 'Estado é obrigatório' : null,
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
                            backgroundColor: Colors.green,
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
                              : const Text('Cadastrar Arena', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
