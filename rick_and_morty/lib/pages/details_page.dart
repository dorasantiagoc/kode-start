import 'package:flutter/material.dart';
import 'package:rick_and_morty/components/app_bar_component.dart';
import 'package:rick_and_morty/components/detailed_character_component.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/repositories/character_repository.dart';
import 'package:rick_and_morty/theme/app_colors.dart';

class DetailsPage extends StatefulWidget {
  static const String routeId = '/details';

  const DetailsPage({super.key, required this.characterId});

  final int characterId;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final CharacterRepository _characterRepository = CharacterRepository();
  Character? _character;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCharacter();
  }

  Future<void> _loadCharacter() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final character = await _characterRepository.getById(widget.characterId);
      setState(() {
        _character = character;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: appBarComponent(context, isSecondPage: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColorDark),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar personagem',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadCharacter,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColorDark,
                foregroundColor: AppColors.white,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_character == null) {
      return const Center(
        child: Text(
          'Personagem não encontrado',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      );
    }

    return SingleChildScrollView(
      child: DetailedCharacterCard(character: _character!),
    );
  }
}
