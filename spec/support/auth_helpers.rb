module AuthHelpers
  def access_token_for(user)
    application = Doorkeeper::Application.find_or_create_by!(name: "Test Application") do |app|
      app.redirect_uri = "https://example.com"
      app.uid = SecureRandom.hex(16)
      app.secret = SecureRandom.hex(32)
    end

    Doorkeeper::AccessToken.create!(
      resource_owner_id: user.id,
      application_id: application.id,
      scopes: "",
      expires_in: 2.hours
    ).token
  end

  def auth_headers(user)
    { "Authorization" => "Bearer #{access_token_for(user)}" }
  end
end
