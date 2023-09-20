%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trabalho 01 - Fazendo consultas no banco de dados dbpedia
% Autor : Elder Ribeiro Storck, 	
% git	: https://github.com/elder-storck
% LP 	: Prolog , Programação Lógica.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- data_source(
   dbpedia_televisionShow,
   sparql("PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
			PREFIX dbo: <http://dbpedia.org/ontology/>
            PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
			PREFIX dboW: <http://dbpedia.org/ontology/Work/>
			PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT DISTINCT ?db_titulo ?db_ator ?db_produtora ?db_diretor ?db_dataNascAtor
WHERE { ?sujeito a  dbo:TelevisionShow ;
					rdfs:label ?db_titulo;
     				dboW:runtime ?tempo;
         			dbo:network ?produtora;
            		dbo:director ?diretor;
              		dbo:starring ?estrelas
  	
  		OPTIONAL {?sujeito dbo:budget ?orcamento}
 
  		?produtora rdfs:label ?db_produtora.
  		?diretor   rdfs:label ?db_diretor.
  		?estrelas rdfs:label ?db_ator.
  		?estrelas dbo:birthDate ?db_dataNascAtor.
 
  		BIND (xsd:float(?tempo) as ?db_duracao)
 
  		FILTER (lang(?db_ator) = 'en')
  		FILTER (lang(?db_titulo) = 'en')
  		FILTER (lang(?db_produtora) = 'en')
  		FILTER (lang(?db_diretor) = 'en')
}", [ endpoint('https://dbpedia.org/sparql')])
).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FATOS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Tuplas com informações dos Atores [nome, Data de Nascimento]
name_and_birthDate_Actor(Name ,Birth_date) :- distinct([Name, Birth_date], (dbpedia_televisionShow{db_ator:Name, db_dataNascAtor:Birth_date})).

%Tuplas com informações do elenco e da produtora [nome, Produtora]
producerCast(Name, Network) :- distinct([Name, Network], (dbpedia_televisionShow{db_ator:Name, db_produtora:Network})).

%Tuplas com informações do elenco e do programa de televisao [nome, programa de televisao]
televisionShow_Cast(Name, Title) :- distinct([Name, Title], (dbpedia_televisionShow{db_ator:Name, db_titulo:Title})).

%Tuplas com informações do elenco e da produtora [nome, Produtora]
director_and_producer(Dir, Network) :- distinct([Dir, Network], (dbpedia_televisionShow{db_diretor:Dir, db_produtora:Network})).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% REGRAS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Verifica quais artistas distintos já trabalharam na mesma Produtora
coworker_Producer(Actor1, Actor2) :- producerCast(Actor1, X), producerCast(Actor2, X), dif(Actor1, Actor2).

%Verifica quais artistas distintos já trabalharam no mesmo Programa de Tv
coworker_televisionShow(Actor3, Actor4) :- televisionShow_Cast(Actor3, X), televisionShow_Cast(Actor4, X), dif(Actor3, Actor4).

%Verifica quais diretores distintos trabalharam na mesma Produtora
coworker_dir_Prod(Director1, Director2) :- director_and_producer(Director1, P), director_and_producer(Director2, P), dif(Director1, Director2).

%verifica se um determinado artista nasceu antes de um Ano
dateOfBirth_before(Actor, Year) :- name_and_birthDate_Actor(Actor, date(A, B, C)), A < Year, B > 0, C>0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Exemplos de Consulta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Verifica quais artistas distintos já trabalharam na mesma Produtora
%false 	coworker_Producer("Pilar Pilapil","Brian /keith")
%true	coworker_Producer("Nick Palatas","Hayley Kiyoko")

%verifica quais artistas distintos já trabalharam no mesmo programa de televisão
%false 	coworker_televisionShow("Pilar Pilapil","Brian Keith")
%true 	coworker_televisionShow("Nick Palatas", "Hayley Kiyoko")

%Verifica quais diretores distintos trabalharam na mesma Produtora
%true 	coworker_dir_Prod("David Mickey Evans","Brian Levant")
%false 	coworker_dir_Prod("David Lynch","Donald Wrye")

%verifica se um determinado artista nasceu antes de um Ano
%true 	dateOfBirth_before("Crispin Glover",1965)
%false 	dateOfBirth_before("Crispin Glover",1964)

