import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'product.dart';

String productsJsonPath = "assets/products.json";
List<Product> products = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try
  {
    rootBundle.loadString(productsJsonPath).then((result) {
    products = parseProducts(result);
    runApp(CoffeeApp());
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
      home: CoffeeMenuScreen(),
    );
  }
}


class CoffeeMenuScreen extends StatefulWidget {
  const CoffeeMenuScreen({super.key});

  @override
  CoffeeMenuScreenState createState() => CoffeeMenuScreenState();
}

class CoffeeMenuScreenState extends State<CoffeeMenuScreen> {
  final List<Widget> _pages = [
    HomePage(),
    FavoritesPages(),
    CartPage(),
  ];
  int _selectedPage = 0;  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Кофейня", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: _pages[_selectedPage],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Избранное"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Корзина"),
        ],
        onTap: (value) {
          setState(() {
            _selectedPage = value;
          });
        }, //onTap
      ), //bottomNavigationBar
    ); //Scaffold
  } //build

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> categories = ["Новинки", "Популярное"];
  int selectedCategoryIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _keys = {}; // Храним ключи для каждого элемента

  @override
  void initState() {
    for (Product p in products)
    {
      categories.addAll(p.categories.where((category) => !categories.contains(category)));
    }
    super.initState();
  }

  bool _isFullyVisible(int index) {
    if (!_keys.containsKey(index) || _keys[index]!.currentContext == null) return false;

    RenderBox renderBox = _keys[index]!.currentContext!.findRenderObject() as RenderBox;
    double itemLeft = renderBox.localToGlobal(Offset.zero).dx;
    double itemRight = itemLeft + renderBox.size.width;

    RenderBox listBox = _scrollController.position.context.storageContext.findRenderObject() as RenderBox;
    double listLeft = listBox.localToGlobal(Offset.zero).dx;
    double listRight = listLeft + listBox.size.width;

    return itemLeft >= listLeft && itemRight <= listRight;
  }

  void _scrollToSelected(int index) {
    if (_isFullyVisible(index)) return; // Если уже видно, не скроллим

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 120.0; // Примерная ширина одного ChoiceChip
    double scrollOffset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutSine,
    );
  }

  @override
  Widget build(BuildContext context)
  {
    List<Product> selectedCategoryProducts = [];
    selectedCategoryProducts.addAll(products.where((product) => product.categories.contains(categories[selectedCategoryIndex])));
    
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              //width: categories.length * 120,
              height: 50,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: IntrinsicWidth(
                      stepWidth: 30.0,
                      child: ChoiceChip(
                        key: _keys[index],
                        label: Text(categories[index]),
                        selected: selectedCategoryIndex == index,
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategoryIndex = index;
                            selectedCategoryProducts.clear();
                            selectedCategoryProducts.addAll(products.where((product) => product.categories.contains(categories[selectedCategoryIndex])));
                            _scrollToSelected(index);
                          });
                        },
                        selectedColor: Colors.brown,
                        labelStyle: TextStyle(color: selectedCategoryIndex == index ? Colors.white : Colors.black),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        ) //Choise Chip
                      ), // IntrinsicWidth
                  ); //Padding
                }, //ItemBuilder
              ),
            ), //Topbar SizedBox
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: selectedCategoryProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(selectedCategoryProducts[index].image, height: 100),
                        SizedBox(height: 2),
                        Text(selectedCategoryProducts[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 2),
                        Text((selectedCategoryProducts[index].price.toString() + selectedCategoryProducts[index].currency), style: TextStyle(color: Colors.brown)),
                      ],
                    ), //Image and text
                  ); //Item card
                }, // itemBuilder
              ), //GridView Builder
            ), //Expanded
          ], //Column children
        ), //Column
      ); // Padding
  }
}

class FavoritesPages extends StatefulWidget{
  const FavoritesPages({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class CartPage extends StatefulWidget{
  const CartPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
