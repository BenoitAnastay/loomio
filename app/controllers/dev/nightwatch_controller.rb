class Dev::NightwatchController < Dev::BaseController
  include Dev::NintiesMoviesHelper
  include PrettyUrlHelper

  include Dev::Scenarios::Util
  include Dev::Scenarios::Auth
  include Dev::Scenarios::Dashboard
  include Dev::Scenarios::Discussion
  include Dev::Scenarios::EmailSettings
  include Dev::Scenarios::Group
  include Dev::Scenarios::Inbox
  include Dev::Scenarios::JoinGroup
  include Dev::Scenarios::MembershipRequest
  include Dev::Scenarios::Membership
  include Dev::Scenarios::Notification
  include Dev::Scenarios::Profile
  include Dev::Scenarios::Tags

  before_action :redis_flushall, except: [
    :last_email,
    :use_last_login_token,
    :index,
    :accept_last_invitation,
  ]
  before_action :cleanup_database, except: [
    :last_email,
    :use_last_login_token,
    :index,
    :accept_last_invitation,
  ]


  def redis_flushall
    CHANNELS_REDIS_POOL.with do |client|
      client.flushall
    end
  end
end
