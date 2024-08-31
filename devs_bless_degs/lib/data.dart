import 'package:flutter/material.dart'; // Import this for GlobalKey
import 'package:flip_card/flip_card.dart';

List<String> fillSourceArray() {
  return [
    'assets/eggplant.jpg',
    'assets/cucumber.jpg',
    'assets/pumpkin1.jpg',
    'assets/carrot.jpg',
    'assets/bellpepper.jpg',
    'assets/bear.jpg',
    'assets/hippo.jpg',
    'assets/lion.jpg',
    'assets/monkey.jpg',
    'assets/rhino.jpg',
    'assets/zebra.jpg',
    'assets/banana.jpg',
    'assets/lemon.jpg',
    'assets/apple.jpg',
    'assets/orange.jpg',
    'assets/pear.jpg',
    'assets/straberry.jpg',
    'assets/watermelon.jpg',
    'assets/grapes.jpg',

  ];
}

enum Level { Hard, Medium, Easy }

List getSourceArray(Level level) {
  List<String> levelList = [];
  List sourceArray = fillSourceArray();

  if (level == Level.Hard) {
    for (int i = 11; i < 19; i++) {
      levelList.add(sourceArray[i]);
    }
  } else if (level == Level.Medium) {
    for (int i = 5; i < 11; i++) {
      levelList.add(sourceArray[i]);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 4; i++) {
      levelList.add(sourceArray[i]);
    }
  }

  levelList.shuffle();
  return levelList;
}

List<bool> getInitialItemState(Level level) {
  List<bool> initialItemState = [];

  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      initialItemState.add(true);
    }
  }

  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardStateKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];

  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }

  return cardStateKeys;
}