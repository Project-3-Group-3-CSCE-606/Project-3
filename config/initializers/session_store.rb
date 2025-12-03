Rails.application.config.session_store :cookie_store,
  key: "_project3_session",
  same_site: :none,
  secure: Rails.env.production?
