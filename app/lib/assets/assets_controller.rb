
class AssetsController < ApplicationController
  # Skip CSRF protection for a specific action
  skip_forgery_protection

  def javascript
    path = File.join('app', 'lib', params[:module], "#{params[:file]}.js")
    content = File.read(Rails.root.join(path))
    render js: content, content_type: 'application/javascript'
  end
end