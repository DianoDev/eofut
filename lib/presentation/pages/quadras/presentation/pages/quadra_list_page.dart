import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as quadra_di;
import '../bloc/quadra_bloc.dart';
import '../bloc/quadra_event.dart';
import '../bloc/quadra_state.dart';
import 'quadra_form_page.dart';

class QuadrasListPage extends StatelessWidget {
  final String arenaId;

  const QuadrasListPage({
    super.key,
    required this.arenaId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => quadra_di.sl<QuadraBloc>()..add(LoadQuadras(arenaId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Minhas Quadras'),
          backgroundColor: const Color(0xFF00A86B),
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<QuadraBloc, QuadraState>(
          listener: (context, state) {
            if (state is QuadraOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is QuadraError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is QuadraLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is QuadrasLoaded) {
              if (state.quadras.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sports_tennis,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhuma quadra cadastrada',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicione sua primeira quadra',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<QuadraBloc>().add(LoadQuadras(arenaId));
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.quadras.length,
                  itemBuilder: (context, index) {
                    final quadra = state.quadras[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: quadra.ativa ? const Color(0xFF00A86B) : Colors.grey,
                          child: Icon(
                            quadra.coberta ? Icons.roofing : Icons.wb_sunny,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          quadra.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (quadra.tipoPiso != null) Text('Piso: ${quadra.tipoPiso}'),
                            if (quadra.valorHora != null)
                              Text(
                                'R\$ ${quadra.valorHora!.toStringAsFixed(2)}/hora',
                                style: const TextStyle(
                                  color: Color(0xFF00A86B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            Row(
                              children: [
                                if (quadra.coberta)
                                  const Chip(
                                    label: Text('Coberta'),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                if (quadra.coberta && quadra.iluminacao) const SizedBox(width: 4),
                                if (quadra.iluminacao)
                                  const Chip(
                                    label: Text('Iluminação'),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                              ],
                            ),
                          ],
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'toggle',
                              child: Row(
                                children: [
                                  Icon(
                                    quadra.ativa ? Icons.visibility_off : Icons.visibility,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(quadra.ativa ? 'Desativar' : 'Ativar'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 20, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    'Excluir',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            switch (value) {
                              case 'edit':
                                _editQuadra(context, quadra.id);
                                break;
                              case 'toggle':
                                _toggleQuadra(context, quadra.id, !quadra.ativa);
                                break;
                              case 'delete':
                                _deleteQuadra(context, quadra.id, quadra.nome);
                                break;
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const Center(
              child: Text('Erro ao carregar quadras'),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _addQuadra(context),
          backgroundColor: const Color(0xFF00A86B),
          icon: const Icon(Icons.add),
          label: const Text('Nova Quadra'),
        ),
      ),
    );
  }

  void _addQuadra(BuildContext context) {
    final bloc = context.read<QuadraBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: QuadraFormPage(arenaId: arenaId),
        ),
      ),
    );
  }

  void _editQuadra(BuildContext context, String quadraId) {
    final bloc = context.read<QuadraBloc>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: bloc,
          child: QuadraFormPage(
            arenaId: arenaId,
            quadraId: quadraId,
          ),
        ),
      ),
    );
  }

  void _toggleQuadra(BuildContext context, String quadraId, bool ativa) {
    context.read<QuadraBloc>().add(ToggleQuadraStatus(quadraId, ativa));
  }

  void _deleteQuadra(BuildContext context, String quadraId, String nome) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: Text('Deseja realmente excluir a quadra "$nome"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<QuadraBloc>().add(DeleteQuadra(quadraId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
