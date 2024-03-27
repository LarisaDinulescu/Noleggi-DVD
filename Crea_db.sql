/*1) creo il db*/
	CREATE DATABASE lab_basi;

/*2!) mi connetto al db appena creato*/
	\c lab_basi;

/*3) suddivido logicamente il db con lo schema "progetto15"*/
	CREATE SCHEMA progetto15;	

/*4!) imposto la search path sullo schema appena creato*/
	SET search_path to progetto15;

/*5) creo i domini dei dati*/
	CREATE DOMAIN dom_anno AS numeric(4,0) CONSTRAINT anno_min CHECK( value > 1850 );
	CREATE DOMAIN dom_positivo AS numeric(6,0) CONSTRAINT maggiore_di_zero CHECK( value > 0 ); 
	CREATE TYPE dom_generi AS ENUM ('Animazione', 'Avventura', 'Biografico', 
		'Commedia', 'Comico', 'Drammatico', 'Romantico', 'Sci-Fi & Fantasy', 
		'Giallo', 'Horror', 'Storico', 'Western'); /*12 generi*/

/*6) creazione delle tabelle:*/
	CREATE TABLE casa_di_produzione( 
		nome varchar(255) PRIMARY KEY, 
		amministratore_delegato varchar(75) NOT NULL, /*75 char, fonte "caratteristiche tecniche e parametri della tesera sanitaria" www.rgs.mef.gov.it*/  
		anno_di_fondazione dom_anno NOT NULL, 
		cap integer NOT NULL
	);


	CREATE TABLE film(
		id dom_positivo PRIMARY KEY,
		titolo varchar(255) NOT NULL,
		anno_di_produzione dom_anno NOT NULL,
		generi dom_generi NOT NULL,
		regista varchar(75) NOT NULL,
		descrizione varchar(1000) NOT NULL,
		/*vincoli di tabella*/
		CONSTRAINT film_unico UNIQUE( titolo, anno_di_produzione ) 
	);

	CREATE TABLE produce(
		nome_casa_di_produzione varchar(255),
		id_film dom_positivo,
		/*vincoli di tabella*/
		PRIMARY KEY( nome_casa_di_produzione, id_film ),
		FOREIGN KEY( nome_casa_di_produzione ) REFERENCES casa_di_produzione
			ON UPDATE CASCADE ON DELETE NO ACTION, 
		FOREIGN KEY( id_film ) REFERENCES film 
			ON UPDATE CASCADE ON DELETE CASCADE 
	);

	CREATE TABLE attore(
		nome varchar(75) PRIMARY KEY,
		data_di_nascita date,
		sesso varchar(1), /*metti un tipo ad hoc*/
		nazionalita varchar(255)
	);

	CREATE TABLE compare_in(
		nome_attore varchar(75),
		id_film dom_positivo,
		/*vincoli di tabella*/
		PRIMARY KEY( nome_attore, id_film ),
		FOREIGN KEY( nome_attore  ) REFERENCES attore
			ON UPDATE CASCADE ON DELETE CASCADE,
		FOREIGN KEY( id_film ) REFERENCES film 
			ON UPDATE CASCADE ON DELETE CASCADE
	);
		
	CREATE TABLE dvd(
		progressivo dom_positivo,
		id_film dom_positivo,
		numero_di_noleggi integer NOT NULL,
		/*vincoli di tabella*/
		PRIMARY KEY( progressivo, id_film ), 
		FOREIGN KEY( id_film ) REFERENCES film
			ON UPDATE CASCADE ON DELETE CASCADE 
	);

	CREATE TABLE cliente(
		cf varchar(16),
		nome varchar(35) NOT NULL, /*fonte tessera sanitaria*/
		cognome varchar(40) NOT NULL,
		telefono numeric( 10, 0 ) NOT NULL,
		data_di_nascita date NOT NULL,
		cap integer NOT NULL,
		e_mail varchar(255), 
		/*vincoli di tabella*/
		PRIMARY KEY( cf )
	);

	CREATE TABLE noleggio(
		data_inizio date, /*date in quanto mi basta sapere gg-mm-aaaa*/
		progressivo_dvd dom_positivo,
		film_id dom_positivo,
		cliente_cf varchar(16) NOT NULL, /*il cf ha lunghezza fissa a 16 caratteri, fonte AdE*/
		data_fine date, 
		consegna_fuori_tempo BOOLEAN DEFAULT FALSE, /*attributo aggiunto per garantire il vincolo di integrità che la durata del noleggio deve essere compresa tra 2 e 7 gg tramite trigger*/
		/*vincoli di tabella*/
		PRIMARY KEY( data_inizio, progressivo_dvd, film_id ),
		FOREIGN KEY( progressivo_dvd, film_id ) REFERENCES dvd
			ON UPDATE CASCADE ON DELETE CASCADE,
		FOREIGN KEY( cliente_cf ) REFERENCES cliente
			ON UPDATE CASCADE ON DELETE CASCADE 
	);

/*7) Creo i trigger*/
/*Trigger per l'incremento del numero dei noleggi del dvd una volta preso in prestito*/
CREATE OR REPLACE FUNCTION incremento() 
RETURNS TRIGGER AS $$
BEGIN
	UPDATE dvd SET numero_di_noleggi = numero_di_noleggi +1
		WHERE dvd.progressivo=new.progressivo_dvd AND dvd.id_film = new.film_id;
RETURN new;
	
END; $$ language plpgsql;


CREATE TRIGGER incremento_noleggi AFTER INSERT ON noleggio FOR EACH ROW EXECUTE PROCEDURE incremento();
	

/*Trigger per soddisfare il vincolo di integrità n°2
Nel momento della restituzione del noleggio controlla se è copreso tra 2 e 7, se non lo è imposta a true l'attributo consegna_fuori_tempo*/
CREATE OR REPLACE FUNCTION verifica_ritardo() 
RETURNS TRIGGER AS $$
BEGIN
	IF NEW.data_inizio + INTERVAL '7 days' < NEW.data_fine
	THEN
		NEW.consegna_fuori_tempo = TRUE;
		RETURN NEW;
	ELSE
		IF NEW.data_inizio + INTERVAL '2 days' > NEW.data_fine
		THEN
			NEW.consegna_fuori_tempo = TRUE;
			RETURN NEW;
		END IF;
	END IF;
	RETURN NEW;
END; $$ language plpgsql;

CREATE TRIGGER ritardo
    BEFORE UPDATE
    ON noleggio
    FOR EACH ROW
    EXECUTE PROCEDURE verifica_ritardo();
	
