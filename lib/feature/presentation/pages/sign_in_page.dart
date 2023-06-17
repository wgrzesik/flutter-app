import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/pages/home_page.dart';
import '../../../app_const.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/user/user_cubit.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final _formField = GlobalKey<FormState>();

  bool showPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldGlobalKey,
        body: BlocConsumer<UserCubit, UserState>(
          builder: (context, userState) {
            if (userState is UserSuccess) {
              return BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, authState) {
                if (authState is Authenticated) {
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
            if (userState is UserFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color.fromARGB(255, 155, 13, 13),
                  duration: const Duration(seconds: 3),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.triangleExclamation,
                          color: Colors.white),
                      SizedBox(width: 20),
                      Text("Invalid email or password",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  _bodyWidget() {
    return Form(
      key: _formField,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            const FaIcon(FontAwesomeIcons.hatWizard, size: 100),
            const SizedBox(
              height: 10,
            ),
            Text('FlashcardWizard',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(.8))),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
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
                return null;
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
                return null;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                  child: const Text('LOGIN',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    submitSignIn();
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(.5)),
                  child: const Text('SIGN UP',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, PageConst.signUpPage, (route) => false);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void submitSignIn() {
    if (_formField.currentState!.validate()) {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        BlocProvider.of<UserCubit>(context).submitSignIn(
            user: UserEntity(
          email: _emailController.text,
          password: _passwordController.text,
        ));
      }
    }
  }
}
