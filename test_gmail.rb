require 'gmail'



Gmail.connect("thp.gironde@gmail.com", "piarsimje"){|gmail|

  email = gmail.compose do
    to "domaya_arnold@yahoo.fr"
    subject "Having fun in Puerto Rico!"
    body "Spent the day on the road..."
    add_file "lune.jpeg"

  end
  email.deliver!
  p "mail sent"
}
