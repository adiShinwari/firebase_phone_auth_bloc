// ignore_for_file: unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_auth_bloc/cubits/auth_cubits/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  AuthCubit() : super(AuthInitialState()) {
    User? user = _auth.currentUser;
    if (user != null) {
      emit(AuthLoggedInState(user));
    } else {
      emit(AuthLoggedOutState());
    }
  }

  void sendOtp(String phoneNumber) async {
    emit(AuthLoadingState());
    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      codeSent: (verificationId, forceResendingToken) {
        emit(AuthCodeSentState());
        _verificationId = verificationId;
      },
      verificationCompleted: (phoneAuthCredential) {
        signInWithPhone(phoneAuthCredential);
      },
      verificationFailed: (error) {
        emit(
          AuthErrorState(
            error: error.message.toString(),
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void verifyOtp(String otp) async {
    emit(AuthLoadingState());
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: otp,
    );
    signInWithPhone(credential);
  }

  void signInWithPhone(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        emit(AuthLoggedInState(userCredential.user!));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(
        error: e.message.toString(),
      ));
    }
  }

  void signOut() {
    _auth.signOut();
    emit(AuthLoggedOutState());
  }
}
