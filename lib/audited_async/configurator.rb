module AuditedAsync
  class Configurator
    attr_accessor :enabled, :job_name, :job_options

    def initialize
      @enabled     = true
      @job_name    = 'AuditedAsync::AuditAsyncJob'
      @job_options = { wait: 1.second }
    end

    def job_options
      @job_options || {}
    end

    alias enabled? enabled

    def job
      @job_name.constantize
    end
  end
end
