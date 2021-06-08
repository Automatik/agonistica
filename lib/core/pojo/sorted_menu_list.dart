// @dart=2.9

import 'dart:collection';

import 'package:agonistica/core/models/menu.dart';

class SortedMenuList {

  SplayTreeSet<Menu> _sortedMenuList;

  SortedMenuList() {
    _sortedMenuList = SplayTreeSet((m1, m2) => Menu.compare(m1, m2));
  }

  factory SortedMenuList.from(List<Menu> menus) {
    SortedMenuList list = SortedMenuList();
    list.addAll(menus);
    return list;
  }

  void add(Menu menu) {
    _sortedMenuList.add(menu);
  }

  void addAll(List<Menu> menus) {
    _sortedMenuList.addAll(menus);
  }

  int size() {
    return _sortedMenuList.length;
  }

  Menu elementAt(int index) {
    return _sortedMenuList.elementAt(index);
  }

  List<Menu> toList() {
    return _sortedMenuList.toList();
  }

}