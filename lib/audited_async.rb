require 'active_support'
require 'audited_async/version'
require 'audited_async/audit_async_job'

module Audited::Auditor::AuditedInstanceMethods
  def audit_create
    perform_async_audit 'create'
  end

  def audit_update
    unless (changes = audited_changes).empty? && audit_comment.blank?
      perform_async_audit 'update'
    end
  end

  def audit_destroy
    perform_async_audit 'destroy' unless new_record?
  end

  def perform_async_audit(method)
    AuditedAsync::AuditAsyncJob.perform_later class_name: self.class.name,
                                              record_id: send(self.class.primary_key.to_sym),
                                              action: method,
                                              audited_changes: serialized_audited_attributes.to_json,
                                              comment: audit_comment
  end
end
