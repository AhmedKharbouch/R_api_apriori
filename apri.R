# library(plumber)
# library(arules)

# Définition de l'API
#* @apiTitle API d'Apriori
#* @post /run_apriori
#* @param url URL du fichier CSV
#* @param cols Colonnes contenant les noms des articles
#* @param sep Caractère séparateur de colonnes
#* @param supp Valeur de support minimale
#* @param conf Valeur de confiance minimale
#* @serializer unboxedJSON
function(req, res) {
  library(arules)
  
  # Récupérer les paramètres de la requête
  url <- req$postBody$url
  cols <- req$postBody$cols
  sep <- req$postBody$sep
  supp <- req$postBody$supp
  conf <- req$postBody$conf
  
  # Télécharger le fichier CSV depuis l'URL
  csv_string <- readLines(url)
  
  # Convertir la chaîne de caractères en data frame
  data <- read.transactions(text = csv_string, rm.duplicates = FALSE, format = "single", cols = cols, sep = sep)
  
  # Prétraiter les données (par exemple, nettoyage, formatage, création de transactions)
  # ...
  
  # Exécuter l'algorithme Apriori
  rules <- apriori(data, parameter = list(supp = supp, conf = conf))
  
  # Convertir les règles en data frame
  rules_df <- as(rules, "data.frame")
  
  # Retourner le résultat en format JSON
  res$setHeader("Content-Type", "application/json")
  return(jsonlite::toJSON(rules_df))
}
