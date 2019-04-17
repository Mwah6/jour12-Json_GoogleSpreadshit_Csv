
require 'open-uri'
require 'json'
require 'google_drive'
require 'csv'

class Scrapper

  def initialize
    @final_array = perform
  end

  def save_as_csv
    File.open("db/emails.csv","w") do |f|
      f.write(@final_array.to_a.map { |c| c.to_a.join(",") }.join("\n"))
    end
  end

  def save_as_JSON
    require 'json'
    File.open("db/emails.json","w") do |f|
      f.write(@final_array.to_json)
    end
  end

  def save_as_spreadsheet
    session = GoogleDrive::Session.from_config("config.json")

    # First worksheet of
    # https://docs.google.com/spreadsheet/ccc?key=pz7XtlQC-PYx-jrVMJErTcg
    # Or https://docs.google.com/a/someone.com/spreadsheets/d/pz7XtlQC-PYx-jrVMJErTcg/edit?usp=drive_web
    ws = session.spreadsheet_by_key("12S-e2ejKjnMPls1St8cp5d9ThrsgwZ0c7StHdToC-hw").worksheets[0]
    # ws = https://docs.google.com/spreadsheets/d/1pIIldZWr-p5XheTcDcbd3E-wTbHdUzBuLA3gvcH3UPc
    a=1
    # ws[1, 1] = city
    # ws[1, 2] = email
    @final_array.each  {|row|
      row.each {|city, email|
        ws[a, 1] = city
        ws[a, 2] = email
        a+=1
      }
    }

    ws.save
    p ws.rows
    ws.reload
  end


  # # # Gets content of A2 cell.
  # # p ws[2, 1]  #==> "hoge"
  # #
  # # # Changes content of cells.
  # # # Changes are not sent to the server until you call ws.save().
  # # ws[2, 1] = "foo"
  # # ws[2, 2] = "bar"
  # # ws.save
  # #
  # # # Dumps all cells.
  # # (1..ws.num_rows).each do |row|
  # #   (1..ws.num_cols).each do |col|
  # #     p ws[row, col]
  # #   end
  # # end
  #
  # # Yet another way to do so.
  # p ws.rows  #==> [["fuga", ""], ["foo", "bar]]
  #
  # # Reloads the worksheet to get changes by other clients.
  # ws.reload



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
    cities_array = get_city
    formulemagique (get_townhall_email (get_townhall_urls (cities_array))),cities_array
  end
end
