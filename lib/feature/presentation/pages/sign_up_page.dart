import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/domain/entities/set_entity.dart';

import '../../../app_const.dart';
import '../../domain/entities/stats_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/flashcard/flashcard_cubit.dart';
import '../cubit/set/set_cubit.dart';
import '../cubit/stats/stats_cubit.dart';
import '../cubit/user/user_cubit.dart';
import 'flashcard_home_page.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _globalKey = GlobalKey<ScaffoldState>();
  final _formField = GlobalKey<FormState>();
  bool shouldInitializeStats = false;
  bool showPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        body: BlocConsumer<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authenticated) {
                  if (shouldInitializeStats) {
                    BlocProvider.of<StatsCubit>(context)
                        .addStats(stats: authState.uid);
                    shouldInitializeStats = false;
                  }
                  return FlashcardHomePage(uid: authState.uid);
                } else {
                  return _bodyWidget();
                }
              });
            }
            return _bodyWidget();
          },
          listener: (context, userState) {
            if (userState is UserSuccess) {
              BlocProvider.of<AuthCubit>(context).loggedIn();
            }
            // if (userState is UserFailure) {
            //   print('User Failure');
            // }
          },
        ));
  }

  _bodyWidget() {
    return Form(
      key: _formField,
      child: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 10,
            // ),
            const Text('Create account',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 10,
            ),
            const FaIcon(FontAwesomeIcons.hatWizard, size: 60),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _usernameController,
              decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_2_rounded)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Username';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: 'E-Mail',
                  hintText: 'E-Mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.mail)),
              validator: (value) {
                final bool validEmail = RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value!);
                if (value.isEmpty) {
                  return 'Enter Email';
                } else if (!validEmail) {
                  return 'Enter Valid Email';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _passwordController,
              obscureText: showPassword,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                        showPassword ? Icons.visibility_off : Icons.visibility),
                  )),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter Password';
                } else if (_passwordController.text.length < 6) {
                  return 'Password is too short! Has to be more than 6 characters';
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                  child: const Text('SIGN UP',
                      style: TextStyle(
                        fontSize: 18,
                      )),
                  onPressed: () {
                    submitSignIn();
                  }),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, PageConst.signInPage, (route) => false);
                },
                child: const Text.rich(TextSpan(children: [
                  TextSpan(
                      text: 'Already have an Account? ',
                      style: TextStyle(color: Colors.black)),
                  TextSpan(
                      text: 'LOGIN', style: TextStyle(color: Colors.purple))
                ])))
          ],
        ),
      ),
    );
  }

  void submitSignIn() {
    if (_formField.currentState!.validate()) {
      shouldInitializeStats = true;
      if (_usernameController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        BlocProvider.of<UserCubit>(context).submitSignUp(
            user: UserEntity(
          name: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ));
      }
    }
  }
}
