import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_bloc/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth_bloc/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth_bloc/screens/sign_in.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoggedOutState) {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return const SignIn();
                  }));
                }
              },
              builder: (context, state) {
                return TextButton(
                    onPressed: () {
                      BlocProvider.of<AuthCubit>(context, listen: false)
                          .signOut();
                    },
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ));
              },
            )
          ],
        ),
      ),
    );
  }
}
