require "unirest"
require "tty-prompt"
prompt = TTY::Prompt.new

system "clear"

while true

  mm_options = {
    "View a Contact" => 2,
    "Show all Contacts" => 3,
    "Add new Contact" => 4,
    "Update a Contact's Info" => 6,
    "Delete a Contact" => 5,
    "Quit" => 1
  }

  mm_input = prompt.select("MAIN MENU", mm_options)

  if mm_input == 1
    puts "Goodbye"
    break

  elsif mm_input == 2
    input_id = gets.chomp
    response = Unirest.get("http://localhost:3000/contacts/#{input_id}")
    contact = response.body
    puts contact["first_name"]
    puts contact["last_name"]
    puts contact["email"]
    puts contact["phone_number"]

  elsif mm_input == 3
    response = Unirest.get("http://localhost:3000/contacts")
    contacts = response.body
    contacts.each do |indiv|
      puts
      puts indiv["first_name"]
      puts indiv["last_name"]
      puts indiv["email"]
      puts indiv["phone_number"]
    end

  elsif mm_input == 4
    params = {}
    print "Please enter first name: "
    params[:first_name] = gets.chomp
    print "Please enter last name: "
    params[:last_name] = gets.chomp
    print "Please enter email: "
    params[:email] = gets.chomp
    print "Please enter phone number: "
    params[:phone_number] = gets.chomp

    response = Unirest.post("http://localhost:3000/contacts", parameters: params)
    contact = response.body

    response = Unirest.get("http://localhost:3000/contacts/#{contact["id"]}")
    contact = response.body
    p contact

  elsif mm_input == 6
    prompt_contacts = {}
    response = Unirest.get("http://localhost:3000/contacts")
    contacts = response.body
    contacts.each do |indiv|
      prompt_contacts[indiv["first_name"]] = indiv["id"]
    end
    contact_input = prompt.select("SELECT A CONTACT TO UPDATE", prompt_contacts)

    params = {}
    print "Update first name: "
    params[:first_name] = gets.chomp
    print "Update last name: "
    params[:last_name] = gets.chomp
    print "Update email: "
    params[:email] = gets.chomp
    print "Update phone number: "
    params[:phone_number] = gets.chomp

    response = Unirest.patch("http://localhost:3000/contacts/#{contact_input}", parameters: params)
    contact = response.body
    p contact

  elsif mm_input == 5
    prompt_contacts = {}
    response = Unirest.get("http://localhost:3000/contacts")
    contacts = response.body
    contacts.each do |indiv|
      prompt_contacts[indiv["first_name"]] = indiv["id"]
    end
    contact_input = prompt.select("SELECT A CONTACT TO DELETE", prompt_contacts)

    response = Unirest.delete("http://localhost:3000/contacts/#{contact_input}")
    puts "Person Eliminated"
    
  else
    puts "Please try again"
  end

end