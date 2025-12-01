import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

class VehicleSearchCard extends StatelessWidget {
  final String plate;
  final String model;
  final String owner;
  final String totalValue;
  final VoidCallback? onTap;

  const VehicleSearchCard({
    super.key,
    required this.plate,
    required this.model,
    required this.owner,
    required this.totalValue,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícone do carro em um círculo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.directions_car_rounded,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                
                // Informações do veículo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placa em destaque
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          plate.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Modelo do veículo
                      Text(
                        model,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      
                      // Proprietário
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              owner,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Valor total
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalValue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(width: 8),
                
                // Seta para indicar ação
                Icon(
                  Icons.chevron_right_rounded,
                  size: 24,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
