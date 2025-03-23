import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_coffee_shop/main.dart';
import 'package:flutter_application_coffee_shop/product.dart';
import 'package:provider/provider.dart';


class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final Image image;

  const CustomChoiceChip({
    Key? key,
    required this.label,
    required this.image,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          selected ? image : image,
          Container(margin: EdgeInsets.only(bottom: 10), child: Text(label),)
        ],
      ),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: false,
      backgroundColor: Colors.white, // Цвет фона не выбранного чипа
      disabledColor: Colors.transparent,
      selectedColor: Colors.brown, // Цвет фона выбранного чипа
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.brown, // Цвет текста
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Внутренние отступы
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(26)), // Скругленные углы
        side: BorderSide(color: Colors.transparent, width: 0), // Граница
      ),
    );
  }
}

class ItemEditScreen extends StatefulWidget {
  final Product _product;

  const ItemEditScreen({
    super.key,
    required Product product,
  }) : _product = product;

  @override
  State<ItemEditScreen> createState() => _ItemEditScreenState();
}


class _ItemEditScreenState extends State<ItemEditScreen> {
  bool addSyrup = false;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Material(
      child: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          // Фон
          const ColoredBox(color: Colors.white),
          // Основное содержимое с прокруткой
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Изображение и наложение
                SizedBox(
                  height: 360,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Изображение продукта
                        Image.asset(
                          widget._product.image,
                          fit: BoxFit.cover,
                        ),
                        // Кнопка "назад" и "избранное"
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: const Icon(Icons.favorite_border, color: Colors.white),
                            onPressed: () {
                              // Логика добавления в избранное
                            },
                          ),
                        ),
                        // Название продукта
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              height: 50, // Убрали width, так как Container растянется на всю ширину благодаря Positioned
                              decoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: Container(
                                color: Colors.white.withOpacity(0.2), // Полупрозрачный цвет для эффекта
                                child: Center(child: Text(widget._product.name)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Выбор размера
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Выберите размер',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: Colors.brown, width: 4),
                        ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomChoiceChip(
                                label: "Маленький",
                                image: Image.asset("assets/images/icons/big_coffee_unselected.png", height: 20),
                                selected:  appState.selectedSize == 0,
                                onSelected: (bool selected) {
                                  appState.selectItemSize(0);
                                },
                              ),
                              CustomChoiceChip(
                                label: "Средний",
                                image: Image.asset("assets/images/icons/big_coffee_unselected.png", height: 30,),
                                selected: appState.selectedSize == 1,
                                onSelected: (bool selected) {
                                  appState.selectItemSize(1);
                                },
                              ),
                              CustomChoiceChip(
                                label: 'Большой',
                                image: Image.asset("assets/images/icons/big_coffee_unselected.png", height: 40,),
                                selected: appState.selectedSize == 2,
                                onSelected: (bool selected) {
                                  appState.selectItemSize(2);
                                },
                              ),
                            ],
                          ),
                        )    
                      ],
                    ),
                  ),
                // Дополнительно
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Выберите сироп',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        icon:  Icon(Icons.add),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Container();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                
                // Добавляем дополнительное пространство внизу, чтобы контент не обрезался
                const SizedBox(height: 50),
              ],
            ),
          ),

          //Цена и кол-во
          Positioned(
            bottom: 40, left: 40, right: 40,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.brown,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(padding: EdgeInsets.only(left: 20), child: Text(
                    '${widget._product.price} ₽',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    margin: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(onPressed: () => {
                            if (appState.itemAmount > 1) appState.decreaseItemAmount(1)
                          },
                          icon: Icon(Icons.remove),
                          color: Colors.brown
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 2), child: Text(appState.itemAmount.toString(), style: TextStyle(color: Colors.brown),)),
                        IconButton(onPressed: () => appState.increaseItemAmount(1), icon: Icon(Icons.add), color: Colors.brown)
                      ],
                    )
                  ),
                ],
              )
            )
          )

        ],
      ),
    );
  }
}