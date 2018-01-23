require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'watir'

### Important d'être connecter à internet pour que tout marhce :)

#on recupère l'adresse mail de la mairie grace à son site sur l'annuaire
#j'ai un peu bidouillé le selecteur css pour que ça tombe sur la bonne ligne :)
def get_the_email_of_a_townhal_from_its_webpage(url_page)
  page = Nokogiri::HTML(open(url_page))
  mail = page.css("td.style27 p.Style22 font")[6]
  mail.text
end



#on fait l'exo sur le departement de la gironde
#la liste des communes s'étend sur 3 pages
def get_all_the_url()
  res =[]
  #3 pages pour le departement de la gironde
  #on rentre manuellement l'url des 3 pages
  pages = ["http://www.annuaire-des-mairies.com/gironde.html",
    "http://www.annuaire-des-mairies.com/gironde-2.html",
    "http://www.annuaire-des-mairies.com/gironde-3.html"]

  #on fait une boucle sur les 3 pages
  pages.each do |page|
    page_annuaire = Nokogiri::HTML(open(page))
    pages_mairies = page_annuaire.css("table tr td table tr td table tr td table tr td p a.lientxt")
    pages_mairies.each{|mairie|  mairie["href"]= right_url(mairie["href"])}
    #on ajoute les url obtenus au résultat
    res = res+pages_mairies
  end
  res
end




# l'url recupéré est sous cette forme "./95/villers-en-arthies.html"
#on la formate dans cette fonction pourqu'elle est la bonne forme "http://annuaire-des-mairies.com/95/villers-en-arthies.html"
#split('') pour la transformer en array; drop(1) enlève le premier element; *'' regoupe le tout et tranforme en chaine de carractère
def right_url(url)
  url ='http://annuaire-des-mairies.com' + url.split('').drop(1)*''
end

#retourne un array de hash avec le nom de la mairie et son adresse mail
def perform()
  res = []
  get_all_the_url().each do |mairie_url|
    nom = mairie_url.text
    email = get_the_email_of_a_townhal_from_its_webpage(mairie_url["href"])
    res << {:name =>nom , :email=>email }
  end
  res
end



