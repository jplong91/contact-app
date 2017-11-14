class ContactsController < ApplicationController
  def eric
    contact = Contact.first
    render json: contact
  end

  def megan
    contact = Contact.second
    render json: contact
  end

  def scott
    contact = Contact.third
    render json: contact
  end
  def everyone
    contacts = Contact.all
    render json: contacts
  end
end