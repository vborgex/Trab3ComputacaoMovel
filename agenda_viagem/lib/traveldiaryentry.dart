// Definição das constantes para os nomes das colunas
const String dateColumn = "date";
const String titleColumn = "title";
const String descriptionColumn = "description";
const String localizationColumn = "localization";
const String ratingColumn = "rating";

class TravelDiaryEntry {
  // Valor padrão para ID
  String title = ''; // Valor padrão para título
  String description = ''; // Valor padrão para descrição
  String localization = ''; // Valor padrão para localização
  String rating = ''; // Valor padrão para avaliação
  String date = DateTime.now().toIso8601String(); // Valor padrão para data

  TravelDiaryEntry();

  TravelDiaryEntry.fromMap(Map<String, dynamic> map) {
    date = map[dateColumn];
    title = map[titleColumn];
    description = map[descriptionColumn];
    localization = map[localizationColumn];
    rating = map[ratingColumn];
  }

  Map<String, dynamic> toMap() {
    return {
      dateColumn: date,
      titleColumn: title,
      descriptionColumn: description,
      localizationColumn: localization,
      ratingColumn: rating,
    };
  }

  @override
  String toString() {
    return "TravelDiaryEntry(date: $date, title: $title, description: $description, localization: $localization, rating: $rating)";
  }
}
