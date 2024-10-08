import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project6/models/recipe.dart';
import 'package:project6/src/profile/bloc/profile_bloc.dart';
import 'package:project6/theme/app_colors.dart';

import '../../models/user.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  const ProfilePage({super.key, required this.user});

  void _pickImage(BuildContext context) {
    context.read<ProfileBloc>().add(PickImageEvent());
  }

  void _deleteRecipe(BuildContext context, int index, List<Recipe> recipes) {
    final recipe = recipes[index];
    context.read<ProfileBloc>().add(DeleteRecipeEvent(index));
    Navigator.pop(context, recipe);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfileEvent()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Profile",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: AppColors.lighthread,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoaded) {
                    final recipes = state.recipes;

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _pickImage(context);
                                },
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage: state.selectedImage != null
                                      ? FileImage(
                                          File(state.selectedImage!.path))
                                      : const AssetImage(
                                              'asstes/chef-restaurant-vector-kitchen-cook-hat-food-professional-icon-symbol-illustration-sign_1013341-148802.avif')
                                          as ImageProvider,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.lighthread,
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(
                                      5), 
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Name: ${user.username}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Email: ${user.email}',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Your Recipes:',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          recipes.isEmpty
                              ? const Text(
                                  'No recipes added yet.',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: recipes.length,
                                  itemBuilder: (context, index) {
                                    final recipe = recipes[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListTile(
                                        leading: Image.file(recipe.image,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover),
                                        title: Text(recipe.recipeName),
                                        subtitle: Text(recipe.description),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _deleteRecipe(
                                                context, index, recipes);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
