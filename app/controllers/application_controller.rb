class ApplicationController < ActionController::Base
  before_action :auto_sign_in_dev

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

  def auto_sign_in_dev
    return unless Rails.env.development?
    return if user_signed_in?

    user = User.find_or_create_by!(email: "dev@example.com") do |record|
      record.password = "password"
      record.password_confirmation = "password"
    end
    sign_in(user)
  end
end
