require 'audited'
require 'audited_async/version'
require 'audited_async/configurator'
require 'audited_async/audit_async_job'

module AuditedAsync
  class << self
    def logger
      @logger ||= begin
        if defined?(::Rails)
          ::Rails.logger
        else
          require 'logger'

          Logger.new
        end
      end
    end

    def configure
      yield configurator
    end

    def config
      configurator
    end

    private

    def configurator
      @configurator ||= AuditedAsync::Configurator.new
    end
  end
end

module Audited::Auditor::ClassMethods
  attr_reader :audited_async_enabled

  _audited = instance_method :audited

  define_method :audited do |options = {}|
    @audited_async_enabled = options.fetch(:async, false) && AuditedAsync.config.enabled?

    _audited.bind(self).call(options)
  end

  alias audited_async_enabled? audited_async_enabled
end

module Audited::Auditor::AuditedInstanceMethods
  _audit_create  = instance_method :audit_create
  _audit_update  = instance_method :audit_update
  _audit_destroy = instance_method :audit_destroy

  def audited_async_enabled?
    self.class.auditing_enabled && self.class.audited_async_enabled?
  end

  define_method :audit_create do
    return _audit_create.bind(self).call unless audited_async_enabled?

    perform_async_audit 'create'
  end

  define_method :audit_update do
    return _audit_update.bind(self).call unless audited_async_enabled?

    unless (changes = audited_changes).empty? && (audit_comment.blank? || audited_options[:update_with_comment_only] == false)
      perform_async_audit('update', changes)
    end
  end

  define_method :audit_destroy do
    return _audit_destroy.bind(self).call unless audited_async_enabled?

    perform_async_audit 'destroy' unless new_record?
  end

  def perform_async_audit(method, changes = nil)
    AuditedAsync.config
                .job
                .set(AuditedAsync.config.job_options)
                .perform_later class_name: self.class.name,
                               record_id: send(self.class.primary_key.to_sym),
                               action: method,
                               audited_changes: (changes || audited_attributes).to_json,
                               comment: audit_comment
  end
end
