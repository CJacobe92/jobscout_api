json.data do
  json.array! @employers do |data|
    json.merge! data.attributes
  end
end 

json.meta do
  json.total_pages @employers.total_pages
  json.current_page @employers.current_page
  json.per_page @employers.limit_value
  json.total_count @employers.total_count
end