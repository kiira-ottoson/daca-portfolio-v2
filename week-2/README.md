## week 2 - SQL Andmete puhastamine
### Eesmärk: andmedomeenide puhastamine
Eelmine nädal tuvastasin erinevates domeenides mitmeid probleeme — duplikaate, puuduvaid (NULL) väärtusi ja formaadivigu. Seekord selgitan täpsemalt, millised read on duplikaadid. Ning enne andmeanalüüsiga jätkamist puhastan andmed domeeniti.

### Mida tegin?
- Puhastasin tabelid "sales", "customers", "products"
- Järgisin protsessi: test koopia -> puhastamine -> kontroll -> dokumenteerimine
- Lisandunud käsud: GROUP BY + HAVING, DELETE + WHERE, UPDATE + SET, COALESCE, CASE WHEN, TRIM/INITCAP

### Põhilised tulemused - puhastamisraport
| **Müügiandmed** | Enne | Pärast | Kirjeldus |
|---|---|---|---|
| Duplikaatread | 5116 | 0 | Kustutati korduvad müügitehingud |
| NULL customer_id | 1487 | 988 | Külalisostud — äriloogika, mitte viga |
| NULL sale_date | 0 | 0 | Korras |
| NULL total_price | 0 | 0 | Korras |
| Tuleviku kuupäevad | 50 | 32 | Õige kuupäev teadmata — ei muudetud |
| Ridu (müügitehingut) kokku| 15 234 | 10 118 |

### Projekti failid:
w2_sales_cleaning.sql