Kaffemaskine Database Projekt

Dette repository indeholder SQL-scripts og dokumentation til design og opbygning af en database til en kaffemaskine. Projektet er lavet som en individuel aflevering.

Forfatter:
Babak Rahpeima - Kursus: Embeddedsystems

Filer i dette projekt:
- KAFFE-mini-project-Babak.sql: Denne fil indeholder selve koden.
- Mini_Projekt_SQL.pdf: Dette er projektrapporten der forklarer hvordan systemet virker og viser ER-diagrammet.

Systemprogram: 
Databasen er lavet til MySQL.

For at køre koden:
1. Åbn MySQL Workbench.
2. Log på din MySQL-server.
3. Kør filen KAFFE-mini-project-Babak.sql.

Systemets funktioner: 
Databasen er sat op efter 3. normalform (3NF) for at undgå rod i data. Følgende ting kan styres:
- Medarbejdere: Alle medarbejdere har et unikt ID.
- Salg og køb: Gemmer køb af drikkene Espresso, Americano og Cappuccino, og om der er betalt med kort eller kontanter.
- Lager: Den holder styr på kaffebønner og mælk, og gemmer historik over opfyldning.
- Penge: Registrere når der bliver trukket kontanter ud af maskinen.
- Vedligeholdelse: Gemmer en historik over hvornår maskinen er blevet gjort ren.

Udvalgte testkoder: 
a. Salg i et bestemt tidsrum sorteret efter type og drik. 
b. Den aktuelle status på lageret. 
c. Hvornår maskinen sidst er blevet gjort ren.
