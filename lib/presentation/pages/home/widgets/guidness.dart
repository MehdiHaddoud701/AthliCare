import 'package:flutter/material.dart';
import 'package:athlicare/presentation/widgets/tipscard.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:athlicare/logic/guidance_cubit.dart';

class GuidanceCardWidget extends StatelessWidget {
  final String title;
  final double screenWidth;
  final String imageUrl;
  final int articleId;

  const GuidanceCardWidget({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.screenWidth,
    required this.articleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get articles from Cubit
        final articles = context.read<GuidanceCubit>().getArticles();

        // Find the article by ID
        final article = articles.firstWhere(
          (art) => art['articleId'] == articleId,
          orElse: () => {
            'title': title,
            'imageUrl': imageUrl,
            'description': '',
            'fullDescription': '',
            'tips': [],
          },
        );

        // Navigate to the tips page with this specific article
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: context.read<GuidanceCubit>(),
              child: ArticleDetailScreen(articleData: article),
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth / 2 - 20,
        margin: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 170,
              width: screenWidth / 2 - 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[900],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Import this from your tipscard.dart - it's the ArticleDetailScreen
// The import should be: import 'package:athlicare/presentation/widgets/tipscard.dart' as tipscard;
// Then use: tipscard.ArticleDetailScreen
