import 'package:flutter/cupertino.dart';

const List<Map<String, dynamic>> pointType = [
  {
    'value': 'remake',
    'label': 'Сдать на переработку',
  },
  {
    'value': 'trade',
    'label': 'Точки обмена вещами',
  },
  {
    'value': 'routes',
    'label': 'Экомаршруты',
  },
  {
    'value': 'event',
    'label': 'Мероприятия',
  },
];
const List<Map<String, dynamic>> remakeType = [
  {
    'value': 'battery',
    'label': 'Батарейки',
  },
  {
    'value': 'plastic',
    'label': 'Пластик',
  },
  {
    'value': 'paper',
    'label': 'Бумага',
  },
  {
    'value': 'clothes',
    'label': 'Одежда',
  },
  {
    'value': 'technic',
    'label': 'Бытовая техника',
  },
  {
    'value': 'lamps',
    'label': 'Лампочки',
  },
  {
    'value': 'glass',
    'label': 'Стекло',
  },
  {
    'value': 'other',
    'label': 'иное',
  },
];
const List<Map<String, dynamic>> tradeType = [
  {
    'value': 'books',
    'label': 'Книги',
  },
  {
    'value': 'clothes',
    'label': 'Одежда',
  },
  {
    'value': 'products',
    'label': 'Продукты',
  },
  {
    'value': 'hobbi',
    'label': 'Хобби',
  },
];
const List<Map<String, dynamic>> routesType = [
  {
    'value': 'transport',
    'label': 'Транспорт',
  },
  {
    'value': 'ekoroutes',
    'label': 'Экомаршруты',
  },
];
const List<Map<String, dynamic>> eventType = [
  {
    'value': 'sats',
    'label': 'Субботники',
  },
  {
    'value': 'ekopoints',
    'label': 'Точки сбора экологов',
  },
];
const List<List<String>> filteredSubTypes = [
  [
    "Батраейки",
    "Пластик",
    "Бумага",
    "Одежда",
    "Бытовая техника",
    "Лампочки",
    "Стекло",
    "Иное"
  ],
  ["Книги", "Одежда", "Продукты", "Хобби"],
  ["Транспорт", "Экомаршруты"],
  ["Субботники", "Точки сбора экологистов"],
];
const List<String> logoPaths = [
  "images/recycling.png",
  "images/trading.png",
  "images/route.png",
  "images/event.png"
];
const List<String> logoDescs =
[
  "Сдать на перарботку",
  "Точки обмена вещами",
  "Экомаршруты",
  "Мероприятия"
];
