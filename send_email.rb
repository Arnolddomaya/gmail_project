require "google_drive"
require 'json'
require 'gmail'

puts "veuillez entrez votre adresse mail"
adress_mail = gets.chomp()
puts "veuillez entrez votre mot de passe"
mots_de_passe = gets.chomp()

#veuillez mettre votre fichier "config.json" dans le même dossier"
session = GoogleDrive::Session.from_config("config.json")
#on se connecte sur la feuille qui contient les données sur les mairies
@ws = session.spreadsheet_by_key("1J5Ajhk5-g6TAKFw8g4hsMhv92aDp1_SNCmKbgyghjn8").worksheets[0]

@gmail = Gmail.connect(adress_mail,mots_de_passe)#penser à enlever les ids



#cette fonction recois un array de 2 élements (nom_de_commune, email)
def send_email_to_line(array)
  townhall_name= array[0]
  townhall_email = array[1]

  #si l'adresse mail existe
  unless townhall_email == ""
    @gmail.deliver do
      to townhall_email
      subject "The hacking project!"
      text_part do
        body
      end
      html_part do
        content_type 'text/html; charset=UTF-8'
        body get_the_email_html(townhall_name)
      end
    end
    p "mail bien envoyé à #{townhall_name} à l'adresse #{townhall_email}"
  end




end

#permet un bon formatage du texte dans le mail (html)
#prend entré le nom de la commune et le prenom de l'utilisateur(optionnel)
def get_the_email_html(townhall_name, prenom= "Cedric")
  "<p style='padding:50px; text-align:justify' >Bonjour,<br/><br/>Je m'appelle #{prenom}, je suis élève à une formation de programmation web gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle <strong><a style='text-decoration:none' href='http://thehackingproject.org'/ >The Hacking Project</a></strong>. Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.<br/><br/>Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à <strong>#{townhall_name}</strong>, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec <strong>#{townhall_name}</strong> !<br/><br/> </strong><strong>Charles</strong>, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80</p>"
end



#parcours toutes les linges du googleSheet
#chaque ligne est sous forme d'un array de deux élements
def go_through_all_the_lines()
  #enlève les cases vide de l'array
  array = @ws.rows.compact.uniq
  array.each{|row|  send_email_to_line(row) }
end

#l'exécution prend un peu de temps
go_through_all_the_lines()



@gmail.logout
