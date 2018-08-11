module Authenticable
  extend ActiveSupport::Concern

  class InvalidTokenError < StandardError; end

  included do
    has_secure_password

    def jwt_token
      JWT.encode({ resource_id: id, exp: 24.hours.from_now.to_i },
                 Rails.application.credentials.jwt[:key])
    end

    def self.login(email:, password:)
      resource = find_by(email: email)
      return resource.authenticate(password) || nil if resource
    end

    def self.get_by_token(token)
      body = JWT.decode(token, Rails.application.credentials.jwt[:key])
      find(body[0]['resource_id'])
    rescue StandardError => e
      raise InvalidTokenError, e
    end
  end
end
