ActionController::Routing::Routes.draw do |map|
  map.resource :session
  map.resources :iterations

  map.resource :organisation do |organisation|
    organisation.resources :members, :controller => 'organisation_members'
  end

  map.resources :stories, :except => :index
  map.resources :projects do |project|
    project.resources :iterations do |iteration|
      iteration.resources :stories
    end
    project.resources(:stories, 
                      :member => {
                        :estimate => :get
                      },
                      :collection => { 
                        :backlog => :get,
                        :finished => :get 
                      }) do |story|
      story.resources :acceptance_criteria
    end
  end

  map.resources :users do |user|
    user.resource :verification, :controller => 'user_verifications', :only => [:new]
    user.resource :acknowledgement, :controller => 'user_acknowledgements'
  end
  map.verification '/users/:user_id/verification',
    :controller => 'user_verifications', :action => 'create'

  map.resources :iterations do |iteration|
    iteration.resource :burndown
    iteration.resource :active_iteration
  end

  map.root :controller => 'home', :action => 'show'
end
