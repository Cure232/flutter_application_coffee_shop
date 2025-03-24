import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'home_page.dart';
import 'navigation_buttons.dart';

String productsJsonPath = "assets/products.json";
List<Product> products = [];

class AppState with ChangeNotifier {
  List<String> _categories = ["Новинки", "Популярное"];
  int _selectedCategoryIndex = 0;
  bool _noItemsInCategory = true;
  List<Product> _selectedCategoryProducts = [];
  int _selectedPage = 0;
  int _selectedSize = 0;
  int _itemAmount = 1;
  List<CartItem> _cartItems = [];

  List<String> get categories => _categories;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  bool get noItemsInCategory => _noItemsInCategory;
  List<Product> get selectedCategoryProducts => _selectedCategoryProducts;
  int get selectedPage => _selectedPage;
  int get itemAmount => _itemAmount;
  int get selectedSize => _selectedSize;
  List<CartItem> get cartItems => _cartItems;

  AppState() {
    for (Product p in products) {
      _categories.addAll(p.categories.where((category) => !_categories.contains(category)));
    }
    _selectedCategoryProducts.addAll(products.where((product) => product.categories.contains(_categories[_selectedCategoryIndex])));
  }

  void selectCategory(int index) {
    _selectedCategoryIndex = index;
    _selectedCategoryProducts.clear();
    _selectedCategoryProducts.addAll(products.where((product) => product.categories.contains(_categories[_selectedCategoryIndex])));
    _noItemsInCategory = _selectedCategoryProducts.isEmpty;
    notifyListeners();
  }

  void selectPage(int index) {
    _selectedPage = index;
    notifyListeners();
  }

  void increaseItemAmount(int toAdd) {
    _itemAmount += toAdd;
    notifyListeners();
  }

  void decreaseItemAmount(int toRetract) {
    _itemAmount -= toRetract;
    notifyListeners();
  }

  void resetItemAmount ()
  {
    _itemAmount = 1;
    notifyListeners();
  }

  void selectItemSize (int size)
  {
    _selectedSize = size;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    rootBundle.loadString(productsJsonPath).then((result) {
      products = parseProducts(result);
      runApp(
        ChangeNotifierProvider(
          create: (_) => AppState(),
          child: const CoffeeApp(),
        ),
      );
    });
  } catch (ex) {
    rethrow;
  }
}

class CoffeeApp extends StatelessWidget {
  const CoffeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.brown,
      ),
      home: const CoffeeMenuScreen(),
    );
  }
}

class CoffeeMenuScreen extends StatelessWidget {
  const CoffeeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final List<Widget> pages = [
      const HomePage(),
      const FavoritesPage(),
      const CartPage(),
    ];

    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image(
            image: const AssetImage("assets/images/home_bg.jpg"),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          IndexedStack(
            index: appState.selectedPage,
            children: pages.map((page) {
              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    pinned: false,
                    stretch: true,
                    collapsedHeight: 60,
                    expandedHeight: 300,
                    leading: IconButton(
                      padding: const EdgeInsets.all(5),
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(const CircleBorder()),
                      ),
                      icon: const Icon(
                        Icons.location_on_outlined,
                        color: Colors.brown,
                      ),
                      onPressed: () {
                        print('Location pressed');
                      },
                    ),
                    actions: [
                      IconButton(
                        padding: const EdgeInsets.all(5),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.white),
                          shape: WidgetStateProperty.all(const CircleBorder()),
                        ),
                        icon: const Icon(
                          Icons.person_outline_outlined,
                          color: Colors.brown,
                        ),
                        onPressed: () {
                          print('Profile pressed');
                        },
                      ),
                    ],
                    title: const Text(
                      'Революционная 101А',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        shadows: [Shadow(color: Colors.black, offset: Offset(2, 2))],
                        fontSize: 24,
                      ),
                    ),
                  ),
                  if (page is HomePage) page else SliverToBoxAdapter(child: page),
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: ColoredBox(color: Colors.white),
                  ),
                ],
              );
            }).toList(),
          ),
          Positioned(
            left: 80,
            right: 80,
            bottom: 20,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.brown.withOpacity(0.9),
                  borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MenuNavigationButton(
                      icon: Icons.home,
                      isSelected: appState.selectedPage == 0,
                      onTap: () {
                        appState.selectPage(0);
                      },
                    ),
                    const SizedBox(width: 20),
                    MenuNavigationButton(
                      icon: Icons.favorite,
                      isSelected: appState.selectedPage == 1,
                      onTap: () {
                        appState.selectPage(1);
                      },
                    ),
                    const SizedBox(width: 20),
                    MenuNavigationButton(
                      icon: Icons.shopping_cart,
                      isSelected: appState.selectedPage == 2,
                      onTap: () {
                        appState.selectPage(2);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Страница избранного (в разработке)"),
    );
  }
}

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Страница корзины (в разработке)"),
    );
  }
}