#script per la generazione del grafico a linee relativo all'andamento dei noleggi nell'anno 2021

#carico la libreria di postgres e credenziali utente create dal main.R
library(RPostgreSQL)
credenziali <- read.csv( "csv\\credenziali\\postgres.csv" )
user_name <- credenziali$user_name
psw <- credenziali$psw

drv <- dbDriver( "PostgreSQL" )
con <- dbConnect( drv, dbname="lab_basi", user=user_name, password=psw )
dbGetQuery(con, "SET search_path to progetto15;")

#abbiamo utilizzato date_part per estrarre il mese da un elemento di dipo date (trovato su internet)
df <- dbGetQuery(con, "SELECT date_part('month', data_inizio) as month, count(*) FROM noleggio WHERE data_inizio>'2021-01-01' AND data_inizio<'2022-01-01' GROUP BY month ORDER BY month;")
plot(df$month, df$count, "o", xlab="Mese", ylab="Noleggi", main="Andamento noleggi 2021", xlim=c(1,12), ylim=c(0,20) )


dbDisconnect(con)
