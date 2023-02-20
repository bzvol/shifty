// ignore_for_file: constant_identifier_names
enum Zone {
  Center(1, "Center", "Center"),
  Ujbuda(13000, "Ujbuda", "Újbuda"),
  Buda2Kerulet(13003, "Buda 2 kerulet", "Buda 2. kerület"),
  Zuglo(13004, "Zuglo", "Zugló"),
  UjpestAngyalfold(13001, "Ujpest angyalfold", "Újpest-Angyalföld"),
  Obuda(13017, "Obuda", "Óbuda"),
  CsepelPesterzsebet(13006, "Csepel pesterzsebet", "Csepel-Pesterzsébet"),
  KispestKobanya(13002, "Kispest kobanya", "Kispest-Kőbanya"),
  Pest17Kerulet(13025, "Pest 17 kerulet", "Pest 17. kerület"),
  Budafok(13015, "Budafok", "Budafok"),
  Budaors(13019, "Budaors", "Budaörs"),
  Erd(13027, "Erd", "Érd"),
  Dunakeszi(13029, "Dunakeszi", "Dunakeszi"),
  Vecses(13030, "Vecses", "Vecsés"),
  Budakalasz(13028, "Budakalasz", "Budakalász"),
  Godollo(13045, "Godollo", "Gödöllő"),
  Szentendre(13047, "Szentendre", "Szentendre"),
  Szigetszentmiklos(13064, "Szigetszentmiklos", "Szigetszentmiklós"),
  Vac(13065, "Vac", "Vác");

  const Zone(this.id, this.name, this.displayName);

  final int id;
  final String name;
  final String displayName;

  static Zone fromId(int id) => Zone.values.firstWhere((e) => e.id == id);

  static Zone fromName(String name) =>
      Zone.values.firstWhere((e) => e.name == name);

  @override
  String toString() => displayName;
}
