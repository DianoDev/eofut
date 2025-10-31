import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eofut/core/utils/formatters.dart';
import '../bloc/campeonato_bloc.dart';
import '../bloc/campeonato_event.dart';
import '../bloc/campeonato_state.dart';
import '../../injection_container.dart' as campeonato_di;
import 'campeonato_form_page.dart';

class CampeonatoDetailPage extends StatelessWidget {
  final String campeonatoId;
  final bool canEdit;

  const CampeonatoDetailPage({
    super.key,
    required this.campeonatoId,
    this.canEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => campeonato_di.sl<CampeonatoBloc>()..add(LoadCampeonatoByIdEvent(id: campeonatoId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes do Campeonato'),
          actions: canEdit
              ? [
                  BlocBuilder<CampeonatoBloc, CampeonatoState>(
                    builder: (context, state) {
                      if (state is CampeonatoDetailLoaded) {
                        return IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CampeonatoFormPage(
                                  campeonato: state.campeonato,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ]
              : null,
        ),
        body: BlocBuilder<CampeonatoBloc, CampeonatoState>(
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
                        context.read<CampeonatoBloc>().add(
                              LoadCampeonatoByIdEvent(id: campeonatoId),
                            );
                      },
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            if (state is CampeonatoDetailLoaded) {
              final campeonato = state.campeonato;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fotos
                    if (campeonato.fotos.isNotEmpty)
                      SizedBox(
                        height: 300,
                        child: PageView.builder(
                          itemCount: campeonato.fotos.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              campeonato.fotos[index],
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      )
                    else
                      Container(
                        height: 300,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título e Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  campeonato.nome,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ),
                              _StatusBadge(status: campeonato.status.toString().split('.').last),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Descrição
                          Text(
                            campeonato.descricao,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),

                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 16),

                          // Informações
                          _InfoRow(
                            icon: Icons.calendar_today,
                            label: 'Período',
                            value: '${Formatters.formatDate(campeonato.dataInicio)} - ${Formatters.formatDate(campeonato.dataFim)}',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.location_on,
                            label: 'Local',
                            value: '${campeonato.cidade}, ${campeonato.estado}',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.people,
                            label: 'Vagas',
                            value: '${campeonato.totalInscritos}/${campeonato.vagas} inscritos',
                          ),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.attach_money,
                            label: 'Inscrição',
                            value: Formatters.formatMoney(campeonato.valorInscricao),
                          ),

                          if (campeonato.categorias.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.category,
                              label: 'Categorias',
                              value: campeonato.categorias.join(', '),
                            ),
                          ],

                          if (campeonato.nivelMinimo != null) ...[
                            const SizedBox(height: 12),
                            _InfoRow(
                              icon: Icons.bar_chart,
                              label: 'Nível Mínimo',
                              value: campeonato.nivelMinimo!,
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Premiação
                          if (campeonato.premiacao != null && campeonato.premiacao!.isNotEmpty) ...[
                            const Text(
                              'Premiação',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.amber[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.amber),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.military_tech, color: Colors.amber, size: 32),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      campeonato.premiacao!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],

                          // Regras
                          if (campeonato.regras != null && campeonato.regras!.isNotEmpty) ...[
                            const Text(
                              'Regras',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                campeonato.regras!,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
        bottomNavigationBar: BlocBuilder<CampeonatoBloc, CampeonatoState>(
          builder: (context, state) {
            if (state is CampeonatoDetailLoaded && !canEdit && state.campeonato.isAberto && state.campeonato.temVagas) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade de inscrição em desenvolvimento'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Inscrever-se'),
                ),
              );
            }
            return const SizedBox();
          },
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF00A86B)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
