import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'models/flashcard.dart';
import 'services/flashcard_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline AI Micro-Learning',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlashcardRepository _repository = FlashcardRepository();
  List<Flashcard> _flashcards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  // Load flashcards from local SQLite storage (100% Offline)
  Future<void> _loadFlashcards() async {
    setState(() => _isLoading = true);
    final cards = await _repository.getFlashcards();
    setState(() {
      _flashcards = cards;
      _isLoading = false;
    });
  }

  // Add a sample offline flashcard
  Future<void> _addNewFlashcard() async {
    var uuid = const Uuid();
    final newCard = Flashcard(
      id: uuid.v4(),
      question: 'What is an Offline-First Architecture?',
      answer: 'An architecture that prioritizes local storage so the app works without internet.',
      dueDate: DateTime.now().toIso8601String(),
    );

    await _repository.insertFlashcard(newCard);
    _loadFlashcards(); // Refresh list from local DB
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Micro-Learning Platform'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _flashcards.isEmpty
              ? const Center(
                  child: Text(
                    'No flashcards stored offline yet!\nTap "+" to add one.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _flashcards.length,
                  itemBuilder: (context, index) {
                    final card = _flashcards[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(card.question,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(card.answer),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _repository.deleteFlashcard(card.id);
                            _loadFlashcards();
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewFlashcard,
        child: const Icon(Icons.add),
      ),
    );
  }
}
