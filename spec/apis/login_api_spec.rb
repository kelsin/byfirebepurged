require 'rails_helper'

HOST = 'http://example.org'
REDIRECT = 'https://localhost/?code='

RSpec.describe "Login Api", :type => :api do
  before do
    header 'Accept', 'application/json+ember'
  end

  describe('/login') do
    it('should error if a redirect url is not given') do
      get('/login')

      expect(last_response).to_not be_ok
    end

    it('should error if a bad redirect url is given') do
      get('/login',
          { :redirect => 'bad url' })

      expect(last_response).to_not be_ok
    end

    it('should error if a non-http/s redirect url is given') do
      get('/login',
          { :redirect => 'smtp://localhost' })

      expect(last_response).to_not be_ok
    end

    it('should succeed if a http redirect url is given') do
      get('/login',
          { :redirect => 'http://localhost/?code=' })

      expect(last_response).to be_ok
      expect(Login.count).to equal(1)

      expect(last_response.body).to have_json_path('method')
      expect(last_response.body).to have_json_path('href')
      expect(last_response.body).to include_json((HOST + "/auth/bnet?key=#{Login.first.key}").to_json)
    end

    it('should succeed if a https redirect url is given') do
      get('/login',
          { :redirect => REDIRECT })

      expect(last_response).to be_ok
      expect(Login.count).to equal(1)

      expect(last_response.body).to have_json_path('method')
      expect(last_response.body).to have_json_path('href')
      expect(last_response.body).to include_json((HOST + "/auth/bnet?key=#{Login.first.key}").to_json)
    end
  end

  describe 'with a valid Login' do
    before do
      get('/login',
          { :redirect => REDIRECT })

      @login = Login.first
      @login_response = last_response
    end

    it 'should redirect when attempt to follow the link' do
      get JSON.parse(@login_response.body)['href'].sub(HOST, '')

      expect(last_response).to be_redirect

      VCR.use_cassette 'create_session' do
        get last_response['Location'].sub(HOST, '')
      end

      key = last_response['Location'].sub(REDIRECT, '')
      expect(Session.where(:key => key).count).to equal(1)
    end
  end

  describe '/logout' do
    it 'should return a unauthorized error with no session' do
      expect(Session.count).to equal(0)

      get '/logout'

      expect(last_response.status).to equal(401)
      expect(Session.count).to equal(0)
    end

    describe 'with a valid session' do
      before do
        login
      end

      it 'should log the user out and destory the session' do
        expect(Session.count).to equal(1)

        get '/logout'

        expect(last_response).to be_ok
        expect(last_response.body).to be_json_eql(true.to_json).at_path('logged_out')
        expect(Session.count).to equal(0)
      end
    end
  end
end
