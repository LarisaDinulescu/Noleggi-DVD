#script per la generazione del grafico a barre raggruppate relativo al numero di noleggi suddiviso per case di produzione negli anni 2020 e 2021

#carico la libreria di postgres e credenziali utente create dal main.R
library(RPostgreSQL)
credenziali <- read.csv( "csv\\credenziali\\postgres.csv" )
user_name <- credenziali$user_name
psw <- credenziali$psw

drv <- dbDriver( "PostgreSQL" )
con <- dbConnect( drv, dbname="lab_basi", user=user_name, password=psw )
dbGetQuery(con, "SET search_path to progetto15;")

#reperimento dati dal db e creazione grafico
#abbiamo adottato la soluzione con un left join per riuscire a contare anche le case di produzione che non hanno avuto noleggi nell'anno in analisi
#NOTA: le condizioni sono state riportate nella clausola ON dei JOIN in quanto se inserite nella clausola WHERE avrebbero escluso in automatico le case di produzione senza noleggi
df1 <- dbGetQuery(con, "SELECT nome, COUNT(id_film) FROM noleggio AS n JOIN  produce AS p ON n.film_id=p.id_film AND n.data_inizio>'2021-01-01' AND n.data_inizio<'2022-01-01' RIGHT JOIN casa_di_produzione AS c ON c.nome=p.nome_casa_di_produzione GROUP BY nome ORDER BY nome;")
df2 <- dbGetQuery(con, "SELECT nome, COUNT(id_film) FROM noleggio AS n JOIN  produce AS p ON n.film_id=p.id_film AND n.data_inizio>'2020-01-01' AND n.data_inizio<'2021-01-01' RIGHT JOIN casa_di_produzione AS c ON c.nome=p.nome_casa_di_produzione GROUP BY nome ORDER BY nome;")
anno2021 <- data.frame(x=1:nrow(df1), y=2021)
df1$anno <- anno2021$y
anno2020 <- data.frame(x=1:nrow(df2), y=2020)
df2$anno <- anno2020$y
#unisco i dataframe
df_big <- rbind(df2, df1)

matr <- matrix(df_big$count, nrow=length(unique(df_big$nome)))
rownames(matr) <- unique(df_big$nome)
anni <- unique(df_big$anno)
barplot(matr, beside=TRUE, xlab="Case di produzione", ylab="Noleggi", main="Noleggi annuali divisi per casa di produzione", legend=TRUE, args.legend=list(x="topleft", inset=c(0.01,0)), ylim=c(0, 50), names.arg=anni, cex.main=0.9 )

dbDisconnect(con)