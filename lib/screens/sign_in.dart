import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_bloc/cubits/auth_cubits/auth_cubit.dart';
import 'package:phone_auth_bloc/cubits/auth_cubits/auth_state.dart';
import 'package:phone_auth_bloc/screens/verify_phone_number.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign in',
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthCodeSentState) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const VerifyPhoneNumber();
                    }));
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder()),
                      onPressed: () {
                        if (_phoneController.text.isNotEmpty) {
                          String phoneNumber = '+92${_phoneController.text}';
                          FocusManager.instance.primaryFocus!.unfocus();
                          BlocProvider.of<AuthCubit>(context, listen: false)
                              .sendOtp(phoneNumber);
                        }
                      },
                      child: const Text(
                        'Submit',
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
