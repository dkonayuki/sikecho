# Be sure to restart your server when you modify this file.

# login for all subdomain in lvh.me
Shikechou::Application.config.session_store :cookie_store, key: '_shikechou_session', domain: '.lvh.me'
    
