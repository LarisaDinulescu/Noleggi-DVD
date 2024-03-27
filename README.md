# Noleggi-DVD
Progetto basi di dati con lo scopo di modellare informazioni riguardanti i noleggi di DVD per una videoteca.
Buongiorno,
abbiamo creato una procedura guidata per eseguire gli script di R che serviranno a popolare il database e riprodurre i grafici
che sono presenti nella relazione.
Nella cartella PSQL potrà trovare il file "crea_db.sql" il quale potrà essere importato su postgreSQL per creare
la struttura del database.

Per quanto riguarda R abbiamo utilizzato la libreria "RPostgreSQL" che necessita di essere installata prima dell'
esecuione dello script tramite il comando "install.packages('RPostgreSQL')".
Le chiediamo, inoltre, di impostare la working directory nell'ambiente di R su questa cartella tramite il comando
"setwd("C:\\....\\progetto15")" sostituendo ai puntini la path del suo pc.

Successivamente, eseguendo il file "main.R" tramite il comando "source("main.R")", verranno eseguite tutte le
operazioni che abbiamo utilizzato in R tramite input testuali.

NOTA: lo script le chiederà di inserire "nome utente" e "password" del proprio PostgeSQL, le quali verranno generate e salvate in un
dataframe che verrà creato in "csv\credenziali\postgres.csv".

Grazie per l'attenzione.
