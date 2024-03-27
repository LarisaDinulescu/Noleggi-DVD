#script per la generazione del grafico a barre sovrapposte relativo a il genere degli attori che compaiono nei film raggruppati per casa di produzione

#carico la libreria di postgres e credenziali utente create dal main.R
library(RPostgreSQL)
credenziali <- read.csv( "csv\\credenziali\\postgres.csv" )
user_name <- credenziali$user_name
psw <- credenziali$psw

drv <- dbDriver( "PostgreSQL" )
con <- dbConnect( drv, dbname="lab_basi", user=user_name, password=psw )
dbGetQuery(con, "SET search_path to progetto15;")

#reperimento dati dal db e creazione grafico
df <- dbGetQuery(con, "SELECT nome_casa_di_produzione, sesso, COUNT(*) FROM attore AS a, compare_in AS c, produce AS p WHERE a.nome=c.nome_attore AND c.id_film=p.id_film GROUP BY sesso, nome_casa_di_produzione ORDER BY nome_casa_di_produzione;")
matr <- matrix(df$count, nrow=2)
rownames(matr) <- c("M","F")
colors <- c("#ADD8E6", "pink")
nomi <- substr(unique(df$nome_casa_di_produzione),1,9) #soluzione per rendere leggibile il label
barplot(matr, col=colors, xlab="Case di produzione", ylab="Attori", main="Genere degli attori che compaiono nei film delle diverse case di produzione", legend=TRUE, ylim=c(0, 60), names.arg=nomi, cex.name=0.7, cex.main = 0.8 )


dbDisconnect(con)