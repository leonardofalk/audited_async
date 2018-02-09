RSpec.describe AuditedAsync::Configurator do
  before :each do
    AuditedAsync.configure do |config|
      config.enabled = false

      config.job_name = 'JobityJob'
    end
  end

  describe '#enabled?' do
    it 'has a default value' do
      expect(subject.enabled?).to be true
    end

    it 'is set as false' do
      expect(AuditedAsync.config.enabled?).not_to be true
    end
  end

  describe '#enabled' do
    it 'has a default value' do
      expect(subject.enabled).to be true
    end

    it 'is set as false' do
      expect(AuditedAsync.config.enabled).not_to be true
    end
  end

  describe '#job_name' do
    it 'has a default value' do
      expect(subject.job_name).to eq 'AuditedAsync::AuditAsyncJob'
    end

    it 'has a new value' do
      expect(AuditedAsync.config.job_name).to eq 'JobityJob'
    end
  end

  describe '#job' do
    it 'has a default value' do
      expect(subject.job).to eq AuditedAsync::AuditAsyncJob
    end

    it 'it fails with a unitialized constant error' do
      expect do
        AuditedAsync.config.job
      end.to raise_error(NameError)
    end
  end
end
