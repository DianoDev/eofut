import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/quadra_bloc.dart';
import '../bloc/quadra_event.dart';
import '../bloc/quadra_state.dart';

class QuadraFormPage extends StatefulWidget {
  final String arenaId;
  final String? quadraId;

  const QuadraFormPage({
    super.key,
    required this.arenaId,
    this.quadraId,
  });

  @override
  State<QuadraFormPage> createState() => _QuadraFormPageState();
}

class _QuadraFormPageState extends State<QuadraFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _tipoPisoController = TextEditingController();
  final _valorHoraController = TextEditingController();
  final _observacoesController = TextEditingController();

  bool _coberta = false;
  bool _iluminacao = true;
  bool _ativa = true;

  bool get _isEditing => widget.quadraId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _loadQuadraData();
    }
  }

  void _loadQuadraData() {
    final state = context.read<QuadraBloc>().state;
    if (state is QuadrasLoaded) {
      final quadra = state.quadras.firstWhere(
        (q) => q.id == widget.quadraId,
      );
      _nomeController.text = quadra.nome;
      _tipoPisoController.text = quadra.tipoPiso ?? '';
      _valorHoraController.text = quadra.valorHora?.toStringAsFixed(2) ?? '';
      _observacoesController.text = quadra.observacoes ?? '';
      _coberta = quadra.coberta;
      _iluminacao = quadra.iluminacao;
      _ativa = quadra.ativa;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tipoPisoController.dispose();
    _valorHoraController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final valorHora = _valorHoraController.text.isEmpty ? null : double.tryParse(_valorHoraController.text.replaceAll(',', '.'));

      if (_isEditing) {
        context.read<QuadraBloc>().add(
              UpdateQuadra(
                id: widget.quadraId!,
                nome: _nomeController.text.trim(),
                tipoPiso: _tipoPisoController.text.trim().isEmpty ? null : _tipoPisoController.text.trim(),
                valorHora: valorHora,
                coberta: _coberta,
                iluminacao: _iluminacao,
                ativa: _ativa,
                observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
              ),
            );
      } else {
        context.read<QuadraBloc>().add(
              CreateQuadra(
                arenaId: widget.arenaId,
                nome: _nomeController.text.trim(),
                tipoPiso: _tipoPisoController.text.trim().isEmpty ? null : _tipoPisoController.text.trim(),
                valorHora: valorHora,
                coberta: _coberta,
                iluminacao: _iluminacao,
                ativa: _ativa,
                observacoes: _observacoesController.text.trim().isEmpty ? null : _observacoesController.text.trim(),
              ),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Quadra' : 'Nova Quadra'),
        backgroundColor: const Color(0xFF00A86B),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<QuadraBloc, QuadraState>(
        listener: (context, state) {
          if (state is QuadraOperationSuccess) {
            Navigator.pop(context);
          } else if (state is QuadraError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Quadra *',
                    hintText: 'Ex: Quadra 1, Quadra Principal',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.sports_tennis),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor, informe o nome da quadra';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tipoPisoController,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Piso',
                    hintText: 'Ex: Areia, Grama Sintética, Cimento',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.layers),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _valorHoraController,
                  decoration: const InputDecoration(
                    labelText: 'Valor por Hora',
                    hintText: 'Ex: 100.00',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                    prefixText: 'R\$ ',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final valor = double.tryParse(value.replaceAll(',', '.'));
                      if (valor == null || valor < 0) {
                        return 'Informe um valor válido';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Características',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Quadra Coberta'),
                  subtitle: const Text('Protegida contra chuva'),
                  value: _coberta,
                  onChanged: (value) => setState(() => _coberta = value),
                  activeColor: const Color(0xFF00A86B),
                ),
                SwitchListTile(
                  title: const Text('Iluminação'),
                  subtitle: const Text('Possui iluminação artificial'),
                  value: _iluminacao,
                  onChanged: (value) => setState(() => _iluminacao = value),
                  activeColor: const Color(0xFF00A86B),
                ),
                SwitchListTile(
                  title: const Text('Quadra Ativa'),
                  subtitle: const Text('Disponível para reservas'),
                  value: _ativa,
                  onChanged: (value) => setState(() => _ativa = value),
                  activeColor: const Color(0xFF00A86B),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _observacoesController,
                  decoration: const InputDecoration(
                    labelText: 'Observações',
                    hintText: 'Informações adicionais sobre a quadra',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                BlocBuilder<QuadraBloc, QuadraState>(
                  builder: (context, state) {
                    final isLoading = state is QuadraLoading;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
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
                          : Text(
                              _isEditing ? 'Salvar Alterações' : 'Cadastrar Quadra',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
