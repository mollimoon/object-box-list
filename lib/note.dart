import 'package:objectbox/objectbox.dart';

/// Во-первых, нам нужна модель для записи
///
/// Сделали нужный импорт и пометили класс аннотацией @Entity() ,
/// благодаря которой, библиотека создаст нам таблицу для хранения заметок Note
@Entity()
class Note {
  @Id()
  ///это уникальный идентификационный номер, которым база данных помечает запись в таблице,
  ///чтобы отличить одну запись от другой.
  int id;
  String name;
  String description;

  Note({
    this.id = 0,
    required this.name,
    required this.description,
  });
}
