require 'rails_helper'

RSpec.describe 'Raids Api', :type => :api do
  before do
    header 'Accept', 'application/json+ember'
  end

  describe 'with a valid raid' do
    before do
      @raid = create :raid
    end

    describe 'while logged out' do
      it 'GET /raids/{id}/signups should return a 401' do
        get "/raids/#{@raid.id}/signups"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end
    end

    describe 'while logged in with 2 characters' do
      before do
        login
        @character1 = create(:character,
                             :account => @account)
        @guild = @character1.guild
        @character2 = create(:character,
                             :guild => @guild,
                             :account => @account)
      end

      it 'GET /raids/{id}/signups should return a 401' do
        get "/raids/#{@raid.id}/signups"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      describe 'with member permission' do
        before do
          @raid.permissions << Permission.new(:level => 'member',
                                              :key => @account.to_permission)
        end

        describe 'with no signups' do
          it 'GET /raids/{id}/signups should return an empty result' do
            get "/raids/#{@raid.id}/signups"

            expect(last_response).to be_ok
            expect(last_response.body).to have_json_size(0).at_path('signups')
            expect(last_response.body).to have_json_size(0).at_path('characters')
            expect(last_response.body).to have_json_size(0).at_path('guilds')
            expect(last_response.body).to have_json_size(3).at_path('roles')
          end

          it 'POST /raids/{id}/signups should create a signup' do
            post "/raids/#{@raid.id}/signups", {
                   :signup => {
                     :raid_id => @raid.id,
                     :character_id => @character1.id,
                     :note => 'Note',
                     :role_ids => [@dps.id] }}

            expect(last_response).to be_ok
            expect(last_response.body).to be_json_eql('Note'.to_json).at_path('signup/note')
            expect(last_response.body).to be_json_eql([@dps.id].to_json).at_path('signup/roles')
            expect(last_response.body).to have_json_size(1).at_path('characters')
            expect(last_response.body).to have_json_size(1).at_path('guilds')
            expect(last_response.body).to have_json_size(3).at_path('roles')
          end

          it 'POST /raids/{id}/signups with ember style param names should create a signup' do
            post "/raids/#{@raid.id}/signups", {
                   :signup => {
                     :raid => @raid.id,
                     :character => @character1.id,
                     :note => 'Note',
                     :roles => [@dps.id] }}

            expect(last_response).to be_ok
            expect(last_response.body).to be_json_eql('Note'.to_json).at_path('signup/note')
            expect(last_response.body).to be_json_eql([@dps.id].to_json).at_path('signup/roles')
            expect(last_response.body).to have_json_size(1).at_path('characters')
            expect(last_response.body).to have_json_size(1).at_path('guilds')
            expect(last_response.body).to have_json_size(3).at_path('roles')
          end

          it 'POST /signups with ember style param names should create a signup' do
            post '/signups', {
                   :signup => {
                     :raid => @raid.id,
                     :character => @character1.id,
                     :note => 'Note',
                     :roles => [@dps.id] }}

            expect(last_response).to be_ok
            expect(last_response.body).to be_json_eql('Note'.to_json).at_path('signup/note')
            expect(last_response.body).to be_json_eql([@dps.id].to_json).at_path('signup/roles')
            expect(last_response.body).to have_json_size(1).at_path('characters')
            expect(last_response.body).to have_json_size(1).at_path('guilds')
            expect(last_response.body).to have_json_size(3).at_path('roles')
          end

          it 'POST /raids/{id}/signups with a bad character should fail' do
            post "/raids/#{@raid.id}/signups", {
                   :signup => {
                     :raid_id => @raid.id,
                     :character_id => 9999,
                     :note => 'Note',
                     :role_ids => [@dps.id] }}

            expect(last_response).to_not be_ok
            expect(last_response.status).to equal(404)
          end

          it 'POST /signups with a bad character should fail' do
            post '/signups', {
                   :signup => {
                     :raid_id => @raid.id,
                     :character_id => 9999,
                     :note => 'Note',
                     :role_ids => [@dps.id] }}

            expect(last_response).to_not be_ok
            expect(last_response.status).to equal(404)
          end

          it 'POST /signups with a bad raid should fail' do
            post '/signups', {
                   :signup => {
                     :raid_id => 9999,
                     :character_id => @character1.id,
                     :note => 'Note',
                     :role_ids => [@dps.id] }}

            expect(last_response).to_not be_ok
            expect(last_response.status).to equal(404)
          end

          it 'POST /raids/{id}/signups without a role should fail' do
            post "/raids/#{@raid.id}/signups", {
                   :signup => {
                     :raid_id => @raid.id,
                     :character_id => @character1.id,
                     :note => 'Note',
                     :role_ids => [] }}

            expect(last_response).to_not be_ok
            expect(last_response.status).to equal(400)
          end

          it 'POST /signups without a role should fail' do
            post '/signups', {
                   :signup => {
                     :raid_id => @raid.id,
                     :character_id => @character1.id,
                     :note => 'Note',
                     :role_ids => [] }}

            expect(last_response).to_not be_ok
            expect(last_response.status).to equal(400)
          end
        end

        describe 'with a signup' do
          before do
            @signup = Signup.create(:raid => @raid,
                                    :character => @character1,
                                    :note => 'Note',
                                    :roles => [@dps])
          end

          it 'GET /raids/{id}/signups should return the signup' do
            get "/raids/#{@raid.id}/signups"

            expect(last_response).to be_ok
            expect(last_response.body).to have_json_size(1).at_path('signups')
            expect(last_response.body).to be_json_eql('Note'.to_json).at_path('signups/0/note')
            expect(last_response.body).to have_json_size(1).at_path('characters')
            expect(last_response.body).to have_json_size(1).at_path('guilds')
            expect(last_response.body).to have_json_size(3).at_path('roles')
          end
        end
      end
    end
  end
end
