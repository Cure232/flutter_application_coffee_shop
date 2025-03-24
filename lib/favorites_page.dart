import 'package:flutter/material.dart';
import 'package:flutter_application_coffee_shop/menu_item_edit.dart';
import 'package:flutter_application_coffee_shop/product.dart';
import 'package:provider/provider.dart';
import 'main.dart';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<StatefulWidget> createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {

  List<Product> favoriteProducts = [];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SliverToBoxAdapter(child:
      Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Сетка продуктов
            CustomScrollView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              slivers: [
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  mainAxisExtent: 300
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                           MaterialPageRoute(builder: (context) {
                            return ItemEditScreen(product: appState.favoriteProducts[index]);
                            }));
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 4,),
                              Image.asset(appState.favoriteProducts[index].image),
                              Container(
                                padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                                child: Text(
                                  appState.favoriteProducts[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, leadingDistribution: TextLeadingDistribution.even),
                                )
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                    (appState.favoriteProducts[index].prices["300 мл"] + appState.favoriteProducts[index].currency),
                                    style: TextStyle(color: Colors.brown),
                                    ),
                                    IconButton(icon: Icon(Icons.favorite), color: Colors.brown, onPressed: () => appState.changeFavoriteStatus(appState.favoriteProducts[index]),)
                                  ]
                                )
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: appState.favoriteProducts.length,
                  ),
                ),
                SliverToBoxAdapter(child: Visibility(visible: appState.favoriteProducts.length < 1, 
                  child: Text("Нет избранных товаров :(", style: 
                    TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center
                  )
                ))
              ],
            )
          ]
        )
      )
    );
  }
}