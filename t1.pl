%% este exemplo busca os personagens da Turma da Monica na base de dados dbpedia
:- data_source(
   dbpedia_filmes,
   sparql("PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX dbo: <http://dbpedia.org/ontology/>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX dboW: <http://dbpedia.org/ontology/Work/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT DISTINCT ?title ?minutos ?orcamento ?nomeDir
WHERE { ?sujeito a  dbo:TelevisionShow ;
  rdfs:label ?title;
  dboW:runtime ?tempo;
            dbo:network ?produtora;
dbo:director ?diretor
  OPTIONAL {?sujeito dbo:budget ?orcamento}
 
  ?produtora rdfs:label ?prodname.
  ?diretor   rdfs:label ?nomeDir.
 
  BIND (xsd:float(?tempo) as ?minutos)
 
  FILTER (lang(?title) = 'en')
  FILTER (lang(?prodname) = 'en')
  FILTER (lang(?nomeDir) = 'en')
}
ORDER BY DESC(?minutos) ?title
   ",
   [ endpoint('https://dbpedia.org/sparql')])  ).

% este predicado associa as "colunas" de uma base de dados com variáveis Prolog.
filmes(Nome, Duracao, Dir, Orc) :- dbpedia_filmes{title:Nome, minutos:Duracao, nomeDir:Dir, orcamento:Orc}.

