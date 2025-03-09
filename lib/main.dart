import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CoffeeApp());
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
  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Map<String, String>> products = [
    {"name": "Латте яблочный пирог", "price": "290 р", "image": "assets/apple_latte.png"},
    {"name": "Тыквенный латте", "price": "290 р", "image": "assets/pumpkin_latte.png"},
    {"name": "Латте солёная карамель", "price": "290 р", "image": "assets/salt_latte.png"},
  ];

  final List<String> categories = ["Новинки", "Кофе с молоком", "Чёрный кофе"];
  int selectedCategoryIndex = 0;

  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _keys = {}; // Храним ключи для каждого элемента

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < categories.length; i++) {
      _keys[i] = GlobalKey(); // Создаём уникальные ключи для каждого ChoiceChip
    }
  }

  bool _isFullyVisible(int index) {
    if (!_keys.containsKey(index) || _keys[index]!.currentContext == null) return false;

    RenderBox renderBox = _keys[index]!.currentContext!.findRenderObject() as RenderBox;
    double itemLeft = renderBox.localToGlobal(Offset.zero).dx;
    double itemRight = itemLeft + renderBox.size.width;

    RenderBox listBox = _scrollController.position.context.storageContext!.findRenderObject() as RenderBox;
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
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 0.0),
                    child: IntrinsicWidth(
                      stepWidth: 0.0,
                      child: ChoiceChip(
                        key: _keys[index],
                        label: Text(categories[index]),
                        selected: selectedCategoryIndex == index,
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() {
                            selectedCategoryIndex = index;
                            _scrollToSelected(index);
                          });
                        },
                        selectedColor: Colors.brown,
                        labelStyle: TextStyle(
                            color: selectedCategoryIndex == index ? Colors.white : Colors.black),
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
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(products[index]["image"]!, height: 100),
                        SizedBox(height: 2),
                        Text(products[index]["name"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 2),
                        Text(products[index]["price"]!, style: TextStyle(color: Colors.brown)),
                      ],
                      
                    ), //Image and text
                  ); //Item card
                },
              ), //GridView Builder
            ), //Expanded
          ], //Column children
        ), //Column
      ); // Padding
  }
}

class FavoritesPages extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class CartPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}
