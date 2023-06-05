import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:note_app/app_const.dart';
import 'package:flutter/cupertino.dart';
import 'package:note_app/feature/domain/entities/flashcard_entity.dart';
import 'package:note_app/feature/presentation/pages/flashcard_home_page.dart';
import 'feature/domain/entities/multiple_page_arguments.dart';
import 'feature/domain/entities/note_entity.dart';
import 'feature/domain/entities/set_entity.dart';
import 'feature/presentation/pages/add_new_note_page.dart';
import 'feature/presentation/pages/flashcards_page.dart';
import 'feature/presentation/pages/sign_in_page.dart';
import 'feature/presentation/pages/sign_up_page.dart';
import 'feature/presentation/pages/srs_page.dart';
import 'feature/presentation/pages/statistics_page.dart';
import 'feature/presentation/pages/update_note_page.dart';
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
      // case PageConst.addNotePage:
      //   {
      //     if (args is String) {
      //       return materialBuilder(
      //           widget: AddNewNotePage(
      //         uid: args,
      //       ));
      //     } else {
      //       return materialBuilder(
      //         widget: ErrorPage(),
      //       );
      //     }
      //     break;
      //   }
      // case PageConst.updateNotePage:
      //   {
      //     if (args is NoteEntity) {
      //       return materialBuilder(
      //           widget: UpdateNotePage(
      //         noteEntity: args,
      //       ));
      //     } else {
      //       return materialBuilder(
      //         widget: ErrorPage(),
      //       );
      //     }
      //     break;
      //   }
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
            widget: StatisticsPage(
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
      default:
        return materialBuilder(widget: const ErrorPage());
    }
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
