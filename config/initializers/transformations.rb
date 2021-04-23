ActiveStorage.extend(Module.new do
  def transformations
    return @transformations if defined?(@transformations)

    files = [
      Rails.root.join("config", "transformations.yml"),
      # fallback to default config
      Pathname.new(File.join(__dir__, "transformations.yml"))
    ]

    file = files.detect(&:exist?)

    @transformations = YAML.load_file(file).deep_symbolize_keys!

    raise ArgumentError, "Variant called :medium is missing in #{file}" unless
      @transformations.key?(:medium)

    @transformations
  end
end)