import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project6/blocs/home_bloc/home_bloc.dart';
import 'package:project6/src/Details/RecipeDetailsPage.dart.dart';
import 'package:project6/theme/app_colors.dart';

class RecipeCard extends StatelessWidget {
  final String recipeTitle;
  final File imageFile;
  final String description;
  final HomeBloc homeBloc;  

  const RecipeCard({
    super.key,
    required this.recipeTitle,
    required this.imageFile,
    required this.description,
    required this.homeBloc, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailsPage(
              recipeTitle: recipeTitle, 
              imageFile: imageFile,      
              description: description,
              homeBloc: homeBloc,     
            ),
          ),
        );
      },
      child: Card(
        color: AppColors.primary.withOpacity(0.8),
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.file(
                imageFile,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meal',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.lighthread),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recipeTitle,  
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: AppColors.grey),
                        
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Recipe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lighthread,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,  // Use the passed description here
                    style: const TextStyle(fontSize: 16, color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
