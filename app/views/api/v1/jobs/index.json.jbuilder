json.array! @jobs do |data|
  json.merge! data.attributes.except(
    'created_at',
    'updated_at'
  )
  json.extract! data.employer, :company_name
end