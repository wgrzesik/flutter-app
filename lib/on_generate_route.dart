import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/feature/domain/entities/flashcard_entity.dart';
import 'package:note_app/feature/presentation/pages/home_page.dart';
import 'feature/domain/entities/multiple_page_arguments.dart';
import 'feature/presentation/pages/buttons_for_stats_page.dart';
import 'feature/presentation/pages/correct_answers_stats.dart';
import 'feature/presentation/pages/end_of_flashcards_page.dart';
import 'feature/presentation/pages/flashcards_page.dart';
import 'feature/presentation/pages/new_statistics_page.dart';
import 'feature/presentation/pages/no_answers_page.dart';
import 'feature/presentation/pages/sign_in_page.dart';
import 'feature/presentation/pages/sign_up_page.dart';
import 'feature/presentation/pages/statistics_page.dart';
import 'feature/presentation/pages/srs_page.dart';
import 'feature/presentation/pages/wrong_answers_stats.dart';
import 'feature/presentation/widgets/error_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case PageConst.signInPage:
        {
          return materialBuilder(widget: SignInPage());
        }
      case PageConst.signUpPage:
        {
          return materialBuilder(widget: SignUpPage());
        }
      case PageConst.flashcardsPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: FlashcardsPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.statisticsPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: ButtonStatsPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.flahscardHomePage:
        {
          if (args is String) {
            return materialBuilder(
                widget: FlashcardHomePage(
              uid: args,
            ));
          } else {
            return materialBuilder(
              widget: const ErrorPage(),
            );
          }
        }
      case PageConst.srsPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: SrsPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.endOfFlashcardsPage:
        {
          final arguments = settings.arguments as MultiplePageArgumentsSetName;
          return materialBuilder(
            widget: EndOfFlashcardsPage(
              setName: arguments.setName,
              uid: arguments.uid,
              badAnswers: arguments.badAnswears,
              goodAnswers: arguments.goodAnswears,
            ),
          );
        }
      case PageConst.buttonStatsPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: ButtonStatsPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.correctAnswersPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: CorrectAnswersPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.wrongAnswersPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: WrongAnswersPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      case PageConst.noAnswersPage:
        {
          final arguments = settings.arguments as MultiplePageArguments;
          return materialBuilder(
            widget: NoAnswersPage(
              setEntity: arguments.setEntity,
              uid: arguments.uid,
            ),
          );
        }
      default:
        return materialBuilder(widget: const ErrorPage());
    }
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
