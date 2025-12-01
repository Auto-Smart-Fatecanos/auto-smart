import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/colors.dart';
import '../../features/checkin/model/repository/checklist_repository_impl.dart';
import '../../features/orcamentos/model/repository/orcamento_repository_impl.dart';

class AuthenticatedImageWidget extends StatefulWidget {
  final String path;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool isOrcamento;

  const AuthenticatedImageWidget({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.isOrcamento = false,
  });

  @override
  State<AuthenticatedImageWidget> createState() => _AuthenticatedImageWidgetState();
}

class _AuthenticatedImageWidgetState extends State<AuthenticatedImageWidget> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(AuthenticatedImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path || oldWidget.isOrcamento != widget.isOrcamento) {
      _imageBytes = null;
      _isLoading = true;
      _hasError = false;
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    try {
      final String imageUrl;
      if (widget.isOrcamento) {
        final repository = OrcamentoRepositoryImpl();
        imageUrl = repository.getOrcamentoPhotoUrl(widget.path);
      } else {
        final repository = ChecklistRepositoryImpl();
        imageUrl = repository.getChecklistPhotoUrl(widget.path);
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      final headers = <String, String>{};
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await http.get(
        Uri.parse(imageUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            _imageBytes = response.bodyBytes;
            _isLoading = false;
            _hasError = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          );
    }

    if (_hasError || _imageBytes == null) {
      return widget.errorWidget ??
          Container(
            color: Colors.grey[300],
            child: const Icon(Icons.directions_car, color: Colors.white, size: 40),
          );
    }

    return Image.memory(
      _imageBytes!,
      width: double.infinity,
      height: double.infinity,
      fit: widget.fit,
    );
  }
}

