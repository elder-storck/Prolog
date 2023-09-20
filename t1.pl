%% este exemplo busca os personagens da Turma da Monica na base de dados dbpedia
:- data_source(
   dbpedia_filmes,
   sparql("PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX dboW: <http://dbpedia.org/ontology/Work/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT DISTINCT ?db_titulo ?db_ator ?db_produtora ?db_diretor
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
 
  	BIND (xsd:float(?tempo) as ?db_duracao)
 
  	FILTER (lang(?db_ator) = 'en')
  	FILTER (lang(?db_titulo) = 'en')
  	FILTER (lang(?db_produtora) = 'en')
  	FILTER (lang(?db_diretor) = 'en')
}
ORDER BY DESC(?db_duracao) ?db_titulo
   ",
   [ endpoint('https://dbpedia.org/sparql')])  ).

% este predicado associa as "colunas" de uma base de dados com variáveis Prolog.
filmes(Nome, Duracao, Dir, Orc) :- dbpedia_filmes{title:Nome, minutos:Duracao, nomeDir:Dir, orcamento:Orc}.

