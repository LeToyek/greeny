import 'package:go_router/go_router.dart';
import 'package:greenify/model/garden_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/states/plant_avatar_state.dart';
import 'package:greenify/ui/screen/garden/create_garden_screen.dart';
import 'package:greenify/ui/screen/garden/edit_garden_screen.dart';
import 'package:greenify/ui/screen/garden/garden_form_screen.dart';
import 'package:greenify/ui/screen/garden/garden_pot_detail_screen.dart';
import 'package:greenify/ui/screen/garden/garden_space_screen.dart';
import 'package:greenify/ui/screen/garden/list_garden_space_screen.dart';
import 'package:greenify/ui/screen/garden/plant/plant_edit_screen.dart';

List<GoRoute> gardenRoutes = [
  GoRoute(
      path: "/garden",
      builder: (context, state) => const ListGardenSpaceScreen()),
  GoRoute(
      name: "garden_create",
      path: "/garden/create",
      builder: (context, state) => const CreateGardenScree()),
  GoRoute(
      path: "/garden/edit/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        final garden = state.extra as GardenModel?;
        return EditGardenScreen(
          garden: garden!,
        );
      }),
  GoRoute(
      path: "/garden/form/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return GardenFormScreen(id: id);
      }),
  GoRoute(
      path: "/garden/:id/plant/edit",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        final extras = state.extra as Map<String, dynamic>?;
        return PlantEditScreen(
          id: id,
          potModel: extras!["pot"] as PotModel,
          pageNotifier: extras["pageNotifier"] as PlantAvatarNotifier,
        );
      }),
  GoRoute(
      path: "/garden/:gardenID/detail/:potID",
      builder: (context, state) {
        final gardenID = state.pathParameters["gardenID"]!;
        final potID = state.pathParameters["potID"]!;

        final extra = state.extra as Map<String, dynamic>?;
        final pot = extra?["pot"] as PotModel?;
        final photoHero = extra?["photoHero"] as String?;
        final iconHero = extra?["iconHero"] as String?;

        return GardenPotDetailScreen(
          gardenID: gardenID,
          potID: potID,
          pot: pot,
          photoHero: photoHero,
          iconHero: iconHero,
        );
      }),
  GoRoute(
      name: "garden_detail",
      path: "/garden/:id",
      builder: (context, state) {
        final id = state.pathParameters["id"]!;
        return GardenSpaceScreen(id: id);
      }),
];
