require 'rails_helper'

RSpec.describe "Index Api", :type => :api do
  describe('/') do
    it('should return static API information') do
      get('/')

      expect(last_response).to be_ok
      expect(last_response.body).to be_json_eql("test".to_json).at_path('env')
      expect(last_response.body).to be_json_eql("http://example.org/login".to_json).at_path('api/login')
      expect(last_response.body).to be_json_eql("http://example.org/account".to_json).at_path('api/account')
      expect(last_response.body).to be_json_eql("http://example.org/raids".to_json).at_path('api/raids')
      expect(last_response.body).to be_json_eql("http://example.org/raids/:id".to_json).at_path('api/raid')
      expect(last_response.body).to be_json_eql("http://example.org/raids/:id/signups".to_json).at_path('api/signups')
      expect(last_response.body).to be_json_eql("http://example.org/raids/:id/signups/:id".to_json).at_path('api/signup')
      expect(last_response.body).to be_json_eql("http://example.org/raids/:id/permissions".to_json).at_path('api/permissions')
      expect(last_response.body).to be_json_eql("http://example.org/raids/:id/permissions/:id".to_json).at_path('api/permission')
      expect(last_response.body).to have_json_path('sites/website')
      expect(last_response.body).to have_json_path('sites/docs')
    end
  end
end
