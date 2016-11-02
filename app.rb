require_relative "./app_dependencies"

class App < Sinatra::Base

  post "/users" do
    content_type("application/json")
    request_body = request.body.read
    user_info = JSON.parse(request_body)
    user = User.new(user_info)
    if user.save
      status 201
      user.to_json
    else
      status 422
      {errors: {full_messages: user.errors.full_messages}}.to_json
    end
  end

  delete "/users/:id" do
    user = User.find_by(id: params["id"])
    if user
      user.delete
    else
      status 404
      {message: "User with id ##{params["id"]} does not exist"}.to_json
    end
  end

  get "/visits" do
    content_type("application/json")
    User.all.sum("total_site_visits").to_json
  end

  get "/users" do
    content_type("application/json")
    User.all.to_json
  end

  get "/users/most_recent" do
    content_type("application/json")
    {last_date: User.maximum("last_logged_on")}.to_json
  end

  get "/users/joined_earliest" do
    content_type("application/json")
    {first_date: User.minimum("joined_on")}.to_json
  end

end
