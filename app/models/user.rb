class User < ActiveRecord::Base
    has_secure_password
    has_many :rsvps
    has_many :meetups, through: :rsvps
end