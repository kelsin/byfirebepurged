require 'rails_helper'

RSpec.describe "Account Api", :type => :api do
  before do
    header 'Accept', 'application/json+ember'
  end

  describe '/account' do
    describe 'while logged out' do
      it 'should return unauthorized' do
        get '/account'

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end
    end

    describe 'while logged in' do
      before do
        login
      end

      it 'should return account information' do
        get '/account'

        expect(last_response).to be_ok
        expect(last_response.body).to be_json_eql(@account.battletag.to_json).at_path('account/battletag')
        expect(last_response.body).to be_json_eql(@account.account_id.to_s.to_json).at_path('account/account_id')
        expect(last_response.body).to be_json_eql(@account.id.to_json).at_path('account/id')
      end

      describe 'with 2 characters' do
        before do
          @character1 = create(:character,
                               :account => @account)
          @character2 = create(:character,
                               :guild => @character1.guild,
                               :account => @account)
        end

        it 'should include both characters with the account' do
          get '/account'

          expect(last_response).to be_ok
          expect(last_response.body).to have_json_size(2).at_path("account/characters")
          expect(last_response.body).to have_json_size(2).at_path("characters")
          expect(last_response.body).to have_json_size(1).at_path("guilds")
          expect(last_response.body).to have_json_size(0).at_path("roles")
          expect(last_response.body).to have_json_size(4).at_path("permissions")
        end
      end
    end
  end
end
