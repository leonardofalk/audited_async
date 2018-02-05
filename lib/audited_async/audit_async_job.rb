require 'active_job'

class AuditedAsync::AuditAsyncJob < ActiveJob::Base
  queue_as :audits

  def perform(attributes)
    klass = attributes.delete(:class_name).constantize
    model = klass.find_by(klass.primary_key.to_sym => attributes.delete(:record_id))
    attributes[:audited_changes] = JSON.parse(attributes[:audited_changes])
    model.send(:write_audit, attributes)
  end
end
