module AuditedAsync
  class Configurator
    attr_accessor :enabled, :job_name

    def initialize
      @enabled  = true
      @job_name = 'AuditedAsync::AuditAsyncJob'
    end

    alias enabled? enabled

    def job
      @job_name.constantize
    end
  end
end
