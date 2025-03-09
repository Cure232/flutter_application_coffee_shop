import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

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
        //textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.brown,
      ),
      home: CoffeeHomePage(),
    );
  }
}

class CoffeeHomePage extends StatefulWidget {
  @override
  _CoffeeHomePageState createState() => _CoffeeHomePageState();
}

class _CoffeeHomePageState extends State<CoffeeHomePage> {
  final List<String> categories = ["Новинки", "Кофе с молоком", "Чёрный кофе"];
  int selectedCategoryIndex = 0;

  final List<Map<String, String>> products = [
    {"name": "Латте яблочный пирог", "price": "290 р", "image": "assets/apple_latte.png"},
    {"name": "Тыквенный латте", "price": "290 р", "image": "assets/pumpkin_latte.png"},
    {"name": "Латте солёная карамель", "price": "290 р", "image": "assets/salt_latte.png"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Кофейня", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Text(categories[index]),
                      selected: selectedCategoryIndex == index,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      selectedColor: Colors.brown,
                      labelStyle: TextStyle(
                          color: selectedCategoryIndex == index ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
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
                        SizedBox(height: 10),
                        Text(products[index]["name"]!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Text(products[index]["price"]!, style: TextStyle(color: Colors.brown)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Главная"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Избранное"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Корзина"),
        ],
      ),
    );
  }
}
