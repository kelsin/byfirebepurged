json.api do
  json.login login_url
end

json.env Rails.env

json.sites do
  json.website 'http://byfirebepurged.com/'
  json.docs 'http://docs.byfirebepurged.com/'
end
