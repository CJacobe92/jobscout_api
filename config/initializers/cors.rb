Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:5173", "https://jobscout-fe.vercel.app", "https://jobscout-fe.onrender.com", "https://localhost:5173"

    resource "*",
      headers: :any,
      expose: [:uid, :authorization, :refresh_token, :client, :enabled, :otp_required, :otp_enabled, :role, :tenant_id],
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
end
