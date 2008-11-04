require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [ :active_resource ]

  config.action_controller.session = {
    :session_key => '_demo_session',
    :secret      => '7d335e0169857cce16b2b0bb98acb77730263c9ab4c37add6960974d5a805b2443b5d20974202ca85e576b47447bf8d33b28cae1d0bc32cb8e3585f31bd72021'
  }
  
  config.load_paths += %W(  #{RAILS_ROOT}/app/observers
                            #{RAILS_ROOT}/app/mailers
                            #{RAILS_ROOT}/app/presenters )
  
  config.action_controller.session_store = :active_record_store

  config.active_record.observers = :post_observer
end
