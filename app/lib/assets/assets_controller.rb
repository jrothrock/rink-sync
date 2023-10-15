class AssetsController < ApplicationController
  # Skip CSRF protection for a specific action
  skip_forgery_protection

  # A hacky way of getting the local modular javascript files to load without
  # utilizing something like the asset pipeline or webpack.
  def javascript
    path = File.join('app', 'lib', params[:module], "#{params[:file]}.js")
    content = File.read(Rails.root.join(path))
    render js: content, content_type: 'application/javascript'
  end
end
