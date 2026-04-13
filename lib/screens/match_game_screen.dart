import 'package:flutter/material.dart';
import '../data/animal_data.dart';
import '../models/animal_model.dart';

class MatchGameScreen extends StatefulWidget {
  const MatchGameScreen({super.key});

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen> {
  late List<Animal> _gameAnimals;
  late List<Animal> _shuffledNames;
  
  String? _selectedImageId;
  String? _selectedNameId;
  
  final Set<String> _matchedIds = {};

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      _gameAnimals = List.from(AnimalData.animals)..shuffle();
      _gameAnimals = _gameAnimals.take(5).toList(); // 5 pairs per game
      
      _shuffledNames = List.from(_gameAnimals)..shuffle();
      _selectedImageId = null;
      _selectedNameId = null;
      _matchedIds.clear();
    });
  }

  void _handleImageTap(String id) {
    if (_matchedIds.contains(id)) return;
    
    setState(() {
      _selectedImageId = id;
      _checkMatch();
    });
  }

  void _handleNameTap(String id) {
    if (_matchedIds.contains(id)) return;
    
    setState(() {
      _selectedNameId = id;
      _checkMatch();
    });
  }

  void _checkMatch() {
    if (_selectedImageId != null && _selectedNameId != null) {
      if (_selectedImageId == _selectedNameId) {
        // Match!
        setState(() {
          _matchedIds.add(_selectedImageId!);
          _selectedImageId = null;
          _selectedNameId = null;
          
          if (_matchedIds.length == _gameAnimals.length) {
            _showWinDialog();
          }
        });
      } else {
        // No match - reset after delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (!mounted) return;
          setState(() {
            _selectedImageId = null;
            _selectedNameId = null;
          });
        });
      }
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('You Matched Them All!', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events_rounded, size: 80, color: Colors.amber),
            const SizedBox(height: 16),
            const Text('Great job! You know your animals!', textAlign: TextAlign.center),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back Home'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startNewGame();
                },
                child: const Text('Play Again'),
              ),
            ],
          ),
        ],
      ),
    ).then((_) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match Game'),
        actions: [
          IconButton(
            onPressed: _startNewGame,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text(
              'Match the image with the correct name!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Row(
                children: [
                  // Images column
                  Expanded(
                    child: Column(
                      children: _gameAnimals.map((animal) => _buildImageItem(animal)).toList(),
                    ),
                  ),
                  const SizedBox(width: 24),
                  // Names column
                  Expanded(
                    child: Column(
                      children: _shuffledNames.map((animal) => _buildNameItem(animal)).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageItem(Animal animal) {
    bool isSelected = _selectedImageId == animal.id;
    bool isMatched = _matchedIds.contains(animal.id);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => _handleImageTap(animal.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isMatched ? Colors.green[50] : (isSelected ? Colors.blue[50] : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isMatched ? Colors.green : (isSelected ? Colors.blue : Colors.grey[200]!),
                width: 3,
              ),
              boxShadow: isSelected ? [BoxShadow(color: Colors.blue.withOpacity(0.2), blurRadius: 10)] : null,
            ),
            child: Center(
              child: Opacity(
                opacity: isMatched ? 0.4 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    animal.imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const Icon(Icons.pets, size: 40, color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameItem(Animal animal) {
    bool isSelected = _selectedNameId == animal.id;
    bool isMatched = _matchedIds.contains(animal.id);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () => _handleNameTap(animal.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isMatched ? Colors.green[50] : (isSelected ? Colors.blue[50] : Colors.white),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isMatched ? Colors.green : (isSelected ? Colors.blue : Colors.grey[200]!),
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                animal.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isMatched ? Colors.green : (isSelected ? Colors.blue : Colors.black87),
                  decoration: isMatched ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
