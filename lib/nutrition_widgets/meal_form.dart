import 'package:flutter/material.dart';

// Food Data Model
class FoodItem {
  final String name;
  final int calories;
  final String mealType;

  const FoodItem({
    required this.name,
    required this.calories,
    required this.mealType,
  });
  
  // JSON Serialisation Methods
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'calories': calories,
      'mealType': mealType,
    };
  }
  
  // JSON Deserialisation Methods
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      name: json['name'] as String,
      calories: json['calories'] as int,
      mealType: json['mealType'] as String,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FoodItem &&
        other.name == name &&
        other.calories == calories &&
        other.mealType == mealType;
  }

  @override
  int get hashCode => Object.hash(name, calories, mealType);
}

// Meal form component, supports adding, editing, deleting food items, real-time data validation and status management.
class MealForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController foodNameController;
  final TextEditingController caloriesController;
  final String mealType;
  final List<FoodItem> initialFoodItems;
  final Function(List<FoodItem>) onFoodItemsUpdate;
  final bool shouldCancelEdit; // Should the edit flag be removed
  final VoidCallback? onEditStateChanged; // Edit state change callbacks
  
  const MealForm({
    super.key,
    required this.formKey,
    required this.foodNameController,
    required this.caloriesController,
    required this.mealType,
    required this.initialFoodItems,
    required this.onFoodItemsUpdate,
    this.shouldCancelEdit = false,
    this.onEditStateChanged,
  });

  @override
  State<MealForm> createState() => _MealFormState();
}

class _MealFormState extends State<MealForm> with TickerProviderStateMixin {
  // Data state
  late List<FoodItem> _foodItems;

  // Edit state: -1 means no item is being edited, -2 means adding a new item, other values represent the index being edited
  int _editingIndex = -1;

  // Edit controllers
  final TextEditingController _editFoodController = TextEditingController();
  final TextEditingController _editCaloriesController = TextEditingController();

  final FocusNode _foodNameFocusNode = FocusNode();
  final FocusNode _caloriesFocusNode = FocusNode();

  // Validation error states
  String? _foodNameError;
  String? _caloriesError;

  // Toast animation
  OverlayEntry? _overlayEntry;
  late AnimationController _toastController;
  late Animation<double> _toastAnimation;

