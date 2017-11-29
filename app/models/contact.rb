class Contact < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true
  validates :email, uniqueness: true

  belongs_to :user

  def friendly_updated_at
    updated_at.strftime("%B %e, %Y")
  end

  def full_name
    "#{first_name} #{mid_name} #{last_name}"
  end

  def japan_phone_number
    "(+81) #{phone_number}"
  end

  def as_json
    {
      id: self.id,
      first_name: self.first_name,
      last_name: self.last_name,
      mid_name: self.mid_name,
      full_name: self.full_name,
      email: self.email,
      phone_number: self.phone_number,
      bio: self.bio,
      japan_phone_number: self.japan_phone_number,
      friendly_updated_at: self.friendly_updated_at
    }
  end
end
