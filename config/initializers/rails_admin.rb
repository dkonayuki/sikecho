RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)
  
  config.authorize_with :cancan
  config.current_user_method(&:current_user)

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
  
  # exclude these unnecessary model
  config.excluded_models = ["Education", "Impression", "Outline", "NotesSubject", "Period", "Register"]

  # choose what to display in user
  config.model 'User' do
    edit do
      field :username
      field :nickname
      field :email
      field :first_name
      field :first_name_kana
      field :first_name_kanji
      field :last_name
      field :last_name_kana
      field :last_name_kanji
      field :gender
      field :dob do
        date_format :default
      end
      field :status
      field :password
      field :sign_in_count do
        read_only true
      end
      field :created_at do
        read_only true
        date_format :default
      end
      field :updated_at do
        read_only true
        date_format :default
      end
      field :role
    end
  end
  
end
