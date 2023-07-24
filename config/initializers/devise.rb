# frozen_string_literal: true

Devise.secret_key = SecureRandom.hex(50).inspect
Devise.setup do |config|
  config.parent_controller = 'StoreDeviseController'
  config.mailer = 'Devise::Mailer'
  config.mailer_sender = 'andregonza46@hotmail.com'
end
