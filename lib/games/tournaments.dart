import 'package:app_tournament/games/completed.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/shimmer/shimmer.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/games/new_open_game.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NewGamesItem extends StatelessWidget {
  final NewGames newGames;
  const NewGamesItem({Key? key, required this.newGames}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) =>
                TournamentsScreen(newGames: newGames),
          ),
        );
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 2,
        margin: const EdgeInsets.all(4),
        color: darkModeProvider.isDarkTheme ? DesignColor.blackFront : null,
        child: Stack(
          children: [
            CachedNetworkImage(
              height: 200,
              width: double.infinity,
              imageUrl: newGames.img,
              fit: BoxFit.cover,
              placeholder: (context, index) {
                return const ShimmerCard();
              },
              errorWidget: (context, index, err) {
                return const ShimmerCard();
              },
            ),
            DesignButtons.customRadius(
                topLeft: 0,
                bottomLeft: 0,
                onPressed: () {},
                textLabel: newGames.title,
                colorText: Colors.white,
                // color: Colors.pinkAccent,
                icon: const Icon(Ionicons.logo_google_playstore,
                    color: Colors.white)),
            Positioned(
              bottom: 10,
              right: 0,
              child: DesignButtons.customRadius(
                  bottomRight: 0,
                  topRight: 0,
                  onPressed: () {},
                  textLabel: '${newGames.id} ',
                  colorText: Colors.white,
                  // color: DesignColor.blueSmart.withOpacity(0.8),
                  icon: const Icon(Ionicons.play_circle, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentsScreen extends StatelessWidget {
  final NewGames newGames;
  const TournamentsScreen({Key? key, required this.newGames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.blueAccent,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DesignText(
            newGames.title,
            color: darkModeProvider.isDarkTheme ? Colors.white : null,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            // backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  automaticIndicatorColorAdjustment: true, 
                  tabs: [
                    Tab(
                        child: DesignText.bold1("New",
                            color: darkModeProvider.isDarkTheme
                                ? Colors.white
                                : null,
                            fontWeight: 800)),
                    // Tab(
                    //     child: DesignText.b1("Ongoing",
                    //         color: Colors.white, fontWeight: 800)),
                    Tab(
                        child: DesignText.bold1("Results",
                            color: darkModeProvider.isDarkTheme
                                ? Colors.white
                                : null,
                            fontWeight: 800)),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NewGamesList(newGames: newGames),
              // ListView(children: [NewOngoing(newGames: newGames)]),
              NewCompleted(newGames: newGames)
            ],
          ),
        ),
      ),
    );
  }
}
