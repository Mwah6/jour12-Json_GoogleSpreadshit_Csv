require 'nokogiri'
require 'open-uri'

# Obtention de la liste des villes
def get_city
  city_array = []
  Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html")).css("a.lientxt").each do |city|
    city_array << city.text
  end
  print city_array
  return city_array

end

# Obtention des urls par la liste des villes
def get_townhall_urls (city_array)
  city_townhall_urls = city_array.map do |ville| #création des liens html
    "http://annuaire-des-mairies.com/95/#{ville.downcase.gsub(" ", "-")}.html"
  end
  puts city_townhall_urls
  return city_townhall_urls
end

# Obtention des adresse email par les urls des mairies
def get_townhall_email(townhall_url)
  townhall_email_array= []
  townhall_url.each do |url|
    townhall_email_array <<  Nokogiri::HTML(open(url)).css("td")[7].text
  end
  print townhall_email_array
  return townhall_email_array
end

# Mise en forme
def formulemagique ( townhall_email_array, city_array)
  final_array = []
  for n in (0..city_array.size-1) do
    final_array << { city_array[n] => townhall_email_array[n]}
  end
  print final_array
  return final_array
end

# get_city
# get_townhall_email (get_townhall_urls (get_city))
# get_townhall_email (get_townhall_urls (get_city))

def perform
  formulemagique (get_townhall_email (get_townhall_urls (get_city))),get_city
end

perform
