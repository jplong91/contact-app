require "unirest"

system "clear"

while true
  puts "\nPlease enter either: 'eric', 'megan', 'scott', or 'everyone' (or 'q' to quit): "
  input_name = gets.chomp

  if input_name == "q"
    puts "Goodbye"
    break
  elsif input_name == "eric" or input_name == "megan" or input_name == "scott"
    response = Unirest.get("http://localhost:3000/#{input_name}")
    contact = response.body
    puts contact["first_name"]
    puts contact["last_name"]
    puts contact["email"]
    puts contact["phone_number"]
  elsif input_name == "everyone"
    response = Unirest.get("http://localhost:3000/#{input_name}")
    contacts = response.body
    contacts.each do |indiv|
      puts
      puts indiv["first_name"]
      puts indiv["last_name"]
      puts indiv["email"]
      puts indiv["phone_number"]
    end
  else
    puts "Please try again"
  end

end