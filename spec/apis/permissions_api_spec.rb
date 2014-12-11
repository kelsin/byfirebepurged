require 'rails_helper'

RSpec.describe 'Permission Api', :type => :api do
  before do
    header 'Accept', 'application/json+ember'
  end

  describe 'with a valid raid' do
    before do
      @raid = create :raid
    end

    describe 'while logged in with member permission' do
      before do
        login
        @raid.permissions << Permission.new(:level => 'member',
                                            :key => @account.to_permission)
        @permission = Permission.new(:level => 'member',
                                     :key => 'Guild|Name:Realm')
        @raid.permissions << @permission
      end

      it 'GET /raids/{id} should not contain permissions' do
        get "/raids/#{@raid.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to_not have_json_path('permissions')
      end

      it 'GET /raids/{id}/permissions should return unauthorized' do
        get "/raids/#{@raid.id}/permissions"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'POST /raids/{id}/permissions should return unauthorized' do
        post "/raids/#{@raid.id}/permissions", {
               :permission => {
                 :key => 'Account|99999',
                 :level => 'member' }}

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'POST /permissions should return unauthorized' do
        post '/permissions', {
               :permission => {
                 :permissioned_id => @raid.id,
                 :permissioned_type => 'Raid',
                 :key => 'Account|99999',
                 :level => 'member' }}

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)
      end

      it 'DELETE /raids/{id}/permissions/{id} should return unauthorized' do
        delete "/raids/#{@raid.id}/permissions/#{@permission.id}"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)

        expect(Permission.where(:id => @permission.id).count).to equal(1)
      end

      it 'DELETE /permissions/{id} should return unauthorized' do
        delete "/permissions/#{@permission.id}"

        expect(last_response).to_not be_ok
        expect(last_response.status).to equal(401)

        expect(Permission.where(:id => @permission.id).count).to equal(1)
      end
    end

    describe 'while logged in with admin permission' do
      before do
        login
        @raid.permissions << Permission.new(:level => 'admin',
                                            :key => @account.to_permission)
        @permission = Permission.new(:level => 'member',
                                     :key => 'Guild|Name:Realm')
        @raid.permissions << @permission
      end

      it 'GET /raids/{id} should contain permissions' do
        get "/raids/#{@raid.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permissions')
      end

      it 'GET /raids/{id}/permissions should contain permissions' do
        get "/raids/#{@raid.id}/permissions"

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permissions')
      end

      it 'POST /raids/{id}/permissions should create a permission' do
        post "/raids/#{@raid.id}/permissions", {
               :permission => {
                 :key => 'Account|99999',
                 :level => 'member' }}

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permission')
        expect(last_response.body).to be_json_eql('Account|99999'.to_json).at_path('permission/key')
        expect(last_response.body).to be_json_eql('member'.to_json).at_path('permission/level')
      end

      it 'POST /permissions should create a permission' do
        post '/permissions', {
               :permission => {
                 :permissioned_id => @raid.id,
                 :permissioned_type => 'Raid',
                 :key => 'Account|99999',
                 :level => 'member' }}

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permission')
        expect(last_response.body).to be_json_eql('Account|99999'.to_json).at_path('permission/key')
        expect(last_response.body).to be_json_eql('member'.to_json).at_path('permission/level')
      end

      it 'DELETE /raids/{id}/permissions/{id} should delete a permission' do
        delete "/raids/#{@raid.id}/permissions/#{@permission.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permission')
        expect(last_response.body).to be_json_eql('Guild|Name:Realm'.to_json).at_path('permission/key')
        expect(last_response.body).to be_json_eql('member'.to_json).at_path('permission/level')

        expect(Permission.where(:id => @permission.id).count).to equal(0)
      end

      it 'DELETE /permissions/{id} should delete a permission' do
        delete "/permissions/#{@permission.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to have_json_path('permission')
        expect(last_response.body).to be_json_eql('Guild|Name:Realm'.to_json).at_path('permission/key')
        expect(last_response.body).to be_json_eql('member'.to_json).at_path('permission/level')

        expect(Permission.where(:id => @permission.id).count).to equal(0)
      end
    end
  end
end
