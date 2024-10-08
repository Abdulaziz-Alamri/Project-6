import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project6/src/Home/RecipeCard.dart';
import 'package:project6/src/Home/custom_drawer.dart';
import 'package:project6/data_layer/recipe_data.dart';
import 'package:project6/services/setup.dart';
import 'package:project6/theme/app_colors.dart';

import '../Add_Recipe/add_recipe.dart';
import '../../blocs/home_bloc/home_bloc.dart';
import '../../models/recipe.dart';
import '../../models/user.dart';

class HomePage extends StatelessWidget {
  final User user;
  const HomePage({super.key, required this.user});

  void _addNewRecipe(XFile image, String recipeTitle, String recipeDescription,
      HomeBloc bloc) {
    locator.get<RecipeData>().addRecipe(Recipe.fromJson({
          'recipeTitle': recipeTitle,
          'image': image.path,
          'recipeDescription': recipeDescription,
        }));
    bloc.add(LoadNewRecipeEvent());
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadDataEvent()),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is SuccessfulLoadState) {}
        },
        child: Builder(builder: (context) {
          final bloc = context.read<HomeBloc>();
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    final Map<String, dynamic>? newRecipe =
                        await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddRecipePage(),
                      ),
                    );

                    if (newRecipe != null) {
                      _addNewRecipe(
                          newRecipe['image'],
                          newRecipe['recipeTitle'],
                          newRecipe['recipeDescription'],
                          bloc);
                    }
                  },
                ),
              ],
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: AppColors.lighthread,
              title: Text(
                'Cooking Recipes',
                style: TextStyle(
                  fontSize: screenSize.width * 0.08,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            drawer:
                CustomDrawer(user: user, homeBloc: bloc), 
            body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              if (state is SuccessfulLoadState) {
                final recipes = state.recipes;

                return Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        child: Container(
                          height: screenSize.height * 0.4,
                          width: screenSize.width,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.lighthread,
                                AppColors.darkread,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: recipes.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No recipes yet. Add some!',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: recipes.length,
                                    itemBuilder: (context, index) {
                                      final recipe = recipes[index];
                                      return RecipeCard(
                                        recipeTitle: recipe.recipeName,
                                        imageFile: recipe.image,
                                        description: recipe.description,
                                        homeBloc: bloc,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is ErrorState) {
                return Center(child: Text('Error: ${state.message}'));
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
          );
        }),
      ),
    );
  }
}
