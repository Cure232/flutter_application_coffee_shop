import 'package:flutter/material.dart';
import 'package:flutter_application_coffee_shop/menu_item_edit.dart';
import 'package:flutter_application_coffee_shop/product.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<StatefulWidget> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            // Сетка продуктов
            CustomScrollView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                // Заменяем ListView.builder на SliverList
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Card(
                        color: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(padding: EdgeInsets.all(10), child: Image.asset(appState.cartItems[index].product.image)),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appState.cartItems[index].product.name,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                    Text(
                                      "Кол-во: ${appState.cartItems[index].quantity}",
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                    Text(
                                      appState.cartItems[index].size,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        leadingDistribution: TextLeadingDistribution.even,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.bottomRight,
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(
                                        appState.cartItems[index].product.prices[appState.cartItems[index].size]! + appState.cartItems[index].product.currency,
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          leadingDistribution: TextLeadingDistribution.even,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: appState.cartItems.length, // Указываем количество элементов
                  ),
                ),
                SliverToBoxAdapter(
                  child: Visibility(
                    visible: appState.cartItems.isEmpty,
                    replacement: Container(
                      padding: EdgeInsets.all(20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Итого:     ${appState.cartSum}р",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    child: const Text(
                      "Корзина пуста",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}