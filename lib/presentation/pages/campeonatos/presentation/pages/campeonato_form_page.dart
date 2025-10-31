import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/validators.dart';
import '../bloc/campeonato_bloc.dart';
import '../bloc/campeonato_event.dart';
import '../bloc/campeonato_state.dart';
import '../../injection_container.dart' as campeonato_di;

class CampeonatoFormPage extends StatefulWidget {
  final dynamic campeonato;
  final String? organizadorId;

  const CampeonatoFormPage({
    super.key,
    this.campeonato,
    this.organizadorId,
  });

  @override
  State<CampeonatoFormPage> createState() => _CampeonatoFormPageState();
}

class _CampeonatoFormPageState extends State<CampeonatoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _vagasController = TextEditingController();
  final _valorController = TextEditingController();
  final _premiacaoController = TextEditingController();
  final _regrasController = TextEditingController();

  DateTime? _dataInicio;
  DateTime? _dataFim;
  String? _nivelMinimo;
  List<String> _categoriasSelecionadas = [];

  final List<String> _categoriasDisponiveis = [
    'Masculino',
    'Feminino',
    'Misto',
  ];

  final List<String> _niveisDisponiveis = [
    'Iniciante',
    'Intermediário',
    'Avançado',
    'Profissional',
  ];

  bool get isEditing => widget.campeonato != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _loadCampeonato();
    }
  }

  void _loadCampeonato() {
    final c = widget.campeonato;
    _nomeController.text = c.nome;
    _descricaoController.text = c.descricao;
    _cidadeController.text = c.cidade;
    _estadoController.text = c.estado;
    _vagasController.text = c.vagas.toString();
    _valorController.text = c.valorInscricao.toString();
    _premiacaoController.text = c.premiacao ?? '';
    _regrasController.text = c.regras ?? '';
    _dataInicio = c.dataInicio;
    _dataFim = c.dataFim;
    _nivelMinimo = c.nivelMinimo;
    _categoriasSelecionadas = List<String>.from(c.categorias);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _vagasController.dispose();
    _valorController.dispose();
    _premiacaoController.dispose();
    _regrasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => campeonato_di.sl<CampeonatoBloc>(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Editar Campeonato' : 'Novo Campeonato'),
          ),
          body: BlocConsumer<CampeonatoBloc, CampeonatoState>(
            listener: (context, state) {
              if (state is CampeonatoCreated || state is CampeonatoUpdated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing ? 'Campeonato atualizado com sucesso' : 'Campeonato criado com sucesso'),
                  ),
                );
                Navigator.pop(context);
              } else if (state is CampeonatoError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is CampeonatoLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome do Campeonato *',
                          hintText: 'Ex: Copa Verão 2024',
                          prefixIcon: Icon(Icons.emoji_events),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'Nome'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descricaoController,
                        decoration: const InputDecoration(
                          labelText: 'Descrição *',
                          hintText: 'Descreva o campeonato',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 3,
                        validator: (value) => Validators.validateRequired(value, 'Descrição'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField(
                              label: 'Data Início *',
                              value: _dataInicio,
                              onTap: () => _selectDate(context, true),
                              enabled: !isLoading,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField(
                              label: 'Data Fim *',
                              value: _dataFim,
                              onTap: () => _selectDate(context, false),
                              enabled: !isLoading,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _cidadeController,
                        decoration: const InputDecoration(
                          labelText: 'Cidade *',
                          hintText: 'Ex: Cuiabá',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (value) => Validators.validateRequired(value, 'Cidade'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _estadoController,
                        decoration: const InputDecoration(
                          labelText: 'Estado *',
                          hintText: 'Ex: MT',
                          prefixIcon: Icon(Icons.map),
                        ),
                        textCapitalization: TextCapitalization.characters,
                        maxLength: 2,
                        validator: (value) => Validators.validateRequired(value, 'Estado'),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Categorias *',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _categoriasDisponiveis.map((categoria) {
                          final isSelected = _categoriasSelecionadas.contains(categoria);
                          return FilterChip(
                            label: Text(categoria),
                            selected: isSelected,
                            onSelected: isLoading
                                ? null
                                : (selected) {
                                    setState(() {
                                      if (selected) {
                                        _categoriasSelecionadas.add(categoria);
                                      } else {
                                        _categoriasSelecionadas.remove(categoria);
                                      }
                                    });
                                  },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _nivelMinimo,
                        decoration: const InputDecoration(
                          labelText: 'Nível Mínimo',
                          prefixIcon: Icon(Icons.bar_chart),
                        ),
                        items: _niveisDisponiveis.map((nivel) {
                          return DropdownMenuItem(
                            value: nivel,
                            child: Text(nivel),
                          );
                        }).toList(),
                        onChanged: isLoading
                            ? null
                            : (value) {
                                setState(() => _nivelMinimo = value);
                              },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _vagasController,
                        decoration: const InputDecoration(
                          labelText: 'Número de Vagas *',
                          hintText: 'Ex: 16',
                          prefixIcon: Icon(Icons.people),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Número de vagas é obrigatório';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Insira um número válido';
                          }
                          return null;
                        },
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _valorController,
                        decoration: const InputDecoration(
                          labelText: 'Valor da Inscrição *',
                          hintText: 'Ex: 50.00',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Valor é obrigatório';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Insira um valor válido';
                          }
                          return null;
                        },
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _premiacaoController,
                        decoration: const InputDecoration(
                          labelText: 'Premiação',
                          hintText: 'Descreva a premiação',
                          prefixIcon: Icon(Icons.military_tech),
                        ),
                        maxLines: 2,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _regrasController,
                        decoration: const InputDecoration(
                          labelText: 'Regras',
                          hintText: 'Descreva as regras do campeonato',
                          prefixIcon: Icon(Icons.rule),
                        ),
                        maxLines: 3,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(isEditing ? 'Atualizar' : 'Criar Campeonato'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}' : 'Selecione',
          style: TextStyle(
            color: value != null ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isInicio) async {
    final now = DateTime.now();
    final initialDate = isInicio ? (_dataInicio ?? now) : (_dataFim ?? _dataInicio ?? now);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isInicio) {
          _dataInicio = picked;
          if (_dataFim != null && _dataFim!.isBefore(picked)) {
            _dataFim = null;
          }
        } else {
          _dataFim = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_dataInicio == null || _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione as datas do campeonato')),
      );
      return;
    }

    if (_categoriasSelecionadas.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione ao menos uma categoria')),
      );
      return;
    }

    if (isEditing) {
      context.read<CampeonatoBloc>().add(
            UpdateCampeonatoEvent(
              id: widget.campeonato.id,
              nome: _nomeController.text,
              descricao: _descricaoController.text,
              dataInicio: _dataInicio,
              dataFim: _dataFim,
              cidade: _cidadeController.text,
              estado: _estadoController.text.toUpperCase(),
              categorias: _categoriasSelecionadas,
              nivelMinimo: _nivelMinimo,
              vagas: int.parse(_vagasController.text),
              valorInscricao: double.parse(_valorController.text),
              premiacao: _premiacaoController.text.isNotEmpty ? _premiacaoController.text : null,
              regras: _regrasController.text.isNotEmpty ? _regrasController.text : null,
            ),
          );
    } else {
      context.read<CampeonatoBloc>().add(
            CreateCampeonatoEvent(
              nome: _nomeController.text,
              descricao: _descricaoController.text,
              dataInicio: _dataInicio!,
              dataFim: _dataFim!,
              organizadorId: widget.organizadorId!,
              cidade: _cidadeController.text,
              estado: _estadoController.text.toUpperCase(),
              categorias: _categoriasSelecionadas,
              nivelMinimo: _nivelMinimo,
              vagas: int.parse(_vagasController.text),
              valorInscricao: double.parse(_valorController.text),
              premiacao: _premiacaoController.text.isNotEmpty ? _premiacaoController.text : null,
              regras: _regrasController.text.isNotEmpty ? _regrasController.text : null,
            ),
          );
    }
  }
}
