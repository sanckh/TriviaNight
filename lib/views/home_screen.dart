import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:trivia_night/models/categories.dart';
import 'package:trivia_night/widgets/quiz_options.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  Color _getTileColor(BuildContext context, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<Color> tileColors = [
      colorScheme.primaryContainer,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];
    return tileColors[index % tileColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        elevation: 0,
      ),
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              height: 200,
            ),
          ),
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    "Select a category to start the quiz",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 1000 ? 7 : MediaQuery.of(context).size.width > 600 ? 5 : 3,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCategoryItem(context, index),
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    Category category = categories[index];
    return Card(
      color: _getTileColor(context, index),
      shadowColor: Theme.of(context).colorScheme.shadow,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () => _categoryPressed(context, category),
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (category.icon != null) Icon(category.icon, size: 24.0), // Consistent icon size
            if (category.icon != null) SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                category.name,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                minFontSize: 10.0,
                textAlign: TextAlign.center,
                maxLines: 3,
                wrapWords: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _categoryPressed(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) => BottomSheet(
        builder: (_) => QuizOptionsDialog(
          category: category,
        ),
        onClosing: () {},
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
    );
  }
}
