import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/formatters.dart';
import 'package:eofut/presentation/pages/professores/injection_container.dart' as professor_di;
import '../bloc/professor_bloc.dart';
import '../bloc/professor_event.dart';
import '../bloc/professor_state.dart';

class ProfessoresListPage extends StatefulWidget {
  const ProfessoresListPage({super.key});

  @override
  State<ProfessoresListPage> createState() => _ProfessoresListPageState();
}

class _ProfessoresListPageState extends State<ProfessoresListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => professor_di.sl<ProfessorBloc>()..add(const LoadProfessoresEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Professores'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
        ),
        body: Column(
          children: [
            // Barra de busca
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por cidade...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            context.read<ProfessorBloc>().add(const LoadProfessoresEvent());
                          },
                        )
                      : null,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<ProfessorBloc>().add(
                          SearchProfessoresEvent(cidade: value),
                        );
                  }
                },
              ),
            ),

            // Lista de professores
            Expanded(
              child: BlocBuilder<ProfessorBloc, ProfessorState>(
                builder: (context, state) {
                  if (state is ProfessorLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ProfessorError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProfessorBloc>().add(const LoadProfessoresEvent());
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProfessorEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.school,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProfessorLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProfessorBloc>().add(const LoadProfessoresEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.professores.length,
                        itemBuilder: (context, index) {
                          final professor = state.professores[index];
                          return _ProfessorCard(
                            nome: professor.nome,
                            fotoUrl: professor.fotoUrl,
                            experienciaAnos: professor.experienciaAnos,
                            especialidades: professor.especialidades,
                            valorHoraAula: professor.valorHoraAula,
                            rating: professor.rating,
                            totalAvaliacoes: professor.totalAvaliacoes,
                            descricao: professor.descricao,
                            certificacoes: professor.certificacoes,
                            onTap: () {
                              // TODO: Navegar para detalhes do professor
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Professor: ${professor.nome}'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext parentContext) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterSheet(
        onApply: (cidade, estado) {
          parentContext.read<ProfessorBloc>().add(
                SearchProfessoresEvent(
                  cidade: cidade,
                  estado: estado,
                ),
              );
        },
      ),
    );
  }
}

class _ProfessorCard extends StatelessWidget {
  final String nome;
  final String? fotoUrl;
  final int experienciaAnos;
  final List<String> especialidades;
  final double valorHoraAula;
  final double rating;
  final int totalAvaliacoes;
  final String? descricao;
  final List<String> certificacoes;
  final VoidCallback onTap;

  const _ProfessorCard({
    required this.nome,
    this.fotoUrl,
    required this.experienciaAnos,
    required this.especialidades,
    required this.valorHoraAula,
    required this.rating,
    required this.totalAvaliacoes,
    this.descricao,
    required this.certificacoes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto do professor
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF00A86B),
                backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl!) : null,
                child: fotoUrl == null
                    ? Text(
                        Formatters.getInitials(nome),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Informações do professor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nome e rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            nome,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        if (rating > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Formatters.formatRating(rating),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (totalAvaliacoes > 0) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '($totalAvaliacoes)',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Experiência
                    Row(
                      children: [
                        Icon(Icons.work_outline, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '$experienciaAnos ${experienciaAnos == 1 ? 'ano' : 'anos'} de experiência',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Certificações
                    if (certificacoes.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.verified, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '${certificacoes.length} ${certificacoes.length == 1 ? 'certificação' : 'certificações'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Especialidades
                    if (especialidades.isNotEmpty) ...[
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: especialidades.take(3).map((especialidade) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00A86B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              especialidade,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF00A86B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Descrição
                    if (descricao != null && descricao!.isNotEmpty) ...[
                      Text(
                        descricao!,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],

                    // Valor
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Text(
                          '${Formatters.formatMoney(valorHoraAula)}/hora',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF00A86B),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final Function(String? cidade, String? estado) onApply;

  const _FilterSheet({required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();

  @override
  void dispose() {
    _cidadeController.dispose();
    _estadoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Filtros',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _cidadeController,
              decoration: const InputDecoration(
                labelText: 'Cidade',
                hintText: 'Ex: Cuiabá',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _estadoController,
              decoration: const InputDecoration(
                labelText: 'Estado',
                hintText: 'Ex: MT',
                prefixIcon: Icon(Icons.map),
              ),
              textCapitalization: TextCapitalization.characters,
              maxLength: 2,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onApply(
                  _cidadeController.text.isNotEmpty ? _cidadeController.text : null,
                  _estadoController.text.isNotEmpty ? _estadoController.text : null,
                );
                Navigator.pop(context);
              },
              child: const Text('Aplicar Filtros'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                _cidadeController.clear();
                _estadoController.clear();
                widget.onApply(null, null);
                Navigator.pop(context);
              },
              child: const Text('Limpar Filtros'),
            ),
          ],
        ),
      ),
    );
  }
}
