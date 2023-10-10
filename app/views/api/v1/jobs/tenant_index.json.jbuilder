json.data do
  json.array! @jobs do |data|
    json.merge! data.attributes.except(
      'created_at',
      'updated_at'
    )
    json.extract! data.employer, :company_name, :tenant_id
  end
end 

json.meta do
  json.total_pages @jobs.total_pages
  json.current_page @jobs.current_page
  json.per_page @jobs.limit_value
  json.total_count @jobs.total_count
end