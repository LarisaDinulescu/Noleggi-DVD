print("Buongiorno, le diamo il benvenuto nel progetto15")

#richiesta dati del db
if( !file.exists("csv\\credenziali\\postgres.csv") ){
	print("Prima di cominciare le chiederemo i dati di accesso al suo PostgreSQL che permetteranno allo script di accedere al database durante le sue funzioni")
	user_name <- readline("Nome utente di postgres: ")
	psw <- readline("Password dell'utente: ")
	credenziali <- data.frame( user_name, psw )
	write.csv( credenziali, "csv\\credenziali\\postgres.csv" )
}

print("Prima di eseguire questo script è necessario: ")
print("1) aver creato il database tramite crea_db.sql!")
print("2) aver impostato la working directory sulla directory in cui si trova questo file!")
print("3) aver installato install.packages('RPostgreSQL')")
print("da questo script è possibile eseguire il popolamento del database ed la creazione dei grafici riportati nella relazione")

risposta <- toupper(readline("Vuoi eseguire il popolamento del database? (si|no) "))
if( risposta=="SI" | risposta=="S" | risposta=="YES" | risposta=="Y"){
	source("R\\popola_db.R")
}
risposta <- toupper(readline("Vuoi creare i grafici? (si|no) "))
if( risposta=="SI" | risposta=="S" | risposta=="YES" | risposta=="Y"){
	source("R\\grafici.R")
}

print("Arrivederci")
