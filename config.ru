require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

require_relative 'app/controllers/application_controller.rb'

use Rack::MethodOverride

run ApplicationController
use UsersController
use MeetupsController

