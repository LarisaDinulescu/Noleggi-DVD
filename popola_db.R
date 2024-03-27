#Questo script popola il batabase

print("Script per il popolamento del database del progetto15")

#imposto il seed
set.seed(42)

#carico la libreria di postgres e credenziali utente create dal main.R
library(RPostgreSQL)
credenziali <- read.csv( "csv\\credenziali\\postgres.csv" )
user_name <- credenziali$user_name
psw <- credenziali$psw

#db connection
drv <- dbDriver("PostgreSQL")
con <- dbConnect(drv, dbname="lab_basi", user=user_name, password=psw)
dbGetQuery(con, "SET search_path to progetto15;")
print("Operazioni di connessione al batabase concluse")

print("<<Inizio della creazione dei data frame da inserire nelle tabelle>>")

#Carico i dati della tabella film
df <- read.csv("csv\\film\\film.csv")
id <- 1:100
titolo <- df$titolo
anno_di_produzione <- df$anno_di_produzione
generi <- df$generi
regista <- df$regista
descrizione <- df$descrizione
df_film <- data.frame(id, titolo, anno_di_produzione, generi, regista, descrizione)
print("Film creati")

#Carico i dati della tabella produce
df_cdp <- read.csv("csv\\CaseDiProduzione\\casediproduzione.csv")
nome_casa_di_produzione <- sample(head(df_cdp$nome, 5), 89, replace=TRUE)
id_film <- 1:89
df_produce <- data.frame(nome_casa_di_produzione, id_film)
id_film <- 90:100
t <- data.frame(x=1:11, y=tail(df_cdp$nome, 1))
nome_casa_di_produzione <- t$y
df_produce_western <- data.frame(nome_casa_di_produzione, id_film)
print("produce creato")

#Carico i dati del cliente
cf <- read.csv("csv\\cliente\\cf.csv")
generalita <- read.csv("csv\\cliente\\nomi_cognomi.csv")
indirizzi <- read.csv("csv\\cliente\\indirizzi.csv")
nome <- generalita$nome
cognome <- generalita$cognome
email <- read.csv("csv\\cliente\\email.csv")
data_di_nascita <- read.csv("csv\\cliente\\date.csv")
cf <- cf$cf
indirizzo <- indirizzi$indirizzo
e_mail <- email$email
data_di_nascita <- data_di_nascita$data_di_nascita
cap <- sample(10000:99999, 100)
telefono <- sample(1000000000:9999999999, 100)

df_clienti <- data.frame(cf, nome, cognome, telefono, data_di_nascita, cap, e_mail)
print("clienti creati")

#Carico i dati degli attori
nome_attori <- read.csv("csv\\attore\\attore.csv")
nome <- head(nome_attori$nome, 150)
data_di_nascita <- read.csv("csv\\cliente\\date.csv")
data_di_nascita <- sample(data_di_nascita$data_di_nascita, 150, replace=TRUE)
x <- factor( c("m","f")) #creo collezione di m,f
df_sesso <- data.frame( sesso = sample( x, 150, replace=TRUE))
sesso <- df_sesso$sesso
df_nazioni <- read.csv("csv\\attore\\nazionalita.csv")
nazionalita <- sample(df_nazioni$nazionalita, 150, replace=TRUE) #metto nazionalità a random 
df_attore <- data.frame(nome, data_di_nascita, sesso, nazionalita)
print("attori creati")

#Carico i dati di compare_in
df_ci <- read.csv("csv\\attore\\compare_in.csv")
id_film <- df_ci$id_film
nome_attore <- df_ci$nome_attore
df_compare_in <- data.frame(nome_attore, id_film)
#Facciamo comparire John Travolta
id_film <- sample(1:100, 20)
travolta <- data.frame(x=1:20, y="John Travolta")
nome_attore <- travolta$y
df_compare_in_travolta <- data.frame(nome_attore, id_film)
print("compare_in creati")

#Carico i dati dei dvd
df <- read.csv("csv\\film\\dvd.csv")
progressivo <- df$progressivo
id_film <- df$id_film
zero <- data.frame(x=1:1000, y=0) #--> creo una colonna di 100 zeri
numero_di_noleggi <- zero$y
df_dvd <- data.frame(progressivo, id_film, numero_di_noleggi)
print("dvd creati")

#Carico i dati dei noleggi
data_inizio <- sample(seq(as.Date('2019/01/01'), as.Date('2020/12/28'), by="day"), 100)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 100, replace=TRUE)
film_id <- 1:100
cf <- read.csv("csv\\cliente\\cf.csv")
cliente_cf <- cf$cf
df_noleggio <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)
print("noleggi creati")

#Creo variabilità nei dati di noleggio inserendo altre coppie
#noleggi 2021
data_inizio <- sample(seq(as.Date('2021/01/01'), as.Date('2021/12/30'), by="day"), 10)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 10, replace=TRUE)
film_id <- 75:84
cliente_cf <- tail(cf$cf, 10)
df_noleggio2 <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)

data_inizio <- sample(seq(as.Date('2021/01/01'), as.Date('2021/06/30'), by="day"), 20)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 20, replace=TRUE)
film_id <- 20:39
cliente_cf <- head(cf$cf, 20)
df_noleggio3 <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)

data_inizio <- sample(seq(as.Date('2021/06/01'), as.Date('2021/12/30'), by="day"), 20)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 20, replace=TRUE)
film_id <- 40:59
cliente_cf <- head(cf$cf, 20)
df_noleggio4 <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)

data_inizio <- sample(seq(as.Date('2021/01/01'), as.Date('2021/06/30'), by="day"), 40)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 40, replace=TRUE)
film_id <- 40:79
cliente_cf <- tail(cf$cf, 40)
df_noleggio5 <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)

data_inizio <- sample(seq(as.Date('2021/01/01'), as.Date('2021/12/30'), by="day"), 30)
data_fine <- as.Date(data_inizio) +4
progressivo_dvd <- sample(1:10, 30, replace=TRUE)
film_id <- 25:54
cliente_cf <- head(cf$cf, 30)
df_noleggio6 <- data.frame(data_inizio, progressivo_dvd, film_id, cliente_cf, data_fine)

print("<<Fine creazione dei data frame>>")

dbWriteTable(con, name="film", df_film, append=T, row.name=F)
dbWriteTable(con, name="cliente", df_clienti, append=T, row.name=F)
dbWriteTable(con, name="casa_di_produzione", df_cdp, append=T, row.name=F)
dbWriteTable(con, name="produce", df_produce, append=T, row.name=F)
dbWriteTable(con, name="produce", df_produce_western, append=T, row.name=F)
dbWriteTable(con, name="attore", df_attore, append=T, row.name=F)
dbWriteTable(con, name="compare_in", df_compare_in, append=T, row.name=F)
dbWriteTable(con, name="compare_in", df_compare_in_travolta, append=T, row.name=F)
dbWriteTable(con, name="dvd", df_dvd, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio2, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio3, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio4, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio5, append=T, row.name=F)
dbWriteTable(con, name="noleggio", df_noleggio6, append=T, row.name=F)

dbDisconnect(con)

print("Scritture eseguite con successo")
