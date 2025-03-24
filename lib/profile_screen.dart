import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Пример списка истории заказов (для демонстрации)
  // В реальном приложении это будет динамический список
  final List<Map<String, String>> orderHistory = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8, // Фиксированная высота (80% экрана)
      padding: const EdgeInsets.all(16), // Отступы по краям
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          // Основное содержимое
          Column(
            children: [
              // Профиль пользователя
              Card(
                margin: EdgeInsets.only(top: 60),
                color: Colors.white,
                child: Row(
                  children: [
                    // Иконка профиля
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.brown,
                      ),
                    ),
                    const SizedBox(width: 16), // Отступ между иконкой и текстом
                    // Имя и номер телефона (захардкодили)
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Иван',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '+7 927 777 66 55',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Стрелка
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.brown,
                      size: 30,
                    ),
                    const SizedBox(width: 16),
                    // Кнопка-крест в верхнем правом углу
                  ],
                ),
              ),
              const SizedBox(height: 40), // Отступ перед списком заказов
              // Список заказов или заглушка
              Expanded(
                child: orderHistory.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Здесь будет список заказов',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        itemCount: orderHistory.length,
                        itemBuilder: (context, index) {
                          final order = orderHistory[index];
                          return Card(
                            color: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Дата заказа
                                  Text(
                                    'Заказ от ${order['date']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Состав заказа
                                  Text(
                                    order['items']!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Сумма заказа
                                  Text(
                                    'Сумма: ${order['total']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20), // Отступ перед кнопкой
              // Кнопка "Заказать"
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown, // Коричневый цвет с макета
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 5, // Добавляем тень
                  ),
                  child: const Text(
                    'Заказать',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 5, right: 5,
            child: IconButton(
              style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.grey),
                          shape: WidgetStateProperty.all(const CircleBorder()),
              ),
              icon: const Icon(Icons.close, color: Colors.brown),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
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
      builder: (context) => ProfileScreen(),
    );
  }
}