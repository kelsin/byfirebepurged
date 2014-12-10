require 'rails_helper'

RSpec.describe "Raids Api", :type => :api do
  before do
    header 'Accept', 'application/json+ember'
  end

  describe 'while logged out' do
    it 'GET /raids should return a 401' do
      get '/raids'

      expect(last_response).to_not be_ok
      expect(last_response.status).to equal(401)
    end

    it 'GET /raids/{id} should return a 401' do
      get '/raids/1'

      expect(last_response).to_not be_ok
      expect(last_response.status).to equal(401)
    end

    it 'PUT /raids/{id} should return a 401' do
      put '/raids/1', { :raid => { :name => 'New Raid Name' } }

      expect(last_response).to_not be_ok
      expect(last_response.status).to equal(401)
    end
  end

  describe 'while logged in' do
    before do
      login
    end

    describe 'with no raids' do
      it '/raids should return an empty result' do
        get '/raids'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_size(0).at_path("raids")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it '/raids/{id} should return a 401' do
        get '/raids/1'

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'PUT /raids/{id} should return a 404' do
        put '/raids/1', { :raid => { :name => 'New Raid Name' } }

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(404)
      end
    end

    describe 'with a no-permission raid' do
      before do
        @raid = create :raid
      end

      it '/raids should return an empty result' do
        get '/raids'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_size(0).at_path("raids")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it "/raids/{id} should return a 401" do
        get "/raids/#{@raid.id}"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'PUT /raids/{id} should return a 401' do
        put "/raids/#{@raid.id}", { :raid => { :name => 'New Raid Name' } }

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end
    end

    describe 'with a wrong-permission raid' do
      before do
        @raid = create :raid
        @raid.permissions << Permission.new(:level => 'member',
                                            :key => 'Account|99999')
      end

      it '/raids should return an empty result' do
        get '/raids'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_size(0).at_path("raids")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it "/raids/{id} should return a 401" do
        get "/raids/#{@raid.id}"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'PUT /raids/{id} should return a 401' do
        put "/raids/#{@raid.id}", { :raid => { :name => 'New Raid Name' } }

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end
    end

    describe 'with a account-permission raid' do
      before do
        @raid = create :raid
        @raid.permissions << Permission.new(:level => 'member',
                                            :key => @account.to_permission)
      end

      it '/raids should return 1 result' do
        get '/raids'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_size(1).at_path("raids")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it '/raids/{id} should return a raid' do
        get "/raids/#{@raid.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to be_json_eql(@raid.name.to_json).at_path("raid/name")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it 'PUT /raids/{id} should return a 401' do
        put '/raids/1', { :raid => { :name => 'New Raid Name' } }

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end
    end

    describe 'with a admin-permission raid' do
      before do
        @raid = create :raid
        @raid.permissions << Permission.new(:level => 'admin',
                                            :key => @account.to_permission)
      end

      it '/raids should return 1 result' do
        get '/raids'

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_size(1).at_path("raids")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it '/raids/{id} should return a raid' do
        get "/raids/#{@raid.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to be_json_eql(@raid.name.to_json).at_path("raid/name")
        expect(last_response.body).to have_json_size(0).at_path("signups")
        expect(last_response.body).to have_json_size(0).at_path("characters")
        expect(last_response.body).to have_json_size(0).at_path("guilds")
        expect(last_response.body).to have_json_size(0).at_path("roles")
      end

      it 'PUT /raids/{id} should edit the raid' do
        put "/raids/#{@raid.id}", { :raid => { :name => 'New Raid Name' } }

        expect(last_response).to be_ok

        @raid.reload
        expect(@raid.name).to eql('New Raid Name')
      end
    end

    describe 'with 2 characters' do
      before do
        @character1 = create(:character,
                             :account => @account)
        @guild = @character1.guild
        @character2 = create(:character,
                             :guild => @guild,
                             :account => @account)
      end

      describe 'with a guild-permission raid' do
        before do
          @raid = create :raid
          @raid.permissions << Permission.new(:level => 'member',
                                              :key => @guild.to_permission)
        end

        it '/raids should return 1 result' do
          get '/raids'

          expect(last_response).to be_ok
          expect(last_response.body).to have_json_size(1).at_path("raids")
          expect(last_response.body).to have_json_size(0).at_path("signups")
          expect(last_response.body).to have_json_size(0).at_path("characters")
          expect(last_response.body).to have_json_size(0).at_path("guilds")
          expect(last_response.body).to have_json_size(0).at_path("roles")
        end

        it '/raids/{id} should return a raid' do
          get "/raids/#{@raid.id}"

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(@raid.name.to_json).at_path("raid/name")
          expect(last_response.body).to have_json_size(0).at_path("signups")
          expect(last_response.body).to have_json_size(0).at_path("characters")
          expect(last_response.body).to have_json_size(0).at_path("guilds")
          expect(last_response.body).to have_json_size(0).at_path("roles")
        end

        it 'PUT /raids/{id} should return a 401' do
          put "/raids/#{@raid.id}", { :raid => { :name => 'New Raid Name' } }

          expect(last_response).to_not be_ok
          expect(last_response.status).to equal(401)
        end
      end

      describe 'with a character-permission raid' do
        before do
          @raid = create :raid
          @raid.permissions << Permission.new(:level => 'member',
                                              :key => @character1.to_permission)
        end

        it '/raids should return 1 result' do
          get '/raids'

          expect(last_response).to be_ok
          expect(last_response.body).to have_json_size(1).at_path("raids")
          expect(last_response.body).to have_json_size(0).at_path("signups")
          expect(last_response.body).to have_json_size(0).at_path("characters")
          expect(last_response.body).to have_json_size(0).at_path("guilds")
          expect(last_response.body).to have_json_size(0).at_path("roles")
        end

        it '/raids/{id} should return a raid' do
          get "/raids/#{@raid.id}"

          expect(last_response).to be_ok
          expect(last_response.body).to be_json_eql(@raid.name.to_json).at_path("raid/name")
          expect(last_response.body).to have_json_size(0).at_path("signups")
          expect(last_response.body).to have_json_size(0).at_path("characters")
          expect(last_response.body).to have_json_size(0).at_path("guilds")
          expect(last_response.body).to have_json_size(0).at_path("roles")
        end

        it 'PUT /raids/{id} should return a 401' do
          put "/raids/#{@raid.id}", { :raid => { :name => 'New Raid Name' } }

          expect(last_response).to_not be_ok
          expect(last_response.status).to equal(401)
        end
      end
    end
  end
end
