# IZA - Druhý projekt
David Holas (xholas11)

<https://github.com/mr-kew/xholas11-IZA-proj2>

## Smysl
Aplikace Toolbox umožnuje uživateli vytvářet záznamy o nářadí (_tools_) a přihrádkách (_sections_). Každé nářadí patří do právě jedné přihrádky. Nářadí se uživateli zobrazuje po jednotlivých přihrádkách do kterých patří. 

Mimo demonstraci práce s _CoreData_ pro účely druhého projektu do IZA, tato aplikace pravděpodobně žádné reálné využití nemá. Po případném rozšíření záznamu o nářadí a přihrádce o další datové položky (fotka, ...) a vyhledávání by aplikace teoreticky mohla být používana k nějaké evidenci reálného nářadí.
	
## Použití
Při prázné databázi je nejdříve nutné vytvořit první přihrádku pomocí tlačítka _Edit_. To přepne tabulku do režimu editace, kde jeden řádek představuje jednu přihrádku. Je možné měnit pořadí ve kterém jsou přihrádky zobrazeny, mazat a vytvářet nové přihrádky a editovat stávající přihrádky (dotykem na příslušném řádku). Přihrádka obsahuje jediný atribut jméno (_Name_), který je povinný a musí být unikátní. Odstranění přihrádky způsobí odstranění všem záznamů o nářadí v dané přihrádce.

Pokud již aplikace obsahuje nějaké sekce, je možné vytvořit nářadí pomocí tlačítka _+_. Pouze atributy jméno (_Name_) a přihrádka (_Section_) jsou povinné při vytváření nového záznamu o nářadí, jméno musí být současně unikátní. Existující záznamy je možné upravit (dotykem na příslušném řádku) a následně odstranit.

## Implementace
Aplikace je implementována pomocí Storyboardu, skládá se ze čtyř scén obsahujících _UITableViewController_.

### ModelHandler
Aplikace pracuje s dvěmi instancemi třídy _ModelHandler_, která obaluje instanci _NSFetchedResultsController_ a zajišťuje přístup k databázi. Jedna instance pro práci s nářadím (_Tool_) a jedna pro práci s přihrádkami (_Section_).

#### Tvorba modelů
Model je vytvořen volaním metody _createModel()_ na příslušné instanci třídy _ModelHandler_. Po vyplnění atributů vytvořeného modelu může být model uložen do databáze (voláním _saveChanges()_) nebo smazán (voláním _discardChanges()_).

### Řazení
Pro změny pořádí přihrádek se používá číselný atribut _order_. Přihrádky se zobrazují seřazené podle tohoto atributu, takže pro změnu pořadí přihrádek stačí upravit jejich hodnoty atributu.