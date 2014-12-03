json.raids @raids do |raid|
  json.partial! 'raids/raid', :raid => raid
end
