class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  phony_normalize :phone_number, default_country_code: 'US'

  validates :phone_number, phony_plausible: {
    ignore_record_country_code: true,
    ignore_record_country_number: true
  }
  has_many :tasks
end
