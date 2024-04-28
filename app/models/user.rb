# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :timesheets
  has_one :user_configuration

  def setup_complete?
    user_configuration.present? && user_configuration.setup_complete?
  end
end
