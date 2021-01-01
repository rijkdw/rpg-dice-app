import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rpg_dice/managers/collection_manager.dart';
import 'package:rpg_dice/managers/distribution_manager.dart';
import 'package:rpg_dice/managers/history_manager.dart';
import 'package:rpg_dice/managers/settings_manager.dart';
import 'package:rpg_dice/managers/theme_manager.dart';
import 'package:rpg_dice/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var distributionManager = DistributionManager();
    var collectionManager = CollectionManager();
    collectionManager.diceCollections.forEach((collection) {
      distributionManager.createDistribution(collection);
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HistoryManager()),
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => SettingsManager()),
        ChangeNotifierProvider.value(value: collectionManager),
        ChangeNotifierProvider.value(value: distributionManager),
      ],
      child: MaterialApp(
        title: "RPG Dice",
        theme: ThemeData(
          primarySwatch: Colors.red,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
