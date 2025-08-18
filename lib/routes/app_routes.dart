import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/journal_entries_list/journal_entries_list.dart';
import '../presentation/entry_detail_view/entry_detail_view.dart';
import '../presentation/edit_journal_entry/edit_journal_entry.dart';
import '../presentation/new_journal_entry/new_journal_entry.dart';
import '../presentation/main_menu/main_menu.dart';
import '../presentation/goals_dashboard/goals_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String journalEntriesList = '/journal-entries-list';
  static const String entryDetailView = '/entry-detail-view';
  static const String editJournalEntry = '/edit-journal-entry';
  static const String newJournalEntry = '/new-journal-entry';
  static const String mainMenu = '/main-menu';
  static const String goalsDashboard = '/goals-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    journalEntriesList: (context) => const JournalEntriesList(),
    entryDetailView: (context) => const EntryDetailView(),
    editJournalEntry: (context) => const EditJournalEntry(),
    newJournalEntry: (context) => const NewJournalEntry(),
    mainMenu: (context) => const MainMenu(),
    goalsDashboard: (context) => const GoalsDashboard(),
    // TODO: Add your other routes here
  };
}
