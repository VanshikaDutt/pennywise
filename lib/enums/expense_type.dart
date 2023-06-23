import 'package:flutter/material.dart';

enum ExpenseType {
  food("Food", Icons.fastfood),
  travel("Travel", Icons.commute),
  entertainment("Entertainment", Icons.theater_comedy),
  shopping("Shopping", Icons.shopping_cart_outlined),
  beauty("Beauty", Icons.add_reaction_outlined),
  education("Education", Icons.book_outlined),
  social("Social", Icons.people_outline),
  other("Other", Icons.category);

  final String name;
  final IconData icon;

  const ExpenseType(this.name, this.icon);
}
