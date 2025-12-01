import 'package:flutter/material.dart';
import '../../../../core/widgets/authenticated_image_widget.dart';

class ServiceCard extends StatelessWidget {
  final String id;
  final String title;
  final String subtitle;
  final String phone;
  final String status;
  final Color statusColor;
  final VoidCallback? onTap;
  final String? vehiclePhotoPath;

  const ServiceCard({
    super.key,
    required this.id,
    required this.title,
    required this.subtitle,
    required this.phone,
    required this.status,
    required this.statusColor,
    this.onTap,
    this.vehiclePhotoPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Car Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: vehiclePhotoPath != null && vehiclePhotoPath!.isNotEmpty
                    ? AuthenticatedImageWidget(
                        key: ValueKey('$id-$vehiclePhotoPath'),
                        path: vehiclePhotoPath!,
                        fit: BoxFit.cover,
                        isOrcamento: true,
                        placeholder: Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                        errorWidget: Container(
                          color: Colors.grey[400],
                          child: const Icon(
                            Icons.directions_car,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[400],
                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        phone,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        id,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Arrow Icon with Circle
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.shade400,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}