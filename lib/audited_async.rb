require 'audited'
require 'audited_async/version'
require 'audited_async/configurator'
require 'audited_async/audit_async_job'

module AuditedAsync
  class << self
    attr_reader :configurator

    alias config configurator

    def configure
      @configurator = AuditedAsync::Configurator.new

      yield @configurator
    end
  end
end

module Audited::Auditor::AuditedInstanceMethods
  def audit_create
    return super unless AuditedAsync.config.enabled?
    perform_async_audit 'create'
  end

  def audit_update
    return super unless AuditedAsync.config.enabled?
    unless (changes = audited_changes).empty? && audit_comment.blank?
      perform_async_audit 'update'
    end
  end

  def audit_destroy
    return super unless AuditedAsync.config.enabled?
    perform_async_audit 'destroy' unless new_record?
  end

  def perform_async_audit(method)
    AuditedAsync.config.job.perform_later class_name: self.class.name,
                                          record_id: send(self.class.primary_key.to_sym),
                                          action: method,
                                          audited_changes: audited_attributes.to_json,
                                          comment: audit_comment
  end
end
