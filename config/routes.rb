Rails.application.routes.draw do

  root 'users#welcome'
  
  #Yin Yin Aye 
  get '/workspacecreate',    to: 'users#workspacecreate'
  get '/managemember',    to: 'users#managemember'
  get '/home',    to: 'users#home'
  post '/home',    to: 'users#home'
  get  '/welcome',    to: 'users#welcome'
  get  '/memberlist1',    to: 'users#memberlist1'
  get  '/addmember',    to: 'users#addmember'
  get  '/memberadd',    to: 'users#add'
  get  '/remove',    to: 'users#remove'
  delete  '/remove',    to: 'users#remove'
  get  '/admin',    to: 'users#admin'
  patch  '/admin',    to: 'users#admin' 
  
  #Thu Zin Tun
  get  '/invitesuccess',    to: 'users#invitesuccess'
  get  '/memberinvite',    to: 'users#memberinvite' 
  get 'sessions/new'
  get  '/signup',  to: 'muser#new'
  get  '/show',  to: 'muser#show'
  post  '/create',  to: 'muser#create'
  get  '/workspacecreate',  to: 'muser#workspacecreate' 
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy' 
  get  '/searchworkspace',    to: 'users#searchworkspace' 
  post  '/searchworkspace',    to: 'muser#search' 
  
  #Aye Aye Mu
  #get  '/searchworkspace',    to: 'users#searchworkspace'
  #get  '/newworkspace',    to: 'users#newworkspace'
  #get  '/channelcreate',    to: 'users#channelcreate'
  #post  '/channelcreate',    to: 'users#channelcreate'
  get  '/member',    to: 'users#member'

  #KMMG
  get '/newworkspace', to: 'sessions#newworkspace'
  post '/newworkspace', to: 'sessions#newworkspace'
  post  '/channelcreate',    to: 'sessions#channelcreate'
  get  '/channelcreate',    to: 'sessions#channelcreate'

  #chat
  #cna
  get '/channelchat',    to: 'users#channel_chat'
  post '/channelchat',    to: 'users#channel_chat'
  get '/dirchat',    to: 'users#dirchat'
  post '/dirchat',    to: 'users#dirchat'
  get '/msgsend',    to: 'users#msgsend'
  post '/msgsend',    to: 'users#msgsend'
  get '/dirmsgsend',    to: 'users#dirmsgsend'
  post '/dirmsgsend',    to: 'users#dirmsgsend'



  resources :workspaces
  resources :m_users
  resources :account_activations, only: [:edit]
  resources :t_channel_msg,          only: [:msgsend, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
