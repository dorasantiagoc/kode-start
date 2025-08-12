import 'package:flutter/material.dart';
import 'package:rick_and_morty/components/app_bar_component.dart';
import 'package:rick_and_morty/components/character_card_component.dart';
import 'package:rick_and_morty/models/character.dart';
import 'package:rick_and_morty/theme/app_colors.dart';
import 'package:rick_and_morty/repositories/character_repository.dart';

class HomePage extends StatefulWidget {
  static const String routeId = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CharacterRepository _characterRepository = CharacterRepository();
  List<Character> _characters = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final List<String> targetCharacters = [
        'Baby Wizard',
        'Diane Sanchez',
        'Mr. Poopybutthole',
        'The Wizard',
        'High Pilot',
        'Glockenspiel Jerry',
      ];

      List<Character> characters = [];
      for (String characterName in targetCharacters) {
        try {
          final character = await _characterRepository.search(characterName);
          if (character.isNotEmpty) {
            characters.add(character.first);
          }
        } catch (e) {
          debugPrint('Personagem não encontrado: $characterName');
        }
      }

      setState(() {
        _characters = characters;
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
      appBar: appBarComponent(context),
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
              'Erro ao carregar personagens',
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
              onPressed: _loadCharacters,
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

    if (_characters.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum personagem encontrado',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCharacters,
      color: AppColors.primaryColorDark,
      backgroundColor: AppColors.backgroundColor,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15),
        itemCount: _characters.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final character = _characters[index];
          return CharacterCard(
            character: character,
            onTap: () {
              Navigator.pushNamed(context, '/details', arguments: character.id);
            },
          );
        },
      ),
    );
  }
}
