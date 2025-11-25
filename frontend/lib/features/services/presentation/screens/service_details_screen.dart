import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/theme/colors.dart';
import '../../../checkin/presentation/screens/checkin_screen.dart';
import '../../../orcamentos/model/orcamento_item_model.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String id;
  final String title;
  final String clientName;
  final String phone;
  final String status;
  final Color statusColor;
  final List<OrcamentoItemModel> pecas;
  final List<OrcamentoItemModel> servicos;

  const ServiceDetailsScreen({
    super.key,
    required this.id,
    required this.title,
    required this.clientName,
    required this.phone,
    required this.status,
    required this.statusColor,
    required this.pecas,
    required this.servicos,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      appBar: const CustomAppBar(
        title: 'DETALHES',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
               padding: const EdgeInsets.all(20),
               decoration: BoxDecoration(
                 color: AppColors.white,
                 borderRadius: BorderRadius.circular(12),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.grey.withOpacity(0.1),
                     spreadRadius: 0,
                     blurRadius: 10,
                     offset: const Offset(0, 2),
                   ),
                 ],
               ),
               child: Stack(
                 children: [
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Container(
                             width: 75,
                             height: 75,
                             decoration: BoxDecoration(
                               color: AppColors.secondary,
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: const Icon(
                               Icons.directions_car,
                               color: AppColors.textSecondary,
                               size: 40,
                             ),
                           ),
                           const SizedBox(width: 12),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Expanded(
                                       child: Text(
                                         title,
                                         style: const TextStyle(
                                           fontSize: 20,
                                           fontWeight: FontWeight.bold,
                                           color: AppColors.textPrimary,
                                         ),
                                       ),
                                     ),
                                     const SizedBox(width: 8),
                                     Container(
                                       padding: const EdgeInsets.symmetric(
                                         horizontal: 12,
                                         vertical: 6,
                                       ),
                                       decoration: BoxDecoration(
                                         color: statusColor,
                                         borderRadius: BorderRadius.circular(16),
                                       ),
                                       child: Text(
                                         status,
                                         style: const TextStyle(
                                           color: AppColors.white,
                                           fontSize: 12,
                                           fontWeight: FontWeight.w600,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 12),
                                 Row(
                                   children: [
                                     const Icon(
                                       Icons.person,
                                       size: 16,
                                       color: AppColors.textSecondary,
                                     ),
                                     const SizedBox(width: 6),
                                     Expanded(
                                       child: Text(
                                         clientName,
                                         style: const TextStyle(
                                           fontSize: 14,
                                           color: AppColors.textSecondary,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 const SizedBox(height: 8),
                                 Row(
                                   children: [
                                     const Icon(
                                       Icons.phone,
                                       size: 16,
                                       color: AppColors.textSecondary,
                                     ),
                                     const SizedBox(width: 6),
                                     Expanded(
                                       child: Text(
                                         phone,
                                         style: const TextStyle(
                                           fontSize: 14,
                                           color: AppColors.textSecondary,
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ],
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                   Positioned(
                     bottom: 0,
                     right: 0,
                     child: Text(
                       '#$id',
                       style: const TextStyle(
                         fontSize: 14,
                         fontWeight: FontWeight.bold,
                         color: AppColors.textPrimary,
                       ),
                     ),
                   ),
                 ],
               ),
             ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Detalhes da manutenção',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Peças
                  if (pecas.isNotEmpty) ...[
                    const Text(
                      'Peças:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...pecas.map((peca) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              peca.descricao,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            'R\$ ${peca.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )),
                    if (servicos.isNotEmpty) const SizedBox(height: 16),
                  ],
                  
                  // Serviços
                  if (servicos.isNotEmpty) ...[
                    const Text(
                      'Serviços:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...servicos.map((servico) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              servico.descricao,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            'R\$ ${servico.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                  
                  // Mensagem quando não há itens
                  if (pecas.isEmpty && servicos.isEmpty)
                    const Text(
                      'Nenhum item cadastrado',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  
                  // Total
                  if (pecas.isNotEmpty || servicos.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'R\$ ${(pecas.fold<double>(0, (sum, item) => sum + item.valor) + servicos.fold<double>(0, (sum, item) => sum + item.valor)).toStringAsFixed(2).replaceAll('.', ',')}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Card de Check-in e Check-out
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Controle de Entrada/Saída',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Check-in (clicável)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckinScreen(
                            vehicleTitle: title,
                            clientName: clientName,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.login,
                              color: Colors.green,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Check-in',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '15/12/2024 às 08:30',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Divisor
                  Divider(
                    color: Colors.grey.withOpacity(0.2),
                    height: 1,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Check-out
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.logout,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Check-out',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              status == 'FINALIZADO' 
                                ? '15/12/2024 às 17:45' 
                                : 'Aguardando finalização',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: status == 'FINALIZADO' 
                                  ? AppColors.textPrimary 
                                  : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Tempo total (apenas se finalizado)
                  if (status == 'FINALIZADO') ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Tempo total: ',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '9h 15min',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
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

