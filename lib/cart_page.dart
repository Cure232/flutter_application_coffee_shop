import 'package:flutter/material.dart';
import 'package:flutter_application_coffee_shop/menu_item_edit.dart';
import 'package:flutter_application_coffee_shop/product.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Фиксированная высота
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Consumer<AppState>(
        builder: (context, appState, child) {
          return Stack(
            children: [
              // Основное содержимое (заголовок и список продуктов)
              Column(
                children: [
                  // Индикатор свайпа
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Заголовок
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Корзина',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Список продуктов
                  Expanded(
                    child: appState.cartItems.isEmpty
                        ? const Center(
                            child: Text(
                              "Корзина пуста",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            physics: const ClampingScrollPhysics(),
                            itemCount: appState.cartItems.length,
                            itemBuilder: (context, index) {
                              return Card(
                                color: Colors.white,
                                shadowColor: Colors.black,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Image.asset(
                                            appState.cartItems[index].product.image,
                                            width: 80,
                                            height: 80,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
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
                                                  margin: const EdgeInsets.only(right: 10),
                                                  child: Text(
                                                    "${appState.cartItems[index].product.prices[appState.cartItems[index].size]!}${appState.cartItems[index].product.currency}",
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
                                    //Удаление из корзины
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.black),
                                        onPressed: () {
                                          appState.removeFromCart(appState.cartItems[index]);
                                        },
                                      ),
                                    ),
                                  ]
                                ),
                              );
                            },
                          ),
                  ),
                  // Пустое пространство, чтобы итоговая сумма и кнопка не перекрывали содержимое
                  if (!appState.cartItems.isEmpty) const SizedBox(height: 120),
                ],
              ),
              // Кнопка-крест в верхнем правом углу
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // Итоговая сумма и кнопка "Оплатить" внизу
              if (!appState.cartItems.isEmpty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Итого: ${appState.cartSum}р",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            appState.clearCart();
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Оплатить'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  // Статический метод для отображения CartPage как BottomSheet
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) => const CartPage(),
    );
  }
}