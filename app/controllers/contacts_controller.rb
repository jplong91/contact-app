class ContactsController < ApplicationController
  before_action :authenticate_user

  def index
    contacts = Contact.all
    if params[:first_name_search]
      contacts = contacts.where("first_name ILIKE ?", "%#{params[:first_name_search]}%")
    end
    render json: contacts.as_json
  end

  def show
    contact_id = params[:id]
    contact = Contact.find_by(id: contact_id)
    render json: contact.as_json
  end

  def create
    contact = Contact.new(
      first_name: params[:first_name],
      last_name: params[:last_name],
      mid_name: params[:mid_name],
      email: params[:email],
      phone_number: params[:phone_number],
      bio: params[:bio],
      user_id: current_user.id
    )
    if contact.save
      render json: contact.as_json
    else 
      render json: {errors: contact.errors.full_messages}, status: :bad_request
    end
  end

  def update
    contact_id = params["id"]
    contact = Contact.find_by(id: contact_id)
    contact.first_name = params[:first_name] || contact.first_name
    contact.last_name = params[:last_name] || contact.last_name
    contact.mid_name = params[:mid_name] || contact.mid_name
    contact.email = params[:email] || contact.email
    contact.phone_number = params[:phone_number] || contact.phone_number
    contact.bio = params[:bio] || contact.bio
    if contact.save
      render json: contact.as_json
    else 
      render json: {errors: contact.errors.full_messages}, status: :bad_request
    end
  end

  def destroy
    contact_id = params[:id]
    contact = Contact.find_by(id: contact_id)
    contact.destroy
    render json: "Contact eliminated"
  end

end