import 'package:eofut/presentation/pages/professores/presentation/pages/professor_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/formatters.dart';
import 'package:eofut/presentation/pages/arenas/injection_container.dart' as arena_di;
import '../bloc/arena_bloc.dart';
import '../bloc/arena_event.dart';
import '../bloc/arena_state.dart';

class ArenasListPage extends StatefulWidget {
  const ArenasListPage({super.key});

  @override
  State<ArenasListPage> createState() => _ArenasListPageState();
}

class _ArenasListPageState extends State<ArenasListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => arena_di.sl<ArenaBloc>()..add(const LoadArenasEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Arenas'),
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
                            context.read<ArenaBloc>().add(const LoadArenasEvent());
                          },
                        )
                      : null,
                ),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    context.read<ArenaBloc>().add(
                          SearchArenasEvent(cidade: value),
                        );
                  }
                },
              ),
            ),

            // Lista de arenas
            Expanded(
              child: BlocBuilder<ArenaBloc, ArenaState>(
                builder: (context, state) {
                  if (state is ArenaLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is ArenaError) {
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
                              context.read<ArenaBloc>().add(const LoadArenasEvent());
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ArenaEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.sports_volleyball,
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

                  if (state is ArenaLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ArenaBloc>().add(const LoadArenasEvent());
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.arenas.length,
                        itemBuilder: (context, index) {
                          final arena = state.arenas[index];
                          return _ArenaCard(
                            nome: arena.nome,
                            cidade: arena.cidade,
                            estado: arena.estado,
                            endereco: arena.endereco,
                            valorHora: arena.valorHora,
                            rating: arena.rating,
                            totalAvaliacoes: arena.totalAvaliacoes,
                            numeroQuadras: arena.numeroQuadras,
                            fotos: arena.fotos,
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_) => const ProfessoresListPage()),
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
          parentContext.read<ArenaBloc>().add(
                SearchArenasEvent(
                  cidade: cidade,
                  estado: estado,
                ),
              );
        },
      ),
    );
  }
}

class _ArenaCard extends StatelessWidget {
  final String nome;
  final String cidade;
  final String estado;
  final String endereco;
  final double valorHora;
  final double rating;
  final int totalAvaliacoes;
  final int numeroQuadras;
  final List<String> fotos;
  final VoidCallback onTap;

  const _ArenaCard({
    required this.nome,
    required this.cidade,
    required this.estado,
    required this.endereco,
    required this.valorHora,
    required this.rating,
    required this.totalAvaliacoes,
    required this.numeroQuadras,
    required this.fotos,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da arena
            if (fotos.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  fotos.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.sports_volleyball,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sports_volleyball,
                    size: 64,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Informações da arena
            Padding(
              padding: const EdgeInsets.all(16),
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

                  // Localização
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '$cidade, $estado',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Endereço
                  Row(
                    children: [
                      Icon(Icons.place, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          endereco,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Informações adicionais
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.sports_volleyball,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$numeroQuadras ${numeroQuadras == 1 ? 'quadra' : 'quadras'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${Formatters.formatMoney(valorHora)}/hora',
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
