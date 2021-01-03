import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/distribution_manager.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/settings_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/screens/home_screen.dart';

import 'package:rpg_dice/constants.dart' as constants;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var distributionManager = DistributionManager();
    var collectionManager = CollectionManager();
    var themeManager = ThemeManager();
    // collectionManager.diceCollections.forEach((collection) {
    //   distributionManager.createDistribution(collection);
    // });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryManager()),
        ChangeNotifierProvider(create: (_) => SettingsManager()),
        ChangeNotifierProvider.value(value: themeManager),
        ChangeNotifierProvider.value(value: collectionManager),
        ChangeNotifierProvider.value(value: distributionManager),
      ],
      child: MaterialApp(
        title: 'RPG Dice',
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          cardTheme: CardTheme(
            elevation: constants.CARD_ELEVATION,
          ),
          cardColor: themeManager.theme.genericCardColor,
          appBarTheme: AppBarTheme(
            elevation: constants.APPBAR_ELEVATION,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            elevation: constants.FAB_ELEVATION,
            focusElevation: constants.FAB_ELEVATION,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}