  // Style constants
  static const EdgeInsets _containerPadding = EdgeInsets.all(10);
  static const EdgeInsets _rowPadding = EdgeInsets.symmetric(vertical: 2, horizontal: 4);
  static const EdgeInsets _buttonPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);

  static const Color _primaryColor = Color(0xff41b8d5);
  static const Color _backgroundColor = Color.fromARGB(255, 250, 250, 250);
  static const Color _errorColor = Colors.red;

  static const Duration _toastDuration = Duration(milliseconds: 300);
  static const Duration _toastDisplayDuration = Duration(seconds: 1);

  // Validation constants
  static const int _maxFoodNameLength = 30;
  static const int _maxCalories = 9999;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimations();
    _setupFocusListeners();
  }

  void _setupFocusListeners() {
    _foodNameFocusNode.addListener(() {
      if (_foodNameFocusNode.hasFocus) {
        _scrollToInputField();
      }
    });
    
    _caloriesFocusNode.addListener(() {
      if (_caloriesFocusNode.hasFocus) {
        _scrollToInputField();
      }
    });
  }
  
  void _scrollToInputField() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        Scrollable.ensureVisible(
          context,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void didUpdateWidget(covariant MealForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handling of cancellation of editing signals
    if (widget.shouldCancelEdit && !oldWidget.shouldCancelEdit) {
      if (_editingIndex != -1) {
        _cancelEdit();
      }
    }

    // Update local data when parent-provided data changes
    if (!_listsEqual(widget.initialFoodItems, oldWidget.initialFoodItems)) {
      setState(() {
        _foodItems = List.from(widget.initialFoodItems);
      });
    }
  }

  @override
  void dispose() {
    _disposeResources();
    _foodNameFocusNode.dispose();
    _caloriesFocusNode.dispose();
    super.dispose();
  }

  // Initialize data and controllers
  void _initializeData() {
    _foodItems = List.from(widget.initialFoodItems);
  }

  // Setup animation controller
  void _setupAnimations() {
    _toastController = AnimationController(
      duration: _toastDuration,
      vsync: this,
    );
    _toastAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _toastController, curve: Curves.easeInOut),
    );
  }

  // Dispose resources
  void _disposeResources() {
    _editFoodController.dispose();
    _editCaloriesController.dispose();
    _toastController.dispose();
    _removeOverlay();
  }

  // Compare if two lists are equal
  bool _listsEqual(List<FoodItem> list1, List<FoodItem> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  // Start editing a specific item
  void _startEditing(int index) {
    setState(() {
      _editingIndex = index;
      _editFoodController.text = _foodItems[index].name;
      _editCaloriesController.text = _foodItems[index].calories.toString();
      _clearErrors();
    });
    widget.onEditStateChanged?.call(); // Notification of edit status changes
  }

  // Start adding a new item
  void _addNewItem() {
    setState(() {
      _editingIndex = -2;
      _clearErrors();
    });
    widget.onEditStateChanged?.call(); // Notification of edit status changes
  }

  // Clear validation errors
  void _clearErrors() {
    _foodNameError = null;
    _caloriesError = null;
  }

  // Validate user inputs
  bool _validateInputs() {
    bool isValid = true;

    // Validate food name
    final foodName = _editFoodController.text.trim();
    if (foodName.isEmpty) {
      _foodNameError = "Input box cannot be empty!";
      isValid = false;
    } else if (foodName.length > _maxFoodNameLength) {
      _foodNameError = "Food name too long (max $_maxFoodNameLength characters)!";
      isValid = false;
    } else {
      _foodNameError = null;
    }

    // Validate calories
    final caloriesText = _editCaloriesController.text.trim();
    if (caloriesText.isEmpty) {
      _caloriesError = "Input box cannot be empty!";
      isValid = false;
    } else {
      final calories = int.tryParse(caloriesText);
      if (calories == null) {
        _caloriesError = "Please enter a number!";
        isValid = false;
      } else if (calories <= 0) {
        _caloriesError = "Please enter the correct number!";
        isValid = false;
      } else if (calories > _maxCalories) {
        _caloriesError = "The number is too large!";
        isValid = false;
      } else {
        _caloriesError = null;
      }
    }

    return isValid;
  }

  // Save edit
  void _saveEdit() {
    if (!_validateInputs()) {
      _showValidationError();
      return;
    }

    final foodItem = FoodItem(
      name: _editFoodController.text.trim(),
      calories: int.parse(_editCaloriesController.text.trim()),
      mealType: widget.mealType,
    );

    setState(() {
      if (_editingIndex == -2) {
        _foodItems.add(foodItem);
      } else {
        _foodItems[_editingIndex] = foodItem;
      }
      _finishEditing();
    });

    widget.onFoodItemsUpdate(_foodItems);
  }

  // Show validation error
  void _showValidationError() {
    final errorMessage = _foodNameError ?? _caloriesError ?? "Unknown error";
    _showToast(errorMessage);
    setState(() {}); // Update UI to show red border
  }

  // Finish editing state
  void _finishEditing() {
    _editingIndex = -1;
    _clearErrors();
    _editFoodController.clear();
    _editCaloriesController.clear();
    widget.onEditStateChanged?.call(); // Notification of edit status changes
  }

  // Cancel editing
  void _cancelEdit() {
    setState(() {
      _finishEditing();
    });
  }

  // Delete an item
  void _deleteItem(int index) {
    setState(() {
      _foodItems.removeAt(index);
    });
    widget.onFoodItemsUpdate(_foodItems);
  }

  // Clear all items
  void _clearAll() {
    _showConfirmDialog().then((confirmed) {
      if (confirmed == true) {
        setState(() {
          _foodItems.clear();
          _finishEditing();
        });
        widget.onFoodItemsUpdate(_foodItems);
      }
    });
  }

  // Show confirmation dialog
  Future<bool?> _showConfirmDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Clear',
            style: TextStyle(
              fontSize: 18
            )
          ),
          content: const Text(
            'Are you sure you want to clear all food items in this meal form?',
            textAlign: TextAlign.justify,
            style: TextStyle(
              fontSize: 14
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Confirm'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show toast message
  void _showToast(String message) {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _toastAnimation,
        builder: (context, child) => _buildToastOverlay(message),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);

    _toastController.forward().then((_) {
      Future.delayed(_toastDisplayDuration, () {
        _toastController.reverse().then((_) => _removeOverlay());
      });
    });
  }

  // Build toast overlay
  Widget _buildToastOverlay(String message) {
    return Positioned(
      top: 30,
      left: 20,
      right: 20,
      child: Opacity(
        opacity: _toastAnimation.value,
        child: Transform.scale(
          scale: 0.8 + 0.2 * _toastAnimation.value,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(230, 82, 81, 81),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Remove overlay
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _toastController.reset();
  }

  // Calculate total calories
  int _getTotalCalories() {
    return _foodItems.fold(0, (sum, item) => sum + item.calories);
  }

  // Handle input change (clear error state)
  void _onInputChanged(bool isFoodName) {
    if ((isFoodName && _foodNameError != null) || 
        (!isFoodName && _caloriesError != null)) {
      setState(() {
        if (isFoodName) {
          _foodNameError = null;
        } else {
          _caloriesError = null;
        }
      });
    }
  }

 double getHeaderFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 18;
    } else if (screenHeight > 750) {
       return 17;
    } else {
       return 16;
    }
  }

  double getEmptyFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 22;
    } else if (screenHeight > 750) {
       return 20;
    } else {
       return 18;
    }
  }

  double getBottonWidth(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 100;
    } else if (screenHeight > 750) {
       return 95;
    } else {
       return 90;
    }
  }

  double getBottonHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 28;
    } else if (screenHeight > 750) {
       return 26;
    } else {
       return 24;
    }
  }

  double getBottonSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 20;
    } else if (screenHeight > 750) {
       return 19;
    } else {
       return 18;
    }
  }

  double getBottonFontSize(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    if (screenHeight > 850) {
      return 16;
    } else if (screenHeight > 750) {
       return 15;
    } else {
       return 14;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _containerPadding,
      decoration: _buildContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildFoodList(),
          _buildDivider(),
          _buildActionButtons(),
        ],
      ),
    );
  }

  // Build container decoration
  BoxDecoration _buildContainerDecoration() {
    return BoxDecoration(
      color: _backgroundColor,
      border: Border.all(color: Colors.grey.shade300),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  // Build header
  Widget _buildHeader() {
    return Row(
        children: [
          Text(
            '${widget.mealType} Foods',
            style: TextStyle(
              fontSize: getHeaderFontSize(context),
              fontWeight: FontWeight.w600,
              color: _primaryColor,
            ),
          ),
          const Spacer(),
          if (_foodItems.isNotEmpty)
            Text(
              '${_foodItems.length} item${_foodItems.length > 1 ? 's' : ''}, ${_getTotalCalories()} kcal',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      );
  }

  // Build food list
  Widget _buildFoodList() {
    return Container(
      constraints: const BoxConstraints(minHeight: 30),
      child: _foodItems.isEmpty && _editingIndex != -2
          ? _buildEmptyState()
          : _buildFoodItems(),
    );
  }

  // Build empty state
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6),
        child: Text(
          'No food yet.',
          style: TextStyle(
            color: Colors.grey,
            fontSize: getEmptyFontSize(context),
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  // Build food item list
  Widget _buildFoodItems() {
    return Column(
      children: [
        // Existing items
        for (int i = 0; i < _foodItems.length; i++) ...[
          if (i > 0) Divider(height: 1, color: Colors.grey.shade300),
          _editingIndex == i ? _buildEditRow(i) : _buildDataRow(i),
        ],

        // New item row
        if (_editingIndex == -2) ...[
          if (_foodItems.isNotEmpty) Divider(height: 1, color: Colors.grey.shade300),
          _buildEditRow(-2),
        ],
      ],
    );
  }

  // Build data display row
  Widget _buildDataRow(int index) {
    final item = _foodItems[index];
    return Container(
      padding: _rowPadding,
      child: Row(
        children: [
          // Food name
          Expanded(
            flex: 40,
            child: Text(
              item.name.isNotEmpty ? item.name : 'Unnamed',
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Expanded(flex: 3, child: SizedBox()),
          // Calories
          Expanded(
            flex: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${item.calories}',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
                const Text(
                  'kcal',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Expanded(flex: 3, child: SizedBox()),
          // Action buttons
          _buildActionIcon(Icons.edit, () => _startEditing(index)),
          const SizedBox(width: 4),
          _buildActionIcon(Icons.close, () => _deleteItem(index)),
        ],
      ),
    );
  }

  // Build edit row
  Widget _buildEditRow(int index) {
    return Container(
      padding: _rowPadding,
      child: Row(
        children: [
          // Food name text field
          Expanded(
            flex: 50,
            child: _buildTextField(
              controller: _editFoodController,
              hintText: 'Food name',
              hasError: _foodNameError != null,
              onChanged: () => _onInputChanged(true),
              focusNode: _foodNameFocusNode,
            ),
          ),
          const Expanded(flex: 5, child: SizedBox()),
          // Calories text field
          Expanded(
            flex: 25,
            child: _buildTextField(
              controller: _editCaloriesController,
              hintText: 'kcal',
              hasError: _caloriesError != null,
              keyboardType: TextInputType.number,
              onChanged: () => _onInputChanged(false),
              focusNode: _caloriesFocusNode,
            ),
          ),
          const Expanded(flex: 5, child: SizedBox()),
          // Save button
          ElevatedButton(
            onPressed: _saveEdit,
            style: _buildButtonStyle(_primaryColor),
            child: const Text('Save', style: TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 4),
          // Cancel button
          _buildActionIcon(Icons.close, _cancelEdit, size: 20),
        ],
      ),
    );
  }

  // Build text input field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool hasError,
    TextInputType? keyboardType,
    required VoidCallback onChanged,
    FocusNode? focusNode,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 14),
        onChanged: (_) => onChanged(),
        textInputAction: keyboardType == TextInputType.number 
            ? TextInputAction.done 
            : TextInputAction.next,
        onFieldSubmitted: (_) {
          if (focusNode == _foodNameFocusNode) {
            _caloriesFocusNode.requestFocus();
          } else {
            FocusScope.of(context).unfocus();
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: _buildInputBorder(hasError),
          enabledBorder: _buildInputBorder(hasError),
          focusedBorder: _buildInputBorder(hasError, focused: true),
          contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          isDense: true,
        ),
      ),
    );
  }

  // Build input border
  OutlineInputBorder _buildInputBorder(bool hasError, {bool focused = false}) {
    Color borderColor;
    if (hasError) {
      borderColor = _errorColor;
    } else if (focused) {
      borderColor = _primaryColor;
    } else {
      borderColor = Colors.grey;
    }

    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: 1.5),
    );
  }

  // Build action icon
  Widget _buildActionIcon(IconData icon, VoidCallback onTap, {double size = 16}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Icon(
          icon,
          size: size,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  // Build divider
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8, top: 1),
      height: 2,
      color: Colors.grey.shade400,
    );
  }

  // Build action buttons
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(
          onPressed: _editingIndex == -1 ? _addNewItem : null,
          icon: Icons.add,
          label: 'Add',
          backgroundColor: _primaryColor,
        ),
        _buildActionButton(
          onPressed: _editingIndex == -1 && _foodItems.isNotEmpty ? _clearAll : null,
          icon: Icons.delete_outline,
          label: 'Clear',
          backgroundColor: Colors.grey,
        ),
      ],
    );
  }

  // Build action button
  Widget _buildActionButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required Color backgroundColor,
  }) {
    return SizedBox(
      width: getBottonWidth(context),
      height: getBottonHeight(context),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: _buildButtonStyle(backgroundColor),
      ),
    );
  }

  // Build button style
  ButtonStyle _buildButtonStyle(Color backgroundColor) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: TextStyle(fontSize: getBottonFontSize(context), fontWeight: FontWeight.w500),
      padding: _buttonPadding,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}