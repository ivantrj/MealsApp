import 'package:flutter/material.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/providers/filters_provider.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const kInitialFilter = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = "Categories";

    if (selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);

      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = "Favourites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          selectPage(index);
        },
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.set_meal), label: "Categories"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favourites"),
        ],
      ),
    );
  }
}
