import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/formatters.dart';
import '../bloc/campeonato_bloc.dart';
import '../bloc/campeonato_event.dart';
import '../bloc/campeonato_state.dart';
import '../../injection_container.dart' as campeonato_di;
import 'campeonato_form_page.dart';
import 'campeonato_detail_page.dart';

class CampeonatosListPage extends StatefulWidget {
  final String? userId;
  final bool meusCampeonatos;

  const CampeonatosListPage({
    super.key,
    this.userId,
    this.meusCampeonatos = false,
  });

  @override
  State<CampeonatosListPage> createState() => _CampeonatosListPageState();
}

class _CampeonatosListPageState extends State<CampeonatosListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = campeonato_di.sl<CampeonatoBloc>();
        if (widget.meusCampeonatos && widget.userId != null) {
          bloc.add(LoadMeusCampeonatosEvent(organizadorId: widget.userId!));
        } else {
          bloc.add(const LoadCampeonatosEvent());
        }
        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.meusCampeonatos ? 'Meus Campeonatos' : 'Campeonatos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () => _showFilterDialog(context),
            ),
          ],
        ),
        body: Column(
          children: [
            if (!widget.meusCampeonatos)
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
                              context.read<CampeonatoBloc>().add(
                                    const LoadCampeonatosEvent(),
                                  );
                            },
                          )
                        : null,
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      context.read<CampeonatoBloc>().add(
                            SearchCampeonatosEvent(cidade: value),
                          );
                    }
                  },
                ),
              ),
            Expanded(
              child: BlocConsumer<CampeonatoBloc, CampeonatoState>(
                listener: (context, state) {
                  if (state is CampeonatoDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Campeonato deletado com sucesso'),
                      ),
                    );
                    if (widget.meusCampeonatos && widget.userId != null) {
                      context.read<CampeonatoBloc>().add(
                            LoadMeusCampeonatosEvent(organizadorId: widget.userId!),
                          );
                    } else {
                      context.read<CampeonatoBloc>().add(
                            const LoadCampeonatosEvent(),
                          );
                    }
                  }
                },
                builder: (context, state) {
                  if (state is CampeonatoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CampeonatoError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(state.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (widget.meusCampeonatos && widget.userId != null) {
                                context.read<CampeonatoBloc>().add(
                                      LoadMeusCampeonatosEvent(organizadorId: widget.userId!),
                                    );
                              } else {
                                context.read<CampeonatoBloc>().add(
                                      const LoadCampeonatosEvent(),
                                    );
                              }
                            },
                            child: const Text('Tentar novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is CampeonatoEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(state.message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  if (state is CampeonatosLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        if (widget.meusCampeonatos && widget.userId != null) {
                          context.read<CampeonatoBloc>().add(
                                LoadMeusCampeonatosEvent(organizadorId: widget.userId!),
                              );
                        } else {
                          context.read<CampeonatoBloc>().add(const LoadCampeonatosEvent());
                        }
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.campeonatos.length,
                        itemBuilder: (context, index) {
                          final campeonato = state.campeonatos[index];
                          return _CampeonatoCard(
                            campeonato: campeonato,
                            meusCampeonatos: widget.meusCampeonatos,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => CampeonatoDetailPage(
                                    campeonatoId: campeonato.id,
                                    canEdit: widget.meusCampeonatos,
                                  ),
                                ),
                              );
                            },
                            onDelete: widget.meusCampeonatos ? () => _confirmDelete(context, campeonato.id) : null,
                            onEdit: widget.meusCampeonatos
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CampeonatoFormPage(
                                          campeonato: campeonato,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
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
        floatingActionButton: widget.meusCampeonatos
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CampeonatoFormPage(
                        organizadorId: widget.userId!,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add),
              )
            : null,
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
        onApply: (cidade, estado, status) {
          parentContext.read<CampeonatoBloc>().add(
                SearchCampeonatosEvent(
                  cidade: cidade,
                  estado: estado,
                  status: status,
                ),
              );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Tem certeza que deseja deletar este campeonato? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<CampeonatoBloc>().add(DeleteCampeonatoEvent(id: id));
              Navigator.pop(dialogContext);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }
}

class _CampeonatoCard extends StatelessWidget {
  final dynamic campeonato;
  final bool meusCampeonatos;
  final VoidCallback onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _CampeonatoCard({
    required this.campeonato,
    required this.meusCampeonatos,
    required this.onTap,
    this.onDelete,
    this.onEdit,
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
            if (campeonato.fotos.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  campeonato.fotos.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                  ),
                ),
              )
            else
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          campeonato.nome,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      _StatusBadge(status: campeonato.status.toString().split('.').last),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${campeonato.cidade}, ${campeonato.estado}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${Formatters.formatDate(campeonato.dataInicio)} - ${Formatters.formatDate(campeonato.dataFim)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${campeonato.totalInscritos}/${campeonato.vagas} inscritos',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Text(
                        Formatters.formatMoney(campeonato.valorInscricao),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF00A86B),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  if (meusCampeonatos) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          onPressed: onEdit,
                          icon: const Icon(Icons.edit, size: 18),
                          label: const Text('Editar'),
                        ),
                        TextButton.icon(
                          onPressed: onDelete,
                          icon: const Icon(Icons.delete, size: 18),
                          label: const Text('Deletar'),
                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String text;

    switch (status.toLowerCase()) {
      case 'aberto':
        color = Colors.green;
        text = 'Aberto';
        break;
      case 'fechado':
        color = Colors.orange;
        text = 'Fechado';
        break;
      case 'cancelado':
        color = Colors.red;
        text = 'Cancelado';
        break;
      case 'concluido':
        color = Colors.blue;
        text = 'Concluído';
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  final Function(String? cidade, String? estado, String? status) onApply;

  const _FilterSheet({required this.onApply});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  String? _selectedStatus;

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
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
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
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.info_outline),
              ),
              items: const [
                DropdownMenuItem(value: 'aberto', child: Text('Aberto')),
                DropdownMenuItem(value: 'fechado', child: Text('Fechado')),
                DropdownMenuItem(value: 'concluido', child: Text('Concluído')),
                DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
              ],
              onChanged: (value) {
                setState(() => _selectedStatus = value);
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                widget.onApply(
                  _cidadeController.text.isNotEmpty ? _cidadeController.text : null,
                  _estadoController.text.isNotEmpty ? _estadoController.text : null,
                  _selectedStatus,
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
                setState(() => _selectedStatus = null);
                widget.onApply(null, null, null);
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
