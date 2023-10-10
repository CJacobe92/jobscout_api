json.merge! @current_employer.attributes

json.jobs @current_employer.jobs do |job|
  json.merge! job.attributes.except('updated_at')
end