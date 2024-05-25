import 'package:flutter/material.dart';
import 'database.dart';

class AddPlansPage extends StatefulWidget {
  @override
  _AddPlansPageState createState() => _AddPlansPageState();
}

class _AddPlansPageState extends State<AddPlansPage> {
  late TextEditingController _amountController;
  String _selectedCategory = '';
  String _selectedIconPath = 'assets/icons/nalichka.png';
  bool _excludeNotifications = false;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    List<Map<String, dynamic>> savingsCategories = await DatabaseHelper().getSavings();
    List<Map<String, dynamic>> accountsCategories = await DatabaseHelper().getAccounts();
    setState(() {
      _categories = savingsCategories + accountsCategories;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить категорию'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/cash-outline.png',
                            width: 32.0,
                            height: 32.0,
                            scale: 0.8,
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                hintText: 'Введите сумму',
                                hintStyle: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 18.0,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            _selectedIconPath,
                            width: 36.0,
                            height: 38.0,
                            scale: 0.9,
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Colors.white,
                              value: _selectedCategory.isEmpty ? null : _selectedCategory,
                              items: _categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category['category'],
                                  child: Row(
                                    children: [
                                      if (_selectedCategory != category['category'])
                                        Image.asset(
                                          category['iconPath'],
                                          width: 24.0,
                                          height: 24.0,
                                          scale: 0.9,
                                        ),
                                      SizedBox(width: 12.0),
                                      Text(category['category']),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) async {
                                if (value != null) {
                                  String iconPath = await _getCategoryIcon(value);
                                  setState(() {
                                    _selectedCategory = value;
                                    _selectedIconPath = iconPath;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Выберите категорию',
                                hintStyle: TextStyle(
                                  color: Color(0xFF7F7F7F),
                                  fontSize: 18.0,
                                ),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 20, 120, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Включить уведомления',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                'Получить уведомление, когда вы приблизитесь к лимиту',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Color(0xFF7F7F7F),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 18,
                        child: IconButton(
                          icon: Image.asset(
                            _excludeNotifications
                                ? 'assets/icons/switch-enabled.png'
                                : 'assets/icons/switch-disabled.png',
                            width: 50.0,
                            height: 50.0,
                            scale: 0.9,
                          ),
                          onPressed: () {
                            setState(() {
                              _excludeNotifications = !_excludeNotifications;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _savePlans(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF10B981)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Добавить',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 35.0),
        ],
      ),
    );
  }

  Future<String> _getCategoryIcon(String category) async {
    String iconPath = await DatabaseHelper().getCategoryIconsSavings(category);
    if (iconPath.isEmpty) {
      iconPath = await DatabaseHelper().getAccountsCategoryIcons(category);
    }
    return iconPath;
  }

  void _savePlans(BuildContext context) async {
    double plannedAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (plannedAmount == 0 || _selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Введите корректную сумму и выберите категорию'),
        ),
      );
      return;
    }

    int planId = await DatabaseHelper().insertPlans(plannedAmount, _selectedCategory);
    if (planId != -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('План успешно добавлен в базу данных'),
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при добавлении плана в базу данных'),
        ),
      );
    }
  }


}

