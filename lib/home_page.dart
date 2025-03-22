import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'product.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {


  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _keys = {};

  @override
  void initState() {
    final appState = Provider.of<AppState>(context, listen: false);
    for (int i = 0; i < appState.categories.length; i++) {
      _keys[i] = GlobalKey();
    }
    appState.selectCategory(0);
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
    if (_isFullyVisible(index)) return;

    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = 120.0;
    double scrollOffset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      scrollOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutSine,
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return SliverToBoxAdapter(child:
      Container(
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Горизонтальный список категорий
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: appState.categories.length,
                  itemBuilder: (context, index) {
                    return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    child: IntrinsicWidth(
                      stepWidth: 30.0,
                      child: ChoiceChip(
                        key: _keys[index],
                        label: Text(appState.categories[index]),
                        selected: appState.selectedCategoryIndex == index,
                        showCheckmark: false,
                        onSelected: (selected) {
                          setState(() {
                            appState.selectCategory(index);
                            _scrollToSelected(index);
                          });
                        },
                        disabledColor: Colors.white,
                        selectedColor: Colors.brown,
                        surfaceTintColor: Colors.transparent,
                        labelStyle: TextStyle(color: appState.selectedCategoryIndex == index ? Colors.white : Colors.black),
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6.0),
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        ) //Choise Chip
                      ), // IntrinsicWidth
                    ); //Padding
                  }
                ),
              ),
            ),
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
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        onTap: () => print("MenuItem Pressed ${appState.selectedCategoryProducts[index].name}"),
                        child: Card(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          color: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(appState.selectedCategoryProducts[index].image),
                              Container(
                                padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                                child: Text(
                                  appState.selectedCategoryProducts[index].name,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, leadingDistribution: TextLeadingDistribution.even),
                                )
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                    (appState.selectedCategoryProducts[index].price.toString() + appState.selectedCategoryProducts[index].currency),
                                    style: TextStyle(color: Colors.brown),
                                    ),
                                    Icon(Icons.arrow_forward_ios, color: Colors.brown)
                                  ]
                                )
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: appState.selectedCategoryProducts.length,
                  ),
                ),
                SliverToBoxAdapter(child: Visibility(visible: appState.noItemsInCategory, 
                  child: Text("В этой категории нет товаров :(", style: 
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