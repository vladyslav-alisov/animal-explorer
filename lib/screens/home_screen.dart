import 'package:animal_explorer/providers/animal_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'animal_list_screen.dart';
import 'quiz_screen.dart';
import 'match_game_screen.dart';
import 'animal_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final animalProvider = Provider.of<AnimalProvider>(context);
    final featured = animalProvider.featuredAnimal;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.pets_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Outfit',
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Animal ',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        TextSpan(
                          text: 'Explorer',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Featured Animal'),
                  const SizedBox(height: 12),
                  _buildFeaturedCard(context, featured),
                  const SizedBox(height: 48),
                  _buildSectionTitle(context, 'Games & Learning'),
                  const SizedBox(height: 12),
                  _buildNavigationGrid(context),
                  const SizedBox(height: 48),
                  _buildQuickStats(context, animalProvider),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, dynamic featured) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AnimalDetailScreen(animal: featured),
        ),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.8),
              Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  featured.imagePath,
                  height: 150,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.pets, size: 100, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Animal of the Day',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    featured.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      featured.funFact,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
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

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildNavCard(
          context,
          'Encyclopedia',
          'Learn about animals',
          Icons.menu_book_rounded,
          const Color(0xFFE8F5E9),
          const Color(0xFF4CAF50),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnimalListScreen()),
          ),
        ),
        _buildNavCard(
          context,
          'Quiz Time',
          'Test your knowledge',
          Icons.extension_rounded,
          const Color(0xFFFFF3E0),
          const Color(0xFFFF9800),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizScreen()),
          ),
        ),
        _buildNavCard(
          context,
          'Match Game',
          'Find the pairs',
          Icons.grid_view_rounded,
          const Color(0xFFE3F2FD),
          const Color(0xFF2196F3),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MatchGameScreen()),
          ),
        ),
        _buildNavCard(
          context,
          'Favorites',
          'Your saved animals',
          Icons.favorite_rounded,
          const Color(0xFFFCE4EC),
          const Color(0xFFE91E63),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const AnimalListScreen(showFavoritesOnly: true),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: bgColor, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              subtitle,
              style: TextStyle(color: Colors.black54, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, AnimalProvider provider) {
    const int totalPossiblePoints = 12 + 10; // 12 animals + 10 quiz points
    final int currentPoints =
        provider.favoriteIds.length + provider.bestQuizScore;
    final int progressPercent = ((currentPoints / totalPossiblePoints) * 100)
        .toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Favorites',
            '${provider.favoriteIds.length}',
            Icons.favorite,
            Colors.pink,
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          _buildStatItem(
            'Progress',
            '$progressPercent%',
            Icons.stars,
            Colors.amber,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }
}
