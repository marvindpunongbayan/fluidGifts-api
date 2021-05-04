Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql'
    #sroot to: redirect('/graphiql')
  end

  get "/reset_password" => "restrictions#reset_password", as: "reset_password"
  root to: 'graphql#execute'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
