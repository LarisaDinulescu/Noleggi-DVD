#introduzione
print("Generazione dei grafici:")
print("digire: ")
print("1) 'g1' per il grafico dell'andamento dei noleggi 2021")
print("2) 'g2' per il grafico dei noleggi annuali 20/21")
print("3) 'g3' per il grafico dei generi degli attori protagonisti")
print("4) 'exit' per terminare")
i <- FALSE

#loop di smistamento
while( i == FALSE ){
	risposta <- toupper(readline("Grafico da riprodurre: "))
	if( risposta == "G1" ){
		source("R\\grafico_linee.R")
	}else if( risposta == "G3" ){
		source("R\\grafico_barre_sovrapposte.R")
	}else if( risposta == "G2" ){
		source("R\\grafico_barre_raggruppate.R")
	}else if( risposta == "EXIT" ){
		i = TRUE
	}
}
