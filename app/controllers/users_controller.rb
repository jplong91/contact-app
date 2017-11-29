class UsersController < ApplicationController

  def create
    user = User.new(
      name: params[:name],
      email: params[:email],
      password: pararms[:password],
      password_confirmation: params[:password_confirmation]
    )
    if user.save
      render json: {status: "User Created"}, status: :created
    else
      render json: {errors: contact.errors.full_messages}, status: :bad_request
    end
  end
end
