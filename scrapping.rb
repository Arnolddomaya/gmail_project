require "google_drive"
#se sert du programme de scraping de mairie
require_relative "new_route_mairie"
require'json'


session = GoogleDrive::Session.from_config("config.json")
#on peut changer la clé par la clé d'une nouvelle feuille de calcul
ws = session.spreadsheet_by_key("1F83fKNXujPd3mpfK2iq7Iz4ARlAk5D9uRfIjESL9v_w").worksheets[0]


#recupère les données sur les mairies provenant de new_route_mairie
def datas()
  perform().compact
end

i = 1
#on fait une boucle sur chaque hash de l'array revoyé par la fonction datas()
#à chaque ligne du googleSheet,
#on met le nom de la commune à la 1ère colonne
#et l'adresse mail de la mairie de la commune à la 2eme colonne
datas.each do |mairie|
  ws[i,1]= mairie[:name]
  ws[i,2] = mairie[:email]
  i+=1
  puts "%2s mails de mairies ajoutés" % (i-1)
end
ws.save
ws.reload
