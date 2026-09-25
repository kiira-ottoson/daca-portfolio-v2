## Week 1 - SQL Basics
### Eesmärk: uurida andmestikku ja koostada esmane andmekvaliteedi raport
Enne edasisi analüüse on vaja hinnata andmete kvaliteeti: saada ülevaade olemasolevatest andmetest, leida duplikaadid, puuduvad väärtused, ebaloogilised andmed. 

### Mida tegin?
- Uurisin SQL päringutega tabeleid "sales" ja "customers"
- Õppisin päringuid: SELECT, FROM, WHERE, ORDER BY, LIMIT, DISTINCT, COUNT

### Põhilised tulemused:
**Sales** tabelis on kokku 15 234 rida (müügitehingut), millest 5116 on potentsiaalsed duplikaadid. See võib moonutada müügitulemuste ülevaadet. 305 negatiivset tehingut (~2%), tõenäoliselt tagastused, mida ei tohi müügituluga segamini ajada. ~10% tehingutest on teinud registreerumata kliendid (st customer_id puudub). Online poe puhul asukoht puudub, mis on loogiline. 

<img src="w1_sales_screenshot.png" alt="Sales tabeli põhilised tulemused" width="600">

### Projekti failid:
w1_sales_exploration.sql  
w1_customers_explorations.sql  
w1_sales_screenshot.png

