import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category{
  final int id;
  final String name;
  final dynamic icon;
  Category(this.id, this.name, {this.icon});

}

final List<Category> categories = [
  Category(9,"General Knowledge", icon: FontAwesomeIcons.earthAsia),
  Category(10,"Books", icon: FontAwesomeIcons.bookOpen),
  Category(11,"Film", icon: FontAwesomeIcons.video),
  Category(12,"Music", icon: FontAwesomeIcons.music),
  Category(13,"Musicals & Theatres", icon: FontAwesomeIcons.masksTheater),
  Category(14,"Television", icon: FontAwesomeIcons.tv),
  Category(15,"Video Games", icon: FontAwesomeIcons.gamepad),
  Category(16,"Board Games", icon: FontAwesomeIcons.chessBoard),
  Category(17,"Science & Nature", icon: FontAwesomeIcons.microscope),
  Category(18,"Computers", icon: FontAwesomeIcons.laptopCode),
  Category(19,"Mathmatics", icon: FontAwesomeIcons.arrowDown19),
  Category(20,"Mythology", icon: FontAwesomeIcons.dragon),
  Category(21,"Sports", icon: FontAwesomeIcons.football),
  Category(22,"Geography", icon: FontAwesomeIcons.mountain),
  Category(23,"History", icon: FontAwesomeIcons.clockRotateLeft),
  Category(24,"Politics", icon: FontAwesomeIcons.bullhorn),
  Category(25,"Art", icon: FontAwesomeIcons.paintbrush),
  Category(26,"Celebrities", icon: FontAwesomeIcons.star),
  Category(27,"Animals", icon: FontAwesomeIcons.dog),
  Category(28,"Vehicles", icon: FontAwesomeIcons.carRear),
  Category(29,"Comics", icon: FontAwesomeIcons.bookOpenReader),
  Category(30,"Gadgets", icon: FontAwesomeIcons.mobileScreenButton),
  Category(31,"Japanese Anime & Manga", icon: FontAwesomeIcons.robot),
  Category(32,"Cartoon & Animation", icon: FontAwesomeIcons.dAndDBeyond),
];
