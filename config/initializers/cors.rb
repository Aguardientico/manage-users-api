Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    resource '*',
             headers: %w[Origin
                         X-Requested-With
                         Content-Type
                         Accept
                         Authorization
                         X-Total-Pages],
             methods: %i[get post put patch delete options],
             expose: ['X-Total-Pages']
  end
end
