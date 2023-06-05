import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/feature/presentation/pages/flashcard_home_page.dart';

import '../../../app_const.dart';
import '../../domain/entities/user_entity.dart';
import '../cubit/auth/auth_cubit.dart';
import '../cubit/user/user_cubit.dart';
import 'home_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  GlobalKey<ScaffoldState> _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

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
              print('user failure');
              SnackBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("invalid email"),
                    Icon(FontAwesome.exclamation_triangle)
                  ],
                ),
              );
              //snackBarError(msg: "invalid email",scaffoldState: _scaffoldGlobalKey);
            }
          },
        ));
  }

  _bodyWidget() {
    return Column(
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
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'E-Mail',
                hintText: 'E-Mail',
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password',
                border: OutlineInputBorder()),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 45,
          width: MediaQuery.of(context).size.width / 2,
          child: ElevatedButton(
              child: Text('LOGIN',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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
              child: Text('SIGN UP',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, PageConst.signUpPage, (route) => false);
              }),
        ),
      ],
    );
  }

  void submitSignIn() {
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
