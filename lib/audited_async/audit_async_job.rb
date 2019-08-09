require 'active_job'

class AuditedAsync::AuditAsyncJob < ActiveJob::Base
  queue_as :audits

  def perform(args)
    klass, id, changes = extract_auditing_elements(args)

    record = klass.unscoped.find_by(klass.primary_key.to_sym => id)

    return alert_record_not_found(klass, id) unless record

    record.send(:write_audit, changes)
  end

  private

  def extract_auditing_elements(args)
    return [args[:class_name].safe_constantize, args[:record_id], extract_audit_changes(args)]
  end

  def extract_audit_changes(args)
    args.except(:class_name, :record_id).merge(audited_changes: JSON.parse(args[:audited_changes]))
  end

  def alert_record_not_found(klass, id)
    AuditedAsync.logger.error "AuditedAsync: #{klass} record with id '#{id}' not found, ignoring audit write."
  end
end
