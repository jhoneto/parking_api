class ApplicationService
  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  def call
    raise NotImplementedError, "Subclasses must implement the call method"
  end

  private

  def success(data = {})
    @result = ServiceResult.new(success: true, data: data)
  end


  def failure(errors, data = {})
    errors_array = errors.is_a?(Array) ? errors : [ errors ]
    @result = ServiceResult.new(success: false, errors: errors_array, data: data)
  end


  class ServiceResult
    attr_reader :data, :errors

    def initialize(success:, data: {}, errors: [])
      @success = success
      @data = data
      @errors = errors
    end

    def success?
      @success
    end

    def failure?
      !@success
    end

    def error_message
      @errors.join(", ")
    end
  end
end
