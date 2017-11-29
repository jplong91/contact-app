require "unirest"
require "tty-prompt"
prompt = TTY::Prompt.new

system "clear"
base_url = "http://localhost:3000/"

while true

  mm_options = {
    "View a Contact" => 2,
    "Show all Contacts" => 3,
    "Add new Contact" => 4,
    "Update a Contact's Info" => 6,
    "Delete a Contact" => 5,
    "User Signup" => 10,
    "User Login" => 11,
    "User Logout" => 12,
    "Quit" => 1
  }

  mm_input = prompt.select("\nMAIN MENU", mm_options)

  if mm_input == 1
    puts "Goodbye"
    break

  # User Signup
  elsif mm_input == 10
    params = {}
    print "Enter user name: "
    params[:name] = gets.chomp
    print "Enter email: "
    params[:email] = gets.chomp
    print "Enter password: "
    params[:password] = gets.chomp
    print "Confirm password: "
    params[:password_confirmation] = gets.chomp
    response = Unirest.post("http://localhost:3000/users", parameters: params)
    puts response.body

  # User Login
  elsif mm_input == 11
    params = {}
    print "Login email: "
    params[:email] = gets.chomp
    print "Password: "
    params[:password] = gets.chomp
    response = Unirest.post("http://localhost:3000/user_token", parameters: {auth: params})
    jwt = response.body["jwt"]
    p jwt
    Unirest.default_header("Authorization", "Bearer #{jwt}")

  # User Logout
  elsif mm_input == 12  
    jwt = ""
    Unirest.clear_default_headers()

  # Show Single Contact
  elsif mm_input == 2
    print "Please enter a contact ID: "
    input_id = gets.chomp
    response = Unirest.get("#{base_url}contacts/#{input_id}")
    contact = response.body
    puts contact["first_name"]
    puts contact["last_name"]
    puts contact["email"]
    puts contact["phone_number"]
    puts contact["bio"]

  # Show All Contacts
  elsif mm_input == 3
    ac_options = {
      "Show all contacts" => 1,
      "Search contact by first name" => 2
    }
    input_ac_option = prompt.select("\nALL CONTACTS MENU", ac_options)

    if input_ac_option == 1
      response = Unirest.get("#{base_url}contacts")
      contacts = response.body
      contacts.each do |indiv|
        puts
        puts indiv["first_name"]
        puts indiv["last_name"]
        puts indiv["email"]
        puts indiv["phone_number"]
      end
    elsif input_ac_option == 2
      print "Search by first name: "
      input_search_option = gets.chomp
      response = Unirest.get("#{base_url}contacts?first_name_search=#{input_search_option}")
      contacts = response.body
      puts contacts
    end

  # Add Contact
  elsif mm_input == 4
    params = {}
    print "Please enter first name: "
    params[:first_name] = gets.chomp
    print "Please enter last name: "
    params[:last_name] = gets.chomp
    print "Please enter middle name: "
    params[:mid_name] = gets.chomp
    print "Please enter email: "
    params[:email] = gets.chomp
    print "Please enter phone number: "
    params[:phone_number] = gets.chomp
    print "Please enter a contact bio: "
    params[:bio] = gets.chomp

    response = Unirest.post("#{base_url}contacts", parameters: params)
    contact = response.body
    if contact["errors"]
      puts "\nDID NOT SAVE. INVALID ENTRY"
      puts contact["errors"]
    else
      puts "\nSUCCESS"
      puts contact
    end

  # Update Contact
  elsif mm_input == 6
    prompt_contacts = {}
    response = Unirest.get("#{base_url}contacts")
    contacts = response.body
    contacts.each do |indiv|
      prompt_contacts[indiv["first_name"]] = indiv["id"]
    end
    contact_input = prompt.select("SELECT A CONTACT TO UPDATE. YOU NEED TO ENTER SOMETHING IN EVERY FIELD", prompt_contacts)

    params = {}
    print "Update first name: "
    params[:first_name] = gets.chomp
    print "Update last name: "
    params[:last_name] = gets.chomp
    print "Update middle name: "
    params[:mid_name] = gets.chomp
    print "Update email: "
    params[:email] = gets.chomp
    print "Update phone number: "
    params[:phone_number] = gets.chomp
    print "Update contact bio: "
    params[:bio] = gets.chomp

    params.delete_if { |_key, value| value.empty? }
    response = Unirest.patch("#{base_url}contacts/#{contact_input}", parameters: params)
    contact = response.body
    if contact["errors"]
      puts "\nDID NOT SAVE. INVALID ENTRY"
      puts contact["errors"]
    else
      puts "\nSUCCESS"
      puts contact
    end

  # Delete Contact
  elsif mm_input == 5
    prompt_contacts = {}
    response = Unirest.get("#{base_url}contacts")
    contacts = response.body
    contacts.each do |indiv|
      prompt_contacts[indiv["first_name"]] = indiv["id"]
    end
    contact_input = prompt.select("SELECT A CONTACT TO DELETE", prompt_contacts)

    response = Unirest.delete("#{base_url}contacts/#{contact_input}")
    puts "Person Eliminated"
    
  else
    puts "Please try again"
  end

end