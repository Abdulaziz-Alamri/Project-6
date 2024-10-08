import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:project6/data_layer/recipe_data.dart';
import 'package:project6/services/setup.dart';
import 'package:project6/src/Home/home_screen.dart';
import 'package:project6/src/Login/custom_text_field.dart';
import 'package:project6/src/Singup/singup.dart';
import 'package:project6/theme/app_colors.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Container(
      width: 337,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.8),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10, 
            spreadRadius: 2,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Username',
            style: TextStyle(color: AppColors.lighthread, fontSize: 19),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter your username',
            controller: usernameController,
          ),
          const SizedBox(height: 16),
          const Text(
            'Password',
            style: TextStyle(color: AppColors.lighthread, fontSize: 19),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            hintText: 'Enter your password',
            obscureText: true,
            controller: passwordController,
          ),
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forget password?',
                style: TextStyle(color: AppColors.darkread),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lighthread,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 60,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                for (var user in locator.get<RecipeData>().users) {
                  if (user.username == usernameController.text &&
                      user.password == passwordController.text) {
                    locator.get<RecipeData>().saveLoginOrLogout(user);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  HomePage(user: user,)),
                    );
                    return;
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed Login!!!!')));
              },
              child: const Text(
                'Login',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUp()),
                );
              },
              child: const Text(
                "Sign up",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  shadows: [
                    Shadow(
                      color: Colors.black54, 
                      offset: Offset(0.1, 0.1),
                      blurRadius: 2, 
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
