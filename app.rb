require_relative "./app_dependencies"

class App < Sinatra::Base

  post "/users" do
    request_body = request.body.read
    content_type("application/json")
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
    User.all.sum("total_site_visits").to_json
  end

end
