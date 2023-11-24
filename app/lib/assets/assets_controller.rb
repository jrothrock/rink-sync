class AssetsController < ApplicationController
  # Skip CSRF protection for a specific action
  skip_forgery_protection

  # A hacky way of getting the local modular javascript files to load without
  # utilizing something like the asset pipeline or webpack.
  def javascript
    path = Dir.glob(
      File.join(
        Rails.root.join("app", "lib", "components", params[:module], "views"),
        '**',
        "#{params[:file]}.js"
      ),
      File::FNM_CASEFOLD).first
  
    content = File.read(Rails.root.join(path))
    render js: content, content_type: 'application/javascript'
  end
end
