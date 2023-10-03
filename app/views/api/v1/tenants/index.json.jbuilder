json.array! @tenants do |data|
  json.merge! data.attributes.except('activation_token')
end