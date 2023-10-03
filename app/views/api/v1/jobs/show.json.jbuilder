json.merge! @current_job.attributes.except(
  'created_at',
  'updated_at'
)

json.extract! @current_job.employer, :company_name
