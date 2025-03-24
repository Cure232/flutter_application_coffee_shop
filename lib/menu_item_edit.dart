import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_coffee_shop/main.dart';
import 'package:flutter_application_coffee_shop/product.dart';
import 'package:provider/provider.dart';

final String imageSelected = "assets/images/icons/medium_coffee_selected.png";
final String imageUnselected = "assets/images/icons/big_coffee_unselected.png";

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final double imageHeight;

  CustomChoiceChip({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
    required this.imageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children:  [
          selected ? Image(image: AssetImage(imageSelected), height: imageHeight,) : Image(image: AssetImage(imageUnselected), height: imageHeight,),
          SizedBox(height: 6,),
          Container(margin: EdgeInsets.only(bottom: 12), child: Text(label),)
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Внутренние отступы
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
  int itemAmount = 1;
  String selectedSize = "300 мл";

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
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.brown),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: IconButton(
                              icon: widget._product.isFavorite ? const Icon(Icons.favorite, color: Colors.brown) : const Icon(Icons.favorite_border_outlined, color: Colors.brown),
                              onPressed: () {
                                appState.changeFavoriteStatus(widget._product);
                              },
                            ),
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
                                color: Colors.white.withOpacity(0.3), // Полупрозрачный цвет для эффекта
                                child: Center(child: Text(widget._product.name, style: TextStyle(fontSize: 24, color: Colors.black),)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Выбор размера
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Center(
                          child: const Text(
                            'Выберите размер',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Center(
                          child: Container(
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
                                    label: "200 мл",
                                    imageHeight: 20,
                                    selected:  selectedSize == "200 мл",
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedSize = "200 мл";
                                      });
                                    },
                                  ),
                                  CustomChoiceChip(
                                    label: "300 мл",
                                    imageHeight: 30,
                                    selected: selectedSize == "300 мл",
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedSize = "300 мл";
                                      });
                                    },
                                  ),
                                  CustomChoiceChip(
                                    label: "400 мл",
                                    imageHeight: 40,
                                    selected: selectedSize == "400 мл",
                                    onSelected: (bool selected) {
                                      setState(() {
                                        selectedSize = "400 мл";
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          )    
                        ],
                      ),
                    ),
                ),
                // Дополнительно
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const Text(
                          'Выберите сироп',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      //Ряд выбора сиропа
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  spacing: 30,
                                  children: [
                                    Transform.scale(scale: 3, child: Icon(Icons.apple)),
                                    Center(child: Container(width: 100, child: Text("Яблочный сироп", softWrap: true, overflow: TextOverflow.visible,)))
                                  ],
                                ),
                              ),
                              //Карточка добавить сироп
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: Offset(0, 2))],
                                  borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.brown),
                                      child: IconButton(
                                        icon:  Icon(Icons.add, color: Colors.white,),
                                        onPressed: () {
                                          showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.white,
                                            shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            builder: bottomSheetBuilder,
                                          );
                                        },
                                      ),
                                    ),
                                    Text("Добавить сироп")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(padding: EdgeInsets.all(12), child: Text("Описание отсутствует. ${widget._product.description}"),)
                    ],
                  ),
                ),
                
                // Добавляем дополнительное пространство внизу, чтобы контент не обрезался
                const SizedBox(height: 50),
              ],
            ),
          ),

          //Кол-во и цена
          Positioned(
            bottom: 40, left: 40, right: 40,
            child: GestureDetector(
              onTap: () {
                CartItem c = CartItem(product: widget._product, quantity: itemAmount, addedSyrups: ["Яблочный"], size: selectedSize);
                appState.addToCart(c);
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20), child: Text(
                      '${widget._product.prices[selectedSize]} ₽',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                    Icon(Icons.shopping_cart, color: Colors.white,),
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
                              if (itemAmount > 1) setState(() {
                                itemAmount -= 1;
                              })
                            },
                            icon: Icon(Icons.remove),
                            color: Colors.brown
                          ),
                          Container(width: 30, alignment: Alignment.center, padding: EdgeInsets.only(right: 3), child: Text(itemAmount.toString(), style: TextStyle(color: Colors.brown),)),
                          IconButton(onPressed: () => setState(() {
                            itemAmount += 1;
                          }), icon: Icon(Icons.add), color: Colors.brown)
                        ],
                      )
                    ),
                  ],
                )
              ),
            )
          )

        ],
      ),
    );
  }
}

Widget bottomSheetBuilder(BuildContext context) {
  return Container(
    width: double.infinity,
    height: double.maxFinite,
    child: Stack(
      children: [
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.brown),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        SingleChildScrollView(
          child: Icon(Icons.abc_outlined),
        )
      ],
    ),
  );
}