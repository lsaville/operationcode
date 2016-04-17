﻿require 'rails_helper'
require 'slack/utils'

describe Slack::Utils do
  # Set up Sclack::Client
  before(:all) do
    @slack_utils = Slack::Utils.new()
  end

  describe 'confirming email is registered' do
    before(:all) do
      @fetch_url = URI.join(
        "https://#{@slack_utils.client.domain}",
        Slack::USERS_LIST_PATH).to_s
    end

    before(:each) do
      stub_request(:post, /#{Regexp.quote(@fetch_url)}.*/).to_return(
        status: 200,
        body: '{"ok":true,
               "members": [ { "profile": { "email": "first@example.com" } },
                            { "profile": { "email": "second@example.com" } },
                            { "profile": { "email": "third@example.com" } } ]
        }',
        headers: {}
      )
    end

    it 'returns true if email is a member email' do
      expect(@slack_utils.email_is_registered?('second@example.com')).to equal true
    end

    it 'returns false if email is not a member email' do
      expect(@slack_utils.email_is_registered?('false@example.com')).to equal false
    end
  end
end





